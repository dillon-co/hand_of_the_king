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

require 'securerandom'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable




  has_attached_file :resume 
  validates_attachment :resume,
                       :content_type => {:content_type => %w(
                        image/jpeg
                        image/jpg 
                        image/png
                        application/pdf 
                        application/msword 
                        application/vnd.openxmlformats-officedocument.wordprocessingml.document)}
  
  validates_attachment_presence :resume
  validates :first_name, presence: true, on: :create       
  validates :last_name, presence: true, on: :create

  # belongs_to :recruiters

  has_many :job_links

  after_create :create_user_code


  def create_user_code
    code = SecureRandom.urlsafe_base64(4)
    unless User.where(referral_code: code).any?
      self.update(referral_code: code) 
    else
      create_user_code
    end    
  end  

  def update_parent_user
    parent = User.find_by(referral_code: parent_code)
    past_money_earned = parent.money_earned
    !!past_money_earned ? parent.update(money_earned: past_money_earned+3) : parent.update(money_earned: 3)
  end  

end

























