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
  after_save :run_search
  

  def run_search
    agent = Mechanize.new
    agent.get('http://www.indeed.com/')
    form = agent.page.forms[0]
    form["q"] = job_title
    form["l"] =  job_location
    form.submit
    data = agent.page.search(".result:contains('Easily apply')").each do |title|
      title.css('.jobtitle').each do |anchor|
        ### Some of the links are the same so `find_or_create_by` will only create 4 job_applications.  
        title.at("span[@itemprop='addresslocality']") 
        # puts anchor.at('span').text
        title, company, location = anchor.text, title.at('span').text, title.search('.location').text
        agent.click(anchor)
        puts "\n\n#{'===='*40}\n\n\n -----CREATING FILE FROM----- \n#{agent.page.uri}\n\n\n\n\n"
        job_applications.find_or_create_by(indeed_link: agent.page.uri.to_s, title: title, company: company, location: location)
      end  
    end   
  end  
end

