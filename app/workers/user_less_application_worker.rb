class UserLessApplicationWorker
  include Sidekiq::Worker
  def perform(job_link_id)
    job_link = JobLink.find(job_link_id)
    job_link.update_job_applications_with_user_info  
  end  
end    