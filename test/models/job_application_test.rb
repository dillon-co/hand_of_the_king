# == Schema Information
#
# Table name: job_applications
#
#  id          :integer          not null, primary key
#  indeed_link :string
#  title       :string
#  company     :string
#  location    :string
#  pay_rate    :string
#  pay_type    :integer
#  description :text
#  job_link_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class JobApplicationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
