Then /^I should see my avatar image$/ do
  expect(page).to have_xpath("//img[contains(@src, '#{@avatar_link}')]")
end

Then /^I should see "([^"]*)" avatars$/ do | arg |
  # expect(page).to have_xpath("//img[contains(@src, '#{@avatar_link}')]", :count => arg)
  expect(page).to have_xpath("//img[contains(@src, 'gravatar.com')]", :count => arg)
end