class JobApplicationCountWorker
  include Sidekiq::Worker

  def perform
    puts User.all.map{ |u| u.job_links.present? ? u.job_links.all.map{ |j| if j.present? ? j.job_applications.where(applied_to: true).count }.inject(&:+) : 0 }.inject(:+)
  end
end    