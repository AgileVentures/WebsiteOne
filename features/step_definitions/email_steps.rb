# frozen_string_literal: true

Then(/^I should( not)? receive a "([^"]*)" email$/) do |negate, subject|
  check_email(nil, negate, subject)
end

Then(/^the user should( not)? receive a "([^"]*)" email$/) do |negate, subject|
  check_email('random@morerandom.com', negate, subject)
end

And /^"(.*?)" should( not)? receive a "(.*?)" email(?: containing "(.*)")?$/ do |user_email, negate, subject, body|
  check_email(user_email, negate, subject, body)
end

Then /^project creator "(.*?)" should( not)? receive a "(.*?)" email(?: containing "(.*)")?$/ do |user_email, negate, subject, body|
  check_email(user_email, negate, subject, body, 0, 1)
end

Then /^project joinee "(.*?)" should( not)? receive a "(.*?)" email(?: containing "(.*)")?$/ do |user_email, negate, subject, body|
  check_email(user_email, negate, subject, body, 1, 1)
end

def check_email(email, negate, subject, body = nil, message = 0, num_mails = 0)
  if negate
    expect(ActionMailer::Base.deliveries.size).to eq num_mails
  else
    expect(ActionMailer::Base.deliveries[message].subject).to include(subject)
    expect(ActionMailer::Base.deliveries[message].body).to include(body) unless body.nil?
    expect(ActionMailer::Base.deliveries[message].to).to include(email) unless email.nil?
  end
end

And /^I should not receive an email$/ do
  expect(ActionMailer::Base.deliveries.size).to eq 0
end

And /^the email queue is clear$/ do
  ActionMailer::Base.deliveries.clear
end

When(/^replies to that email should go to "([^"]*)"$/) do |email|
  @email = ActionMailer::Base.deliveries.last
  expect(@email.reply_to).to include email
end

Given(/^I click on the retrieve password link in the last email$/) do
  password_reset_link = ActionMailer::Base.deliveries.last.body.match(
    %r{<a href="(.+)">Change my password</a>}
  )[1]

  visit password_reset_link
end
