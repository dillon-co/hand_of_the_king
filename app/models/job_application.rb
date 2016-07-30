# == Schema Information
#
# Table name: job_applications
#
#  id                :integer          not null, primary key
#  user_name         :string
#  user_email        :string
#  user_phone_number :string
#  user_resume_path  :string
#  user_cover_letter :string
#  indeed_link       :string
#  title             :string
#  company           :string
#  location          :string
#  pay_rate          :string
#  pay_type          :integer
#  description       :text
#  job_link_id       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'capybara/poltergeist'
require 'open-uri'
require 'watir-webdriver'
require 'watir-webdriver/wait'
require 'headless'

class JobApplication < ActiveRecord::Base
  belongs_to :job_link
  after_save :apply_to_job, unless: :applied_to 

  def fill_out_modal_with_text_first(input_frame)
    fill_out_text_form(input_frame)
    if input_frame.button(id: 'apply').present?
      puts "applying"
      input_frame.button(id: 'apply').click
    else  
      input_frame.a(class: 'form-page-next').click
      click_checkboxes(input_frame)
      puts "applying"
      input_frame.button(id: 'apply').click
    end        
  end 

  def fill_out_modal_with_text_last(input_frame)
    click_checkboxes(input_frame)
    fill_out_text_form(input_frame)
    input_frame.button(id: 'apply').click
  end

  def fill_out_name(input_frame)
    if input_frame.text_field(id: 'applicant.name').present?
      input_frame.text_field(id: 'applicant.name').set user_name
    else
      input_frame.text_field(id: 'applicant.firstName').set user_name.split(' ').first
      input_frame.text_field(id: 'applicant.lastName').set user_name.split(' ').last
    end  
  end 
  

  def fill_out_text_form(input_frame)
    puts "filling out name"
    fill_out_name(input_frame)
    puts "filling out email"
    input_frame.text_field(id: 'applicant.email').set user_email#user.email
    puts "filling out phone number"
    input_frame.text_field(id: 'applicant.phoneNumber').set user_phone_number#user.phone_number if user.phone_number != nil
    puts "uploading resume"
    input_frame.file_field.set user_resume#'/Users/dilloncortez/Documents/Tech_resume_january_2016.pdf'
    puts "writing cover letter"
    input_frame.text_field(id: 'applicant.applicationMessage').set user_cover_letter
  end  

  def click_checkboxes(input_frame)
    puts "checkin boxes"
    if input_frame.radio.present?
      %w(0 1 2 3 4).each do |question_number|
        if input_frame.div(id: "q_#{question_number}").exists?
          input_frame.div(id: "q_#{question_number}").radio(value: "0").set
        else
          break
        end
      end
    end
  end  

  def apply_to_job
    puts "\n\n\n\n\n#{'8'*20}#{indeed_link}\n\n\n\n"

    browser = Watir::Browser.new :phantomjs, :args => ['--ssl-protocol=tlsv1']
    browser.goto indeed_link
    browser.span(id: /indeed-ia/).click
    puts "clicked modal button"
    sleep 3.5
    if browser.iframe(id: /indeed-ia/).exists?
      input_frame = browser.iframe(id: /indeed-ia/).iframe
      if input_frame.text_field(id: 'applicant.name').present? || input_frame.text_field(id: 'applicant.firstName').present? 
        fill_out_modal_with_text_first(input_frame)     
      else
        fill_out_modal_with_text_last(input_frame)
      end  
      self.update(applied_to: true) 
    end  
    browser.close
  end

   def user_resume
    Aws.config.update({
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ENV['AMAZON_ACCESS_KEY_ID'], ENV['AMAZON_SECRET_ACCESS_KEY'])
    }) 
    s3 = Aws::S3::Client.new
    store_and_return_user_resume(s3)
  end 

  def store_and_return_user_resume(s3)
    f = Tempfile.new(['resume', ".#{user_resume_path.split('.').last}"])
    f.write(resume_object(s3).read)
    puts File.open(f)
    f.path  
  end

  def resume_object(s3)
    s3.get_object(bucket: 'job-bot-bucket', key: user_resume_path).body
  end 

end

