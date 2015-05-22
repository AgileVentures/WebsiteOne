def url_for_title(options)
  controller = options[:controller]
  eval("#{controller.capitalize.singularize}.find_by_title('#{options[:title]}').url_for_me(options[:action].downcase)")
end

def path_to(page_name, id = '')
  name = page_name.downcase
  case name
    when 'home' then
      root_path
    when 'registration' then
      new_user_registration_path
    when 'edit registration' then
      edit_user_registration_path
    when 'sign in' then
      new_user_session_path
    when 'projects' then
      projects_path
    when 'new project' then
      new_project_path
    when 'articles' then
      articles_path
    when 'edit' then
      edit_project_path(id)
    when 'show' then
      project_path(id)
    when 'our members' then
      users_path
    when 'user profile' then
      user_path(id)
    when 'my account' then
      edit_user_registration_path(id)
    when 'scrums' then
      scrums_index_path
    when 'event_instances' then
      hangouts_path
    when 'foobar' then
      "/#{page}"
    when 'password reset' then
      edit_user_password_path(id)
    when 'hookups' then
      hookups_path
    when 'dashboard' then
      '/dashboard'
    when 'new newsletter' then
      new_newsletter_path
    when 'newsletters index' then
      newsletters_path
    else
      raise('path to specified is not listed in #path_to')
  end
end

# GIVEN steps

Given(/^I (?:visit|am on) the site$/) do
  visit root_path
end

Given(/^I visit "(.*?)"$/) do |path|
  visit path
end

# WHEN steps
When(/^I (?:go to|am on) the "([^"]*)" page$/) do |page|
  visit path_to(page)
end

When(/^I go to the path "(.*?)"$/) do |page|
  visit path_to(page)
end

When(/^(?:when I|I) click "([^"]*)"$/) do |text|
  click_link_or_button text
end

When(/^I click the "([^"]*)" button$/) do |button|
  click_link_or_button button
end

When(/^I click "([^"]*)" button$/) do |button|
  click_button button
end

When(/^I click the "([^"]*)" link$/) do |button|
  click_link button
end

When(/^I click the (link|button) "([^"]*)"$/) do |selector ,text|
  page.find(:css, 'a', text: /#{text}/, visible: true).trigger('click')
end

When(/^I follow "([^"]*)"$/) do |text|
  click_link text
end

When(/^I dropdown the "([^"]*)" menu$/) do |text|
  within ('.navbar') do
    click_link text
  end

end


When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in field, :with => value
end

When /^I fill in(?: "([^"]*)")?:$/ do |name, table|
  with_scope(name) do
    table.rows.each do |row|
      fill_in row[0], with: row[1]
    end
  end
end

When /^I fill in event field(?: "([^"]*)")?:$/ do |name, table|
  with_scope(name) do
    table.rows.each do |row|
      within('form#event-form') do
        fill_in row[0], with: row[1]
      end
    end
  end
end

When /^I accept the warning popup$/ do
  # works only with webkit javascript drivers
  page.driver.browser.accept_js_confirms
end

Given /^the time now is "([^"]*)"$/ do |time|
  Time.stub(now: Time.parse(time))
end

# THEN steps

Then /^I should see link "([^"]*)" with "([^"]*)"$/ do |link, url|
  expect(page).to have_link(link, href: url)
end

Then /^I should be on the "([^"]*)" page$/ do |page|
  expect(current_path).to eq path_to(page)
end

Then /^I am redirected to the "([^"]*)" page$/ do |page|
  expect(current_path).to eq path_to(page)
end

Then /^I should see a form(?: "([^"]*)")? with:$/ do |name, table|
  with_scope(name) do
    table.rows.each do |row|
      step %Q{the "#{row[0]}" field should contain "#{row[1]}"}
    end
  end
end

Then /^I should( not)? see:$/ do |negative, table|
  expectation = negative ? :should_not : :should
  table.rows.flatten.each do |string|
    page.send(expectation, have_text(string))
  end
end

Then /^I should( not)? see "([^"]*)"$/ do |negative, string|
  unless negative
    expect(page).to have_text string
  else
    expect(page).to_not have_text string
  end
end

Then /^I should( not)? see a flash "([^"]*)"$/ do |negative, string|
  unless negative
    expect(page).to have_css '.alert', text: string
  else
    expect(page).to_not have_css '.alert', text: string
  end
end

Then /^I should( not)? see "([^"]*)" in "([^"]*)"$/ do |negative, string, scope|
  within(selector_for(scope)) { step %Q{I should#{negative} see "#{string}"} }
end

Then /^I should( not)? see link "([^"]*)"$/ do |negative, link|
  if negative
    expect(page.has_link? link).to be_false
  else
    expect(page.has_link? link).to be_true
  end
end

Then /^I should( not)? see field "([^"]*)"$/ do |negative, field|
  if negative
    expect(page.has_field? field).to be_false
  else
    expect(page.has_field? field).to be_true
  end
end

