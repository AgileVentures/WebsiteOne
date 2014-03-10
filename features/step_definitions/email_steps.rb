And /^(The user|I) should receive a "(.*?)" email$/ do |form, arg1|
  expect(ActionMailer::Base.deliveries[0].subject).to include(arg1)
  ActionMailer::Base.deliveries.size.should eq 1
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