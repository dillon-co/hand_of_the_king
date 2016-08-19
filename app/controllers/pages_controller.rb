class PagesController < ApplicationController
  
  def about
  end

  def price_page
  end 

  def profile
    if user_signed_in?
      @user = current_user
      @users_friends = User.where(parent_code: current_user.referral_code)
      @users_friends_count = @users_friends.count
      @job_links = @user.job_links.all
      @job_applications_count = @job_links.map { |j| j.job_applications.count }.inject(:+) 
    end  
  end

  def sharing
    if user_signed_in?
      @user = current_user
      @share_url = "#{root_url}ref?d=#{@user.referral_code}"
    end  
  end  
end
