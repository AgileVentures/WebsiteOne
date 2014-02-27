Given(/^App is in production$/) do
  WebsiteOne::Application.configure do
    config.consider_all_requests_local       = false
    config.action_controller.perform_caching = true
  end
end

Given(/^I visit "(.*?)"$/) do |path|
  visit path
end

Then(/^the page should be titled "(.*?)"$/) do |title|
  page.source.should have_css("title", :text => title, :visible => false)
end

And(/^the response status should be "([^"]*)"$/) do |code|
  page.status_code.should eql(code.to_i)
end

When(/^I encounter an internal server error$/) do
  VisitorsController.any_instance.should_receive(:index).and_raise(Exception)
  visit root_path
end

