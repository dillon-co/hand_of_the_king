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
require 'watir-webdriver'
require 'watir-webdriver/wait'
require 'headless'

class JobApplication < ActiveRecord::Base
  belongs_to :job_link
  after_save :apply_to_job#, unless: :applied_to 

  def fill_out_modal_with_text_first(input_frame)
    fill_out_text_form(input_frame)
    if input_frame.button(id: 'apply').present?
      input_frame.button(id: 'apply').click
    else  
      input_frame.a(class: 'form-page-next').click
      click_checkboxes
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
    fill_out_name(input_frame)
    input_frame.text_field(id: 'applicant.email').set user_email#user.email
    input_frame.text_field(id: 'applicant.phoneNumber').set user_phone_number#user.phone_number if user.phone_number != nil
    input_frame.file_field.set '/Users/dilloncortez/documents/tech_resume_january_2016.pdf'#job_link.user.resume.path
    input_frame.text_field(id: 'applicant.applicationMessage').set user_cover_letter
  end  

  def click_checkboxes(input_frame)
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
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new 
    browser.goto indeed_link
    browser.span(class: 'indeed-apply-widget').click
    sleep 3.5
    if browser.iframe(id: /indeed-ia/).exists?
      input_frame = browser.iframe(id: /indeed-ia/).iframe
      if input_frame.text_field.present? 
        fill_out_modal_with_text_first(input_frame)     
      else
        fill_out_modal_with_text_last(input_frame)
      end  
      self.update(applied_to: true) 
    end  
  end  
  browser.close
  headless.destroy
end

