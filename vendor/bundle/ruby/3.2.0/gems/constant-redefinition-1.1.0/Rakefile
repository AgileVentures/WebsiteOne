require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
  # spec.ruby_opts = ['-w']
end

task :default => :spec

desc "Runs tests on Ruby 1.8.7, 1.9.2 and 1.9.3"
task :test_rubies do
  system "rvm 1.8.7@constant-redefinition_gem,1.9.2@constant-redefinition_gem,1.9.3@constant-redefinition_gem do rake spec"
end
