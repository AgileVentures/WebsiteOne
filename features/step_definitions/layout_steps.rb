Then(/^I should see a navigation header$/) do
  page.should have_selector('section#header')
end

Then(/^I should see a main content area$/) do
  page.should have_selector('section#main')
end

Then(/^I should see a footer area$/) do
  page.should have_selector('section#footer')
end

Then(/^I should see a navigation bar$/) do
  within('section#header') do
    find ('div.navbar')
  end
end