Then(/^I should( not)? see the search form$/) do |negative|
  if negative
    expect(page).to have_css '#google_search_wrapper', visible: false
  else
    expect(page).to have_css '#google_search_wrapper', visible: true
  end
end

Then(/^I click the Search Toggle button$/) do
  page.find(:css, 'a#google_search', visible: true).click
end
