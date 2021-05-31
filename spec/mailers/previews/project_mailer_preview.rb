# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/project_mailer
class ProjectMailerPreview < ActionMailer::Preview
  def alert_project_creator_about_new_member
    ProjectMailer.with(project: Project.first, user: User.first, project_creator: User.third)
                 .alert_project_creator_about_new_member
  end

  def welcome_project_joinee
    ProjectMailer.with(project: Project.first, user: User.first, project_creator: User.third)
                 .welcome_project_joinee
  end

  def welcome_project_joinee_special_websiteone_message
    ProjectMailer.with(project: Project.find_by(title: 'WebsiteOne'), user: User.first, project_creator: User.third)
                 .welcome_project_joinee
  end
end
