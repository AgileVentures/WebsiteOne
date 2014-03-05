class ModalsController < ApplicationController
  include ApplicationHelper

  def hire_me_contact_form
    begin
      if params[:name].empty? or params[:message].empty?
        redirect_to :back, alert: 'Please, fill in Name and Message field'
        return
      end

      if Mailer.hire_me_form(params).deliver
        redirect_to :back, notice: 'Your message has been sent successfully!'
      else
        redirect_to :back, alert: 'Your message has not been sent!'
      end

      if valid_email?(params[:email])
        Mailer.hire_me_form_confirmation(params).deliver
      end

    rescue ActionController::RedirectBackError
      redirect_to users/show
    end
  end
end












