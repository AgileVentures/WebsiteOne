Then(/^I click the Search Toggle button$/) do
  # expect(page).to have_selector("a#google_search")
  page.find(:css, 'a#google_search', visible: true).click()
end

Then(/^a search form should appear$/) do
  expect(page).to have_css '#google_search_wrapper', visible: true
end

Then(/^when I search for 'WebsiteOne'$/) do
  # page.find('gsc-i-id1').set('WebsiteOne')
  page.fill_in 'gsc-i-id1', :with => 'WebsiteOne'
end

Then(/^I click 'Submit'$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the search results overlay$/) do
  pending # express the regexp above with the code you wish you had
end
