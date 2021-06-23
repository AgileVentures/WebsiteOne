# frozen_string_literal: true

Then(/^I should see sponsor banner for "(.*?)"$/) do |supporter_name|
  expect(page).to have_selector('div#sponsorsBar')
  expect(page).to have_css("img[alt*='#{supporter_name}']")
end

Then(/^I should be (.*)'s sponsor$/) do |name|
  user = User.find_by_first_name name
  subscription = Subscription.find_by(user: user)
  expect(subscription.sponsor).to eq(@current_user)
end

Then(/^I should be my own sponsor$/) do
  subscription = Subscription.find_by(user: @current_user)
  expect(subscription.sponsor).to eq(@current_user)
end
