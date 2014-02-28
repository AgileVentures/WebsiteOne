Then(/^I should to see sponsor banner for "(.*?)"$/) do |arg1|
  page.should have_selector('.div#ourSponsors')
end

Then(/^I should to see link "(.*?)"$/) do |arg1|
  # expect(page).to_have
  page.should have_link page_path('sponsors')
end