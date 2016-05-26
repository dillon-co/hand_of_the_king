# == Schema Information
#
# Table name: job_applications
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class JobApplication < ActiveRecord::Base
  belongs_to :job_link
end
