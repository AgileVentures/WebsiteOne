Then(/^I click the Search Toggle button$/) do
  # expect(page).to have_selector("a#google_search")
  page.find(:css, 'a#google_search', visible: true).click()
end

Then(/^a search form should appear$/) do
  page.find(:css, 'div#google_search_wrapper', visible: true)
end

Then(/^when I search for 'WebsiteOne'$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I click 'Submit'$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the search results overlay$/) do
  pending # express the regexp above with the code you wish you had
end
