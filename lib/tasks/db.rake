namespace :db do
  desc "migrate from github url to source repository domain model (copies github_url field to source repo model)"
  task migrate_from_github_url_to_source_repository: :environment do
    Project.all.each do |project|
      project.source_repositories.create(url: project[:github_url])
    end
  end
end
