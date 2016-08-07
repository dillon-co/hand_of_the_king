class ApplicationWorker
  include Sidekiq::Worker
  def perform(job_link_id)
    JobLink.find(job_link_id).job_applications.where(should_apply: true).each { |j| j.apply_to_job }
  end  
end    