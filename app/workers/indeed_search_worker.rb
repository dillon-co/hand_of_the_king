require 'mechanize'
require 'open-uri'
class SearchWorker
  include Sidekiq::Worker

  def perform(search_query)
    agent = Mechanize.new
    agent.get('http://www.indeed.com/')
    form = agent.page.forms[0]
    form["q"] = 'a'
    form["l"] = "a"
    form.submit.link["developers"]
  end  
end  