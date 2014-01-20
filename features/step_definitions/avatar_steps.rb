Then /^I should see my avatar image$/ do
  expect(page).to have_xpath("//img[contains(@src, '#{@avatar_link}')]")
end
