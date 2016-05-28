# == Schema Information
#
# Table name: job_links
#
#  id         :integer          not null, primary key
#  job_title  :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'indeed_search_worker'
require 'mechanize'
require 'open-uri'

class JobLink < ActiveRecord::Base

  belongs_to :user
  has_many :job_applications
  

  def run_search
    # SearchWorker.perform_async('meow')
    agent = Mechanize.new
    agent.get('http://www.indeed.com/')
    form = agent.page.forms[0]
    form["q"] = "Developer"
    form["l"] = "Provo"
    form.submit
    data = agent.page.search(".result:contains('Easily apply')").css(".jobtitle").each do |l|
      puts "\n\n\n\n\n#{'=='*40}\n\n\n\n\n\n #{l}\n\n\n\n\n\n"
    end  
    # data.search('div:contains("Easily apply")').each do |applicable_div|
    #    applicable_div.each { |d| puts d}
    #   # agent.click(open_uri)
    # end  
  end  
end
