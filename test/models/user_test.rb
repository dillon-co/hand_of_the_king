# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  first_name                     :string           not null
#  last_name                      :string           not null
#  phone_number                   :string
#  email                          :string           default(""), not null
#  encrypted_password             :string           default(""), not null
#  cover_letter                   :text
#  reset_password_token           :string
#  reset_password_sent_at         :datetime
#  remember_created_at            :datetime
#  sign_in_count                  :integer          default(0), not null
#  current_sign_in_at             :datetime
#  last_sign_in_at                :datetime
#  current_sign_in_ip             :inet
#  last_sign_in_ip                :inet
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  resume_file_name               :string           not null
#  resume_content_type            :string           not null
#  resume_file_size               :integer          not null
#  resume_updated_at              :datetime         not null
#  credits                        :integer          default(1)
#  parent_code                    :string
#  referral_code                  :string
#  referred_users_purchases_count :integer
#  current_discount               :string
#  money_earned                   :integer
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
