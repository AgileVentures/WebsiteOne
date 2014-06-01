Then /^I should see my avatar image$/ do
  page.should have_xpath("//img[contains(@src, '#{@avatar_link}')]")
end

Then /^I should see "([^"]*)" avatars$/ do | arg |
  # expect(page).to have_xpath("//img[contains(@src, '#{@avatar_link}')]", :count => arg)
  expect(page).to have_xpath("//img[contains(@src, 'gravatar.com')]", :count => arg)
end

Then /^I should see "([^"]*)" user avatars$/ do | arg |
  expect(page).to have_css('img[src*="gravatar.com"]', :count => arg)
end

When /^I click on the avatar for "(.*?)"$/ do | user |
  this_user = User.find_by_first_name(user) || User.find_by_email(user)
  find(:css, 'a[href*="' + this_user.friendly_id + '"] img')
  visit path_to('user profile', this_user)
end

And(/^I should see the avatar for "(.*?)"$/) do |user|
  this_user = User.find_by_first_name(user)
  p this_user.email
  p page.body
  expect(page).to have_xpath("//img[contains(@src, '#{gravatar_for(this_user.email)}')]")
end

And(/^I should see the avatar for "(.*?)" at( least)? (\d*?) px$/) do |user, greater_than, size|
  this_user = User.find_by_first_name(user)
  # TODO check for size: > size if greater_than is set
  expect(page).to have_xpath("//img[contains(@src, '#{this_user.presenter.gravatar_src(size: size)}')]")
end
