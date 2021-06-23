# frozen_string_literal: true

Given(/^the following commit_counts exist:$/) do |table|
  hash = {}
  project = nil
  user = nil
  table.hashes.each do |attributes|
    project = Project.find_by(title: attributes['project'])
    user = User.find_by(email: attributes['user_email'])
    hash[:project_id] = project.id if project
    hash[:user_id] = user.id if user
    hash[:commit_count] = attributes['commit_count'].to_i if attributes['commit_count']
  end
  CommitCount.new(hash).save!
  user.follow project
end
