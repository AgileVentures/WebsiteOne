Given(/^(?:|I )am on the "(.*?)" page$/) do |page|
  case page
    when "foobar" then visit ("/#{page}")
  end
end

Given(/^the following pages exist:$/) do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Given(/^I visit "(.*?)"$/) do |path|
  visit path
end


Then(/^the page should be titled "(.*?)"$/) do |arg1|
  page.source.should have_css("title", :text => title, :visible => false)
end

And(/^the response status should be "([^"]*)"$/) do |code|
  page.status_code.should eql(code.to_i)
end


Then(/^I should see the static "([^"]*)" page$/) do |arg|
  pending
end