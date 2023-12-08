require "bundler/gem_tasks"

# release will instead be declared by the releasinator
Rake::Task["release"].clear

spec = Gem::Specification.find_by_name 'releasinator'
load "#{spec.gem_dir}/lib/tasks/releasinator.rake"

desc "Run tests"
task :rspec do
  cmd = "bundle exec rspec -f d"
  system(cmd) || raise("#{cmd} failed")
end

task :default => :rspec
