class VisitorsController < ApplicationController
  include ApplicationHelper

  def index
    project_count = Project.count
    if project_count > 0
      @projects_text = "#{project_count} #{'Project'.pluralize(project_count)} to date"
    else
      @projects_text = 'Projects coming soon!'
    end

    members_count = User.count
    if members_count > 0
      @members_text = "#{members_count} #{'Agile Venturer'.pluralize(members_count)}"
    else
      @members_text = 'Nobody yet, be the first!'
    end

    @event = Event.next_occurrence

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
