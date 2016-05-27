require 'mechanize'
require 'open-uri'
class SearchWorker
  include Sidekiq::Worker

  def perform(search_query)
    agent = Mechanize.new
    agent.get('http://www.indeed.com/')
    form = agent.page.forms[0]
    form["q"] = "Developer"
    form["l"] = "Provo"
    form.submit
  end  
end  