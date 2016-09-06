# == Schema Information
#
# Table name: job_links
#
#  id            :integer          not null, primary key
#  job_title     :string
#  job_type      :string
#  job_subtitles :string
#  job_location  :string
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'indeed_search_worker'
require 'job_application_worker'
require 'mechanize'
require 'open-uri'

class JobLink < ActiveRecord::Base

  belongs_to :user
  has_many :job_applications
  after_create  :run_search #:call_search_worker
  after_update :call_application_worker
  # validates_presence_of :job_title
  accepts_nested_attributes_for :job_applications

  has_attached_file :user_resume 
  validates_attachment :user_resume,
                       :content_type => {:content_type => %w(
                        image/jpeg
                        image/jpg 
                        image/png
                        application/pdf 
                        application/msword 
                        application/vnd.openxmlformats-officedocument.wordprocessingml.document)}

  ## Solution: save each paginated page in an array and run an each loop on that

  def run_search
    agent = Mechanize.new 
    agent.get('http://www.indeed.com/')
    fill_out_search_form(agent)
    search_and_create_job_application(agent)
  end

  def fill_out_search_form(agent)
    form = agent.page.forms[0]
    form["q"] = job_title
    form["l"] =  job_location
    form.submit
  end 


  def search_and_create_job_application(agent)
    path_to_resume = resume_key
    @counter = 0
    search_page = agent.page
    available_jobs = Array.new
    until @counter == 12
      begin 
        search_page = agent.page
          agent.page.search(".result:contains('Easily apply')").each do |title|
            # byebug
            title.at("h2") != nil ? t = title.at("h2").text  : t = ''
            title.at(".company") != nil ? c = title.at(".company").text  : c = 'Unknown Company'
            title.at(".location") != nil ? l = title.at(".location").text  : l = 'Unknown location'
            job_title_company_location_array = [t, c, l]
            next if job_applications.where(title: job_title_company_location_array[0], company: job_title_company_location_array[1]).any? || !(agent.page.uri.to_s.match(/indeed.com/))
            indeed_job_address = "http://www.indeed.com#{title.at('a').attributes['href'].value}"
            
            available_jobs << add_available_jobs_to_array(agent, title, job_title_company_location_array, path_to_resume, indeed_job_address)
          end 
      rescue Exception => e
         puts "\n\n#{e}\n\n"
         # byebug
         next 
      end  
      break if !(search_page.at_css(".np:contains('Next »')"))
      indeed_base = search_page.uri.to_s.split("&start").first
      next_page = "#{indeed_base}&start=#{@counter+=1}0"
      agent.get next_page
      puts "===\n\n#{agent.page.uri}"
    end
    create_job_applications(available_jobs) 
    done_searching = true  
  end  

  def create_job_applications(available_jobs_array)
    puts "\n\n#{'===='*40}\n\n\n -----CREATING JOB APPLICATIONS WITH ARRAY----- \n\n\n\n\n\n"
    job_applications.create(available_jobs_array)
  end  

  def add_available_jobs_to_array(agent, title, job_attributes, path_to_resume, indeed_job_url)
    puts "\n\n#{'===='*40}\n -----CREATING HASH FROM----- \n#{agent.page.uri}\n\n"
    if user != nil
        return  {
                 indeed_link: indeed_job_url,
                 title: job_attributes[0],
                 company: job_attributes[1], 
                 location: job_attributes[2], 
                 user_name: user_attribute_array[0],
                 user_email: user_attribute_array[1],
                 user_phone_number: user_attribute_array[2],
                 user_resume_path: path_to_resume,
                 user_cover_letter: user_attribute_array[3]
                 }
    else
        return {
                indeed_link: indeed_job_url,
                title: job_attributes[0],
                company: job_attributes[1], 
                location: job_attributes[2],     
              }
    end
  end  


  def user_attribute_array
    ["#{user.first_name} #{user.last_name}", user.email, user.phone_number, user.cover_letter]
  end


  def resume_key
    user != nil ? user.resume.url.split('http://s3.amazonaws.com/job-bot-bucket/').last.split('?').first : user_resume.url.split('http://s3.amazonaws.com/job-bot-bucket/').last.split('?').first
  end  

  def update_job_applications_with_user_info
    job_applications.each do|j| 
      j.update(user_name: "#{user_first_name} #{user_last_name}",
        user_email: user_email,
        user_phone_number: user_phone_number,
        user_resume_path: resume_key,
        user_cover_letter: user_cover_letter 
                                        )
      j.apply_to_job if j.should_apply == true      
    end  
  end  

  def call_search_worker
    SearchWorker.perform_async(id)
  end  

  def call_application_worker
    if user_id != nil
      ApplicationWorker.perform_async(id)
    elsif user_first_name != nil
      UserLessApplicationWorker.perform_async(id)
    else
      puts "Still Editing."    
    end  
  end  
end

