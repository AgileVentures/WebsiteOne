# frozen_string_literal: true

namespace :db do
  desc 'migrate from github url to source repository domain model (copies github_url field to source repo model)'
  task migrate_from_github_url_to_source_repository: :environment do
    Project.all.each do |project|
      project.source_repositories.create(url: project[:github_url])
    end
  end

  desc 'add slack channel codes to project slack channels join table'
  task add_project_slack_channels: :environment do
    include ChannelsList
    Project.all.each do |project|
      if CHANNELS[project.slug.to_sym].respond_to? :each
        CHANNELS[project.slug.to_sym].each do |code|
          project.slack_channels << SlackChannel.find_or_create_by(code: code)
        end
      else
        project.slack_channels << SlackChannel.find_or_create_by(code: CHANNELS[project.slug.to_sym])
      end
    end
  end
end
