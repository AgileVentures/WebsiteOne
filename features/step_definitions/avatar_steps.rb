Then /^I should see my avatar image$/ do
  page.should have_xpath("//img[contains(@src, '#{@avatar_link}')]")
end

Then /^I should see "([^"]*)" avatars$/ do | arg |
  # expect(page).to have_xpath("//img[contains(@src, '#{@avatar_link}')]", :count => arg)
  expect(page).to have_xpath("//img[contains(@src, 'gravatar.com')]", :count => arg)
end

Then /^I should see "([^"]*)" user avatars$/ do | arg |
  find('#all_mambers').tap do |section|
    section.should have_xpath("//img[contains(@id, 'avatar')]", :count => arg)
  end
end

When /^I click on the avatar for "(.*?)"$/ do | user |
  this_user = User.find_by_first_name(user)
  step %Q{I follow "avatar-#{this_user.id}"}
end