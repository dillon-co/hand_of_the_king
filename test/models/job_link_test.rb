# == Schema Information
#
# Table name: job_links
#
#  id                       :integer          not null, primary key
#  job_title                :string
#  job_type                 :string
#  job_subtitles            :string
#  job_location             :string
#  user_id                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  user_first_name          :string
#  user_last_name           :string
#  user_email               :string
#  user_phone_number        :string
#  user_cover_letter        :string
#  user_resume_file_name    :string
#  user_resume_content_type :string
#  user_resume_file_size    :integer
#  user_resume_updated_at   :datetime
#  done_searching           :boolean
#

require 'test_helper'

class JobLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
