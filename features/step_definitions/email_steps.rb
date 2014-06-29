And /^(?:The user|I) should receive a "(.*?)" email$/ do |subject|
  ActionMailer::Base.deliveries.size.should eq 1
  expect(ActionMailer::Base.deliveries[0].subject).to include(subject)
end

And /^I should not receive an email$/ do
  ActionMailer::Base.deliveries.size.should eq 0
end

And /^the email queue is clear$/ do
  ActionMailer::Base.deliveries.clear
end

When(/^replies to that email should go to "([^"]*)"$/) do |email|
  @email = ActionMailer::Base.deliveries.last
  @email.reply_to.should include email
end

Given(/^I click on the retrieve password link in the email to "(.*)"$/) do |email|
  user = User.find_by_email email
  visit password_url(user.reset_password_token)
end

