class StatusController < ApplicationController


  def new
    @status = Status.new
  end


  def create
    @status = Project.new(params(user_id: current_user.id))
    if @status.save
      redirect_to  session[:previous_url], notice: 'Status OK'
    else
      flash.now[:alert] = 'Status not OK!'
      render action: 'new'
    end
  end


end