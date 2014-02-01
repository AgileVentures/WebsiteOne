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