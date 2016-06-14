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
require 'mechanize'
require 'open-uri'

class JobLink < ActiveRecord::Base

  belongs_to :user
  has_many :job_applications
  after_save :call_search_worker
  

  def run_search
    user_name, user_email, user_phone, user_resume_path, user_cover_letter = "#{user.first_name} #{user.last_name}", user.email, user.phone_number, user.resume.url, user.cover_letter
    agent = Mechanize.new
    agent.get('http://www.indeed.com/')
    form = agent.page.forms[0]
    form["q"] = job_title
    form["l"] =  job_location
    form.submit
    data = agent.page.search(".result:contains('Easily apply')").each do |title|
      title.css('.jobtitle').each do |anchor|
        agent.click(title.css('a').first)
        title, company, location = anchor.text, title.at(".company").text, title.search('.location').text
        unless job_applications.where(title: title, company: company).any? || !!(agent.page.uri.to_s.match(/indeed.com\/jobs?/)) || !!!(agent.page.uri.to_s.match(/indeed.com/))
          puts "\n\n#{'===='*40}\n\n\n -----CREATING FILE FROM----- \n#{agent.page.uri}\n\n\n\n\n"
          job_applications.find_or_create_by(indeed_link: agent.page.uri.to_s,
                                            title: title,
                                            company: company, 
                                            location: location, 
                                            user_name: user_name,
                                            user_phone_number: user_phone,
                                            user_email: user_email,
                                            user_resume_path: user_resume_path,
                                            user_cover_letter: user_cover_letter)
        end  
      end  
    end   
  end

  def call_search_worker
    SearchWorker.perform_async(id)
  end  
end

