# frozen_string_literal: true

def github_edit_url
  "https://github.com/AgileVentures/AgileVentures/edit/master/#{static_page.tr(' ', '_').upcase}.md"
end

def static_page
  'Sponsors'
end

When(/^I click the 'Sponsors' page$/) do
  click_on('Becoming a sponsor')
end

Then(/^I should be on 'Sponsors' page$/) do
  expect(page.title).to have_content('Sponsors')
end

Then(/^I should see an 'Edit Page' button$/) do
  expect(page).to have_link 'Edit Page'
end

Then(/^'Edit Page' should link to github edit page$/) do
  expect(page).to have_link('Edit Page', href: github_edit_url)
end
