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
require 'indeed_search_worker'
require 'mechanize'
require 'open-uri'

class JobLink < ActiveRecord::Base

  belongs_to :user
  has_many :job_applications
  

  def run_search
    SearchWorker.perform_async('meow')

  end  
end
