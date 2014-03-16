Given(/^App is in production$/) do
  Rails.env.stub(production?: true)
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

