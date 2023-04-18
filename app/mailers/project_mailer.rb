# frozen_string_literal: true

class ProjectMailer < ApplicationMailer
  default from: 'matt@agileventures.org', reply_to: 'matt@agileventures.org', cc: 'support@agileventures.org'

  before_action :set_params

  def alert_project_creator_about_new_member
    mail(to: @project_creator.email, subject: "#{@user.display_name} just joined #{@project.title} project")
  end

  def welcome_project_joinee
    mail(to: @user.email, subject: "Welcome to the #{@project.title} project!")
  end

  private

  def set_params
    @user = params[:user]
    @project = params[:project]
    @project_creator = params[:project_creator]
  end
end
