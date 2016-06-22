class JobLinksController < ApplicationController
  # skip_before_filter  :verify_authenticity_token

  def index
    user_signed_in? ? @job_links = current_user.job_links.all : @job_links = "You Haven't searched for any jobs yet!"
  end

  def new
    @job_link = JobLink.new
  end

  def create
    job_link = current_user.job_links.new(job_link_params)
    if job_link.save
      redirect_to
    else
      render :new
    end    
  end

  def info_page

  end  
  
  private

  def job_link_params
    params.require(:job_link).permit(:job_title, :job_subtitles, :job_location)
  end  
end
