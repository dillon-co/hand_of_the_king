# == Schema Information
#
# Table name: job_applications
#
#  id                :integer          not null, primary key
#  user_name         :string
#  user_email        :string
#  user_phone_number :string
#  user_resume_path  :string
#  user_cover_letter :string
#  indeed_link       :string
#  title             :string
#  company           :string
#  location          :string
#  pay_rate          :string
#  applied_to        :boolean          default(FALSE)
#  pay_type          :integer
#  description       :text
#  job_link_id       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  should_apply      :boolean          default(TRUE)
#

require 'test_helper'

class JobApplicationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
