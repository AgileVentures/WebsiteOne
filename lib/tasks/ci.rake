unless Rails.env.production?
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'
  require 'coveralls/rake/task'

  Coveralls::RakeTask.new

  Cucumber::Rake::Task.new(:ci_cucumber) do |t|
    t.cucumber_opts = '--tags ~@intermittent-ci-js-fail'
  end

  namespace :ci do
    desc 'Run Rspec and Cucumber then push coverage report to coveralls'
    task tests: [:spec, 'cucumber:first_try', 'cucumber:second_try', 'coveralls:push']
  end
end
