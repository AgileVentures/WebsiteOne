module RegistrationsHelper
  def display_email?
    session[:display_email]
  end
end