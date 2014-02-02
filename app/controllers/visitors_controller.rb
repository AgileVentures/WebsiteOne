class VisitorsController < ApplicationController

  def index
    @message = ''
  end

  def send_contact_form
    if params[:name].empty? or params[:message].empty?
      redirect_to '/', alert:'Please, fill in Name and Message field'
      return
    end

    if Mailer.contact_form
      redirect_to '/', notice: 'Your message has been sent successfully!'
    else
      redirect_to '/', alert: 'Your message has not been sent!'
    end
  end
end
