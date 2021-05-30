unless Rails.env.production?
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'
  require  'coveralls/rake/task'
  Coveralls::RakeTask.new
  Cucumber::Rake::Task.new(:ci_cucumber) do |t|
    t.cucumber_opts = "--tags 'not @intermittent-ci-js-fail'"
  end

  namespace :ci do
    desc 'Run Rspec and Cucumber'
    # task tests: [:spec, 'coveralls:push']
    task tests: [:spec, 'cucumber:first_try', 'cucumber:second_try', 'coveralls:push']
    task third_try: ['cucumber:third_try']
  end
end