Then /^I should( not)? see buttons:$/ do |negative, table|
  table.rows.flatten.each do |button|
    unless negative
      expect(page.has_link_or_button? button).to be_true
    else
      expect(page.has_link_or_button? button).to be_false
    end
  end
end

Then /^I should( not)? see button "([^"]*)"$/ do |negative, button|
  unless negative
    expect(page.has_link_or_button? button).to be_true
  else
    expect(page.has_link_or_button? button).to be_false
  end
end

Then /^the "([^"]*)" field(?: within (.*))? should( not)? contain "([^"]*)"$/ do |field, parent, negative, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    field_value ||= ''
    unless negative
      field_value.should =~ /#{value}/
    else
      field_value.should_not =~ /#{value}/
    end
  end
end

Then(/^I should be on the "([^"]*)" page for ([^"]*) "([^"]*)"/) do |action, controller, title|
  expect(current_path).to eq url_for_title(action: action, controller: controller, title: title)
end

Given(/^I (?:am on|go to) the "([^"]*)" page for ([^"]*) "([^"]*)"$/) do |action, controller, title|
  visit url_for_title(action: action, controller: controller, title: title)
end

Then(/^I should( not be able to)? see a link to "([^"]*)" page for ([^"]*) "([^"]*)"$/) do |invisible, action, controller, title|
  page.has_link?(action, href: url_for_title(action: action, controller: controller, title: title))
  unless invisible
    page.should have_text title, visible: false
  end
end

Then(/^show me the page$/) do
  save_and_open_page
end

Then /^save a screenshot of the page at "([^"]*)"$/ do |path|
  #works with Poltergeist driver
  page.save_screenshot(path, full: true)
end

When(/^I select "([^"]*)" to "([^"]*)"$/) do |field, option|
  find(:select, field).find(:option, option).select_option
end

When(/^I should see a selector with options$/) do |table|
  table.rows.flatten.each do |option|
    page.should have_select(:options => [option])
  end
end

Then(/^I should see the sidebar$/) do
  page.find(:css, '#sidebar')
end

Then(/^I should( not)? see the supporter content/) do |negative|
  unless negative
    expect(page).to have_css 'div#sponsorsBar', visible: true
  else
    expect(page).to_not have_css '#sponsorsBar'
  end
end

Then(/^I should( not)? see the round banners/) do |negative|
  unless negative
    expect(page).to have_css '.circle', visible: true
  else
    expect(page).to_not have_css '.circle'
  end
end

When(/^I click the very stylish "([^"]*)" button$/) do |button|
  find(:css, %Q{a[title="#{button.downcase}"]}).click()
end

Then(/^I should (not |)see the very stylish "([^"]*)" button$/) do |should, button|
  if should == 'not '
    page.should_not have_css %Q{a[title="#{button.downcase}"]}
  else
    page.should have_css %Q{a[title="#{button.downcase}"]}
  end
end

Then(/^I should see the sub-documents in this order:$/) do |table|
  expected_order = table.raw.flatten
  actual_order = page.all('li.listings-item a').collect(&:text)
  actual_order.should eq expected_order
end

Then /^I should see a "([^"]*)" table with:$/ do |name, table|
  expect(page).to have_text(name)
  table.rows.flatten.each do |heading|
    expect(page).to have_css('table th', :text => heading)
  end
end

Then(/^I should see (\d+) rows with text "(.*?)" in a table$/) do |count, text|
  expect(page).to have_css('table tr', text: text, count: count)
end

Then(/^I check "([^"]*)"$/) do |item|
  check item
end

When(/^I refresh the page$/) do
  visit current_url
end

Then(/^I should see a link "([^"]*)" to "([^"]*)"$/) do |text, link|
  expect(page).to have_css "a[href='#{link}']", text: text
end

Then(/^I should see an image with source "([^"]*)"$/) do |source|
  expect(page).to have_css "img[src*=\"#{source}\"]"
end

Then(/^I should see an video with source "([^"]*)"$/) do |source|
  expect(page).to have_css "iframe[src*=\"#{source}\"]"
end

Then /^I should( not)? see "([^"]*)" under "([^"]*)"$/ do |negative, title_1, title_2|
  if negative
    expect(page.body).not_to match(/#{title_2}.*#{title_1}/m)
  else
    expect(page.body).to match(/#{title_2}.*#{title_1}/m)
  end
end

Then /^I should( not)? see "([^"]*)" in table "([^"]*)"$/ do |negative, title, table_name|
  within ("table##{table_name}") do
    if negative
      expect(page.body).not_to have_content(/#{title}/m)
    else
      expect(page.body).to have_content(/#{title}/m)
      end
  end
end

Given(/^I am on a (.*)/) do |device|
  case device
    when 'desktop'
      agent = 'Poltergeist'
    when 'tablet'
      agent = 'Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10'
    when 'smartphone'
      agent = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7'
    else
      pending
  end
  page.driver.headers = { 'User-Agent' => agent }
end
