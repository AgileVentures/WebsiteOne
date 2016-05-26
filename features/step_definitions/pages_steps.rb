def static_page_path(page)
  "/#{StaticPage.url_for_me(page)}"
end

Given(/^the following pages exist$/) do |table|
  table.hashes.each do |hash|
    StaticPage.create!(hash)
  end
end

Then /^I (am|should be) on the static "([^"]*)" page$/ do |option, page|
  case option
    when 'am'
      visit static_page_path(page)
    when 'should be'
      expect(current_path).to eq static_page_path(page)
    else
      pending
  end
end
When(/^I (try to use|am using) the Mercury Editor to edit static "([^"]*)" page$/) do |opt, title|
  visit "/editor#{static_page_path(title)}"
end

Given(/^the following page revisions exist$/) do |table|
  table.hashes.each do |hash|
    hash[:revisions].to_i.times do |number|
      page = StaticPage.find_by_title(hash[:title])
      page.update(:body => "New content #{number}")
      page.save!
    end
  end
end

When(/^I should see ([^"]*) revisions for the page "([^"]*)"$/) do |revisions, document|
  page = StaticPage.find_by_title(document)
  expect page.versions.count == revisions
end

Given(/^the page "([^"]*)" has a child page with title "([^"]*)"$/) do |parent, child|
  parent_page = StaticPage.find_by_title(parent)
  StaticPage.create!(
      {
          title: child,
          parent_id: parent_page.id
      }
  )
end

Then(/^the current page url should be "([^"]*)"$/) do |url|
  expect(current_path).to eq "/#{url}"
end

Then(/^I should see ancestry "([^"]*)"$/) do |str|
  ancestry = str.split(" >> ")
  within("#ancestry") do
    ancestry.each do |a|
      expect(page).to have_content a
    end
  end
end
