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
#  applied_to        :boolean          default(FALSE)
#  pay_type          :integer
#  description       :text
#  job_link_id       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  should_apply      :boolean          default(TRUE)
#

require 'capybara/poltergeist'
require 'open-uri'
require 'watir-webdriver'
require 'watir-webdriver/wait'
require 'headless'

class JobApplication < ActiveRecord::Base
  belongs_to :job_link
  # after_save :apply_to_job, unless: :applied_to 

  def fill_out_modal_with_text_first(input_frame)
    fill_out_text_form(input_frame) 
    if input_frame.button(id: 'apply').present?
      input_frame.button(id: 'apply').click
      puts "applied"
    else  
      counter = 0 
      until counter == 3
        # Watir::Wait.until { input_frame.a(class: 'form-page-next').present? }
        if input_frame.links(class: 'form-page-next')[counter].present? 
          input_frame.links(class: 'form-page-next')[counter].click
          click_checkboxes(input_frame)
        else
          break  
        end  
          puts "#{counter+=1}"
      end  
      input_frame.button(id: 'apply').click
      puts "applied"
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
    upload_resume(input_frame)
    puts "writing cover letter"
    input_frame.text_field(id: 'applicant.applicationMessage').set user_cover_letter
  end  

  def click_checkboxes(input_frame)
    puts "checkin boxes"
    # byebug
    if input_frame.div(id: "q_0").present?
      puts "radio frame is present"
      %w(0 1 2 3 4).each do |question_number|
        if input_frame.div(id: "q_#{question_number}").present?
          puts "found radio # #{question_number}"
          input_frame.div(id: "q_#{question_number}").radio(value: "0").set
        else
          next
        end
      end
    end
    puts "boxes checked"
  end 

  def open_modal(browser)
    # byebug
    puts "not found"
    if browser.span(text: "Apply Now").exists?
      puts "found at browser.span(text: 'Apply Now')"
      browser.span(text: "Apply Now").click
      true
    elsif browser.span(id: /indeed-ia/).exists?
      puts "found at browser.span(id: /indeed-ia/)"
      browser.span(id: /indeed-ia/).click
      true
    elsif browser.a(id: /indeed-ia/).exists?
      puts "found at browser.a(id: /indeed-ia/)"
      browser.a(class: /indeed-id/).click
      true
    elsif browser.span(class: "indeed-apply-button-inner").exists?
      puts "found at browser.span(class: 'indeed-apply-button-inner')"
      browser.span(class: "indeed-apply-button-inner").click
    else 
      puts "cant find" 
      false  
    end  
  end 

  def apply_to_job
    @counter = 0
    if self.should_apply == true  
      until self.applied_to == true || @counter == 3
        begin 
        puts "\n\n\n\n\n#{'∞∞∞∞∞∞∞∞∞'*20}\n\n#{indeed_link} ---------- id: #{id}\n\n\n\n"

        browser = Watir::Browser.new :phantomjs, :args => ['--ssl-protocol=tlsv1']
        # browser.driver.manage.timeouts.implicit_wait = 3 #3 seconds
        browser.goto indeed_link
        if open_modal(browser)  
          puts "clicked modal button"
          sleep 3.5
          if browser.iframe(id: /indeed-ia/).exists?
            puts "found"
            input_frame = browser.iframe(id: /indeed-ia/).iframe
            if input_frame.text_field(id: 'applicant.name').present? || input_frame.text_field(id: 'applicant.firstName').present?  
                fill_out_modal_with_text_first(input_frame)        
            else
              fill_out_modal_with_text_last(input_frame)
            end  
            self.update(applied_to: true) 
          end    
        end
        rescue => e
          puts e
          break
        end  
        browser.close
        @counter += 1
      end
    end    
  end


  def upload_resume(input_frame)
    begin
      input_frame.file_field.set user_resume   
    ensure
      clean_up_temporary_binary_file
    end  
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
    File.open(local_file_path, "w+") { |f| f.write(resume_object(s3).read)}
    local_file_path
  end
  
  def local_file_path
    "public/#{user_resume_path.split('/').last}"
  end  

  def clean_up_temporary_binary_file
    File.delete(local_file_path)
  end  


  def resume_object(s3)
    s3.get_object(bucket: 'job-bot-bucket', key: user_resume_path).body
  end 

end

