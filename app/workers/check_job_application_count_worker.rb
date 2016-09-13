class JobApplicationCountWorker
  include Sidekiq::Worker

  def perform
    # puts User.all.map{ |u| u.job_links.present? ? u.job_links.all.map{ |j| j.job_applications.where(applied_to: true).count }.inject(&:+) : 0 }.inject(:+)
    users = ["Dillon", "Alexander", "mike", "Karson", "Tim", "Ben", "Haley", "Coleman", "Brendan"]
    new_users = Hash.new do |h, k| 
      h[k] = User.find_by(first_name: k).job_links.map { |j| j.job_applications.where(applied_to: true).count }
    end
    users.each do |us|
      new_users[us]
    end
  end
end    