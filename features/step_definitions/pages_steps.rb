Given(/^the following pages exist$/) do |table|
  table.hashes.each do |hash|
    Page.create!(hash)
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