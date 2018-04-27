Given(/^I click on the karma link$/) do
	click_link('gotoactivity')
end

Then(/^the Activity tab displays "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end


