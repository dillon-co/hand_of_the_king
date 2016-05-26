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

class JobLink < ActiveRecord::Base

  belongs_to :user
  has_many :job_applications
  
end
