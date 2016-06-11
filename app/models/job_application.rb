# == Schema Information
#
# Table name: job_applications
#
#  id          :integer          not null, primary key
#  indeed_link :string
#  title       :string
#  company     :string
#  location    :string
#  pay_rate    :string
#  pay_type    :integer
#  description :text
#  job_link_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'capybara/poltergeist'
require 'watir-webdriver'
require 'watir-webdriver/wait'

class JobApplication < ActiveRecord::Base
  belongs_to :job_link
  # after_save :apply_to_jobs

  def apply_to_jobs
    user = job_link.user
    browser = Watir::Browser.new
    browser.goto indeed_link
    browser.span(class: 'indeed-apply-widget').click
    sleep 3
    input_frame = browser.iframe(id: /indeed-ia/).iframe
    puts "\n\n\n\n===should go here =====>#{input_frame}<=========\n\n\n\n"
    input_frame.text_field(id: 'applicant.name').set "Dillon Cortez"#"#{user.first_name} #{user.last_name}"
    input_frame.text_field(id: 'applicant.email').set "dilloncortez@gmail.com"#user.email
    input_frame.text_field(id: 'applicant.phoneNumber').set "(801) 824 - 2592"#user.phone_number if user.phone_number != nil
    input_frame.file_field.set '/Users/dilloncortez/documents/tech_resume_january_2016.pdf'#job_link.user.resume.path
    input_frame.text_field(id: 'applicant.applicationMessage').set "A robot that I made applied to this job for me. :)"#user.cover_letter if user.cover_letter != nil
    # input_frame.a(class: 'form-page-next').click

    # browser.iframe(src: "https://apply.indeed.com/indeedapply/resumeapply?jobUrl=http…oGX0zRknJzn93dTVB7u7lUBULJAcFaEExQaMuoMRYdeP-ZRN9c_wrjf8zHNQ").wait_until_present

    # browser.input(id: 'applicant.name').set("Testing")
    # session = Capybara::Session.new(:poltergeist)
    # session.visit(indeed_link)
    # session.find(".indeed-apply-button").click
    # puts session.html
    # modal = session.driver.browser.window_handles.last
    # session.driver.switch_to_window(modal)

    # puts session.find("input")

    # name_input = session.find(:css, '.applicant')
    # session.fill_in("name", :with => "Test Tester")  
    # session.fill_in('#applicant.email', :with => 'test@demo.com')
    # session.click_button('#apply')

  end  
end

