# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string           not null
#  last_name              :string           not null
#  phone_number           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  cover_letter           :text
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  resume_file_name       :string           not null
#  resume_content_type    :string           not null
#  resume_file_size       :integer          not null
#  resume_updated_at      :datetime         not null
#

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


  has_many :job_links



end
