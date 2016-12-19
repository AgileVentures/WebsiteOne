Then(/^I should( not)? receive a "([^"]*)" email$/) do |negate, subject|
  check_email(nil, negate, subject)
end

Then(/^the user should( not)? receive a "([^"]*)" email$/) do |negate, subject|
  check_email('random@morerandom.com', negate, subject)
end

And /^"(.*?)" should( not)? receive a "(.*?)" email$/ do |user_email, negate, subject|
  check_email(user_email, negate, subject)
end

def check_email(email, negate, subject)
  unless negate
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(ActionMailer::Base.deliveries[0].subject).to include(subject)
    expect(ActionMailer::Base.deliveries[0].to).to include(email) unless email.nil?
  else
    expect(ActionMailer::Base.deliveries.size).to eq 0
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
      /<a href=\"(.+)\">Change my password<\/a>/
  )[1]

  visit password_reset_link
end

