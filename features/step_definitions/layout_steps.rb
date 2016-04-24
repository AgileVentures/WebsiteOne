Then(/^I(?:| should) see a navigation header$/) do
  expect(page).to have_selector('.masthead')
end

Then(/^I should see a main content area$/) do
  expect(page).to have_selector '#main'
end

Then(/^I should see a footer area$/) do
  expect(page).to have_selector '#footer'
end

Then(/^I should see a navigation bar$/) do
  find '#nav'
end

When(/^I should see "([^"]*)" in footer$/) do |string|
  within('#footer') do
    expect(page).to have_text string
  end
end

Then /^I should see link$/ do |table|
  table.rows.flatten.each do |link|
    expect(page).to have_link link
  end
end

When(/^the page should include ([^"]*) for ([^"]*)$/) do |tag, content|
  case tag
    when 'script'then
      case content
        when 'Google Analytics' then expect(page).to have_xpath("//script[text()[contains(.,'UA-xxxxxx-x')]]", visible: false)
      end
    when 'css' then expect(page).to have_xpath("//link[contains(@href, '#{content}')]", visible: false)
    when 'js' then expect(page).to have_xpath("//script[contains(@src, '#{content}')]", visible: false)

  end
end

Then /^I should see the tracking code$/ do
  expect(page).to have_xpath("//script[text()[contains(.,#{GA.tracker})]]", visible: false)
end


Then(/^I should see a modal window with a form "([^"]*)"$/) do |arg|
  expect(page).to have_content(arg)
end