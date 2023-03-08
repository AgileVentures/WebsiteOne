# frozen_string_literal: true

Then(/^I should see my avatar image$/) do
  expect(page).to have_xpath("//img[contains(@src, '#{@avatar_link}')]")
end

Then(/^I should see "([^"]*)" avatars$/) do |arg|
  expect(page).to have_xpath("//img[contains(@src, 'gravatar.com')]", count: arg)
end

Then(/^I should see "([^"]*)" user avatars$/) do |arg|
  expect(page).to have_css('img[src*="gravatar.com"]', count: arg)
end

When(/^I click on the avatar for "(.*?)"$/) do |user|
  this_user = User.find_by_first_name(user) || User.find_by_email(user)
  first(:css, "a[href*=\"#{this_user.friendly_id}\"] img")
  visit path_to('user profile', this_user)
end

And(/^I should see the avatar for "(.*?)"$/) do |user|
  user = User.find_by_first_name(user)
  expect(page).to have_xpath("//img[contains(@alt, '#{user.presenter.display_name}')]")
end

And(/^I should see the avatar for "(.*?)" at( least)? (\d*?) px$/) do |user, _greater_than, size|
  this_user = User.find_by_first_name(user)
  # TODO: check for size: > size if greater_than is set
  expect(page).to have_xpath("//img[contains(@src, '#{this_user.gravatar_url(size: size)}')]")
end
