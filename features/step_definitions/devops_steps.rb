When(/^I run rake task "([^"]*)"$/) do |name|
  # Write code here that turns the phrase above into concrete actions
   require "rake"
   @rake = Rake::Application.new
   Rake.application = @rake
   Rake::Task.define_task(:environment)
   Rake.application.rake_require "tasks/scheduler"
   @rake[name].invoke
end

