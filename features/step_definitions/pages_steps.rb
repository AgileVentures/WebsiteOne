Then /^I should be on the static "([^"]*)" page$/ do |page|
  page = page.titleize.gsub(' ','').underscore
  expect(current_path).to eq page_path(page)
end

Then /^I am on the static "([^"]*)" page$/ do |page|
  page = page.titleize.gsub(' ','').underscore
  visit page_path(page)
end


