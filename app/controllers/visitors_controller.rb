class VisitorsController < ApplicationController
  include ApplicationHelper

  def index
    # disable countdown clock by setting @next_event to nil
    @event = @next_event
    @next_event = nil

    render layout: false
  end

  def send_contact_form
    begin
      if params[:name].empty? or params[:message].empty?
        redirect_to :back, alert: 'Please, fill in Name and Message field'
        return
      end
      if Mailer.contact_form(params).deliver
        redirect_to :back, notice: 'Your message has been sent successfully!'
      else
        redirect_to :back, alert: 'Your message has not been sent!'
      end
      if valid_email?(params[:email])
        Mailer.contact_form_confirmation(params).deliver
      end
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end
end
