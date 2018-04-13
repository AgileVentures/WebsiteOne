namespace :fetch_github do
  desc 'Get github content for static pages'
  task :content_for_static_pages => :environment do
    GithubStaticPagesJob.run
  end
end
