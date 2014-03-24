Given(/^the following pages exist$/) do |table|
  table.hashes.each do |hash|
    StaticPage.create!(hash)
  end
end

Then /^I (am|should be) on the static "([^"]*)" page$/ do |option, page|
  case option
    when 'am'
      visit page_path(page)

    when 'should be'
      expect(current_path.gsub('/', '')).to eq page_path(page).gsub('/', '')

    else
      pending
  end
end

When(/^I (try to use|am using) the Mercury Editor to edit static "([^"]*)" page$/) do |opt, title|
  visit "/editor/#{StaticPage.find_by_title(title).slug}"
end