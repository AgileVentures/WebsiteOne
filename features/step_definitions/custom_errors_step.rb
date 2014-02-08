#Given(/^(?:|I )am on the "(.*?)" page$/) do |page|
#  case page
#    when "Home" then visit root_path('show')
#    when "contributors" then visit contributors_path
#    when "sign up" then visit new_user_registration_path
#    when "sign in" then visit new_user_session_path
#    when "about" then visit page_path('About')
#    when "foobar" then visit ("/#{page}")
#  end
#end

Given(/^the following pages exist:$/) do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Given(/^I visit "(.*?)"$/) do |path|
  visit path
end


Then(/^the page should be titled "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
When(/^the response status should be "([^"]*)"$/) do |code|
  page.status_code.should eq(code.to_i)
end