class JobLinksController < ApplicationController
  # skip_before_filter  :verify_authenticity_token

  def index
    user_signed_in? ? @job_links = current_user.job_links.all : @job_links = "You Haven't searched for any jobs yet!"
  end

  def new
    @job_link = JobLink.new
  end

  def show
    @job_link = JobLink.find(params[:id])
    @job_applications = @job_link.job_applications.where(should_apply: true)
  end  

  def create
    if user_signed_in?
      job_link = current_user.job_links.new(job_link_params)
    else
      job_link = JobLink.new(job_link_params)
    end  
    if job_link.save
      # redirect_to loading_path(n_jid: job_link.id)
      redirect_to edit_job_link_path(job_link)
    else
      render :new
    end    
  end

  def edit
    @job_link = JobLink.find(params[:id])
    @job_applications = @job_link.job_applications.all
  end  

  def update
    @job_link = JobLink.find(params[:id])
    # if user_signed_in?
    #   current_user.update(credits: current_user.credits-1)
    # end  
    # @job_link.update(job_link_params) 

    if request.original_url.split('/')[-2] != 'edit_user_info' && params['job_link']['done_editing'] != 'true'
      ids = params["job_link"]["job"].keys.map{ |k| k.to_i }
      ids.each do |id|
        JobApplication.find(id).update(should_apply: params["job_link"]["job"][id.to_s]["should_apply"])
      end 
    end    
    # byebug
    if @job_link.save
      if user_signed_in?
        redirect_to job_link_path(@job_link)
      elsif params['job_link']['user_first_name'] == nil
        redirect_to edit_user_info_path(@job_link)
      else
        redirect_to job_link_path(@job_link)  
      end  
    else
      render :new
    end    
  end  

  def info_page
    puts "Made it to info" 
    redirect_to job_link_path(current_user.job_links.last)
  end  

  def edit_user_info
    @job_link = JobLink.find(params[:id])
  end  
  
  def is_still_loading
    @job_link = JobLink.find(params['n_jid'])    
    respond_to do |format|
       format.json { render json: {success: @job_link.done_searching? }}
    end 
  end  
  private

  def job_link_params
    params.require(:job_link).permit(:job_title, :job_subtitles, :job_location, :job_applications_attributes => [:id, :should_apply])
  end  
end
