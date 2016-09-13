class JobApplicationCountWorker
  include Sidekiq::Worker

  def perform
    # puts User.all.map{ |u| u.job_links.present? ? u.job_links.all.map{ |j| j.job_applications.where(applied_to: true).count }.inject(&:+) : 0 }.inject(:+)
    users = ["Dillon", "Alexander", "mike", "Karson", "Tim", "Ben", "Haley", "Coleman", "Brendan"]
    new_users = Hash.new 
    users.each do |u|
      # puts User.find_by(first_name: u)
      new_users[u] = User.find_by(first_name: u).job_links.map { |j| j.job_applications.where(applied_to: true).count }.inject(:+)
     end 
  end
end    