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
    when 'foobar' then
      visit ("/#{page}")
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


# THEN steps

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
    page.should have_text string
  else
    page.should_not have_text string
  end
end


Then /^I should( not)? see "([^"]*)" in "([^"]*)"$/ do |negative, string, scope|
  within(selector_for(scope)) { step %Q{I should#{negative} see "#{string}"} }
end

Then /^I should( not)? see link "([^"]*)"$/ do |negative, link|
  unless negative
    expect(page.has_link? link).to be_true
  else
    expect(page.has_link? link).to be_false
  end
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
  #puts page.body
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

#Then(/^I should see "(.*?)"$/) do |string|
#  #expect(page).to have_content(string)
#  page.should have_content(string)
#end

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

#Then(/^I should see "([^"]*)" created_by marcelo (\d+) days ago first$/) do |string, arg|
#  page.should have_text string
#end
#
#
#And(/^I should see "([^"]*)" created_by thomas (\d+) days ago second$/) do |string, arg|
#  page.should have_text string
#end

Then(/^I should see the sub-documents in this order:$/) do |table|
  expected_order = table.raw.flatten
  actual_order = page.all('li.listings-item a').collect(&:text)
  actual_order.should eq expected_order
end


Given(/^The project "([^"]*)" has (\d+) (.*)$/) do |title, num, item|
  project = Project.find_by_title(title)
  case item.downcase.pluralize
    when 'members'
      (1..num.to_i).each do
        u = User.create(email: Faker::Internet.email, password: '1234567890')
        u.follow(project)
      end

    else
      pending
  end
end


Then /^I should see a "([^"]*)" table with:$/ do |name, table|
  expect(page).to have_text(name)
  table.rows.flatten.each do |heading|
    expect(page).to have_css('table th', :text => heading)
  end
end

Then(/^I check "([^"]*)"$/) do |item|
  check item
end

When(/^I refresh the page$/) do
  visit current_url
end

Then(/^I should see a link "([^"]*)" to "([^"]*)"$/) do |text, link|
  page.should have_css "a[href='#{link}']", text: text
end


Then(/^I should see an image with source "([^"]*)"$/) do |source|
  page.should have_css "img[src*=\"#{source}\"]"
end
