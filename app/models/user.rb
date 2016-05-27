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
#  resume_file_name       :string
#  resume_content_type    :string
#  resume_file_size       :integer
#  resume_updated_at      :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :resume 

  validates_attachment :resume,
                       content_type: { content_type: ["image/jpeg", 
                                                      "image/png", 
                                                      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                                      'application/pdf',
                                                      /\Aimage\/.*\Z/] }


  has_many :job_links
end
