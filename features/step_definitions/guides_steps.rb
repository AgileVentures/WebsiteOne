Then(/^I should see a list of guides$/) do
  page.should have_css "ul#guides-list"
end
