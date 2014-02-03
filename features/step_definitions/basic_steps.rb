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
    when 'sign in' then
      new_user_session_path
    when 'projects' then
      projects_path
    when 'new project' then
      new_project_path
    when 'edit' then
      edit_project_path(id)
    when 'show' then
      project_path(id)
    when 'our members' then
      users_index_path
    else
      raise('path to specified is not listed in #path_to')
  end
end

# GIVEN steps

Given(/^I visit the site$/) do
  visit root_path
end

Given(/^I am on the "([^"]*)" page$/) do |page|
  visit path_to(page)
end

#Given(/^I am on the "([^"]*)" page for ([^"]*) "([^"]*)"$/) do |action, controller, title|
#  visit url_for_title(action: action, controller: controller, title: title)
#end

# WHEN steps
When(/^I go to the "([^"]*)" page$/) do |page|
  visit path_to(page)
end

When(/^I click "([^"]*)"$/) do |text|
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

When(/^I follow "([^"]*)"$/) do |text|
  click_link text
end


When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in field, :with => value
end

When(/^I fill in:$/) do |table|
  table.rows.each do |row|
    fill_in row[0], with: row[1]
  end
end

When /^I accept the warning popup$/ do
  # works only with @javascript tagged scenario
  page.driver.browser.accept_js_confirms
end


# THEN steps

Then /^I should be on the "([^"]*)" page$/ do |page|
  expect(current_path).to eq path_to(page)
end

#Then /^I am redirected to the "([^"]*)" page$/ do |page|
#  expect(current_path).to eq path_to(page)
#end
Then /^I should see a form with:$/ do |table|
  table.rows.each do |row|
    step %Q{the "#{row[0]}" field should contain "#{row[1]}"}
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
    page.should have_text string
  else
    page.should_not have_text string
  end
end

Then /^I should see link "([^"]*)"$/ do |link|
  page.should have_link link
end

Then /^I should see field "([^"]*)"$/ do |field|
  page.should have_field(field)
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

Given(/^I am on the "([^"]*)" page for ([^"]*) "([^"]*)"$/) do |action, controller, title|
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
When(/^I select "([^"]*)" to "([^"]*)"$/) do |field, option|
  find(:select, field).find(:option, option).select_option
end

When(/^I should see a selector with options$/) do |table|
  table.rows.flatten.each do |option|
    page.should have_select(:options => [option])
  end
end

Then(/^I should see the sidebar$/) do
  page.find(:css, 'nav#sidebarnav')
end

Then(/(.*) within the ([^"]*)$/) do |s, m|
  m = m.downcase
  if m == 'mercury editor'
    page.driver.within_frame('mercury_iframe') { step(s) }
  else
    selector_for = {
        'sidebar' => '#sidebar'
    }
    page.within(selector_for[m]) { step(s) }
  end
end

Given(/^I want to use third party authentications$/) do
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
      'provider' => 'github',
      'uid' => '12345678',
      'info' => {
          'email' => 'mock@email.com'
      }
  }
  OmniAuth.config.mock_auth[:gplus] = {
      'provider' => 'gplus',
      'uid' => '12345678',
      'info' => {
          'email' => 'mock@email.com'
      }
  }
end
