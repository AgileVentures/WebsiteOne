Then /^I should see my avatar image$/ do
  page.find(:xpath, "//img[@src=\"#{gravatar_for(@user)}\"]")
end
