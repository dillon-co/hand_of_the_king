# == Schema Information
#
# Table name: job_applications
#
#  id          :integer          not null, primary key
#  title       :string
#  company     :string
#  loaction    :string
#  pay_rate    :string
#  pay_type    :integer
#  description :text
#  job_link_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class JobApplication < ActiveRecord::Base
  belongs_to :job_link
end
