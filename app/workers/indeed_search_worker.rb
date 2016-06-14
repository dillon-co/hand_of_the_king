class SearchWorker
  include Sidekiq::Worker

  def perform(job_link_id)
    JobLink.find(job_link_id).run_search
  end  
end  