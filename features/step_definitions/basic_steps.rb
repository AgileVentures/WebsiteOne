def url_for_title(options)
  controller = options[:controller]
  eval("#{controller.capitalize.singularize}.find_by_title('#{options[:title]}').url_for_me(options[:action].downcase)")
end

def path_to(page_name, id = '')
  name = page_name.downcase
  case name
    when 'home' then
      root_path
    when 'about' then
      '/about-us'
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
    when 'articles with ruby tag' then
      articles_path(tag: 'Ruby')
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
    when 'premium membership' then
      static_page_path('premium')
    when 'premium mob membership' then
      static_page_path('premium_mob')
    when 'getting started' then
      static_page_path('getting-started')
    when 'sign up' then
      new_user_registration_path
    when 'premium sign up' then
      new_subscription_path(plan: 'premium')
    when 'premium mob sign up' then
      new_subscription_path(plan: 'premiummob')
    when 'av dashboard token' then
      get_av_dashboard_token_path
    when 'event' then
      event_path(id: id)
    else
      raise('path to specified is not listed in #path_to')
  end
end

# GIVEN steps


Then(/^show me the page$/) do
  save_and_open_page
end

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

When(/^I (?:go to|am on) the "([^"]*)" event page$/) do |name|
  id = Event.find_by_name(name).id
  visit path_to('event', id)
end

When(/^(?:when I|I) click "([^"]*)"$/) do |text|
  click_link_or_button(text)
end

When(/^(?:when I|I) click the first instance of "([^"]*)"$/) do |text|
  click_link_or_button(text, match: :first)
end

When(/^I click the "([^"]*)" button$/) do |button|
  click_link_or_button button
end

When(/^I open the Edit URL controls/) do
  page.execute_script(  %q{$('li[role="edit_hoa_link"] > a').trigger('click')}  )
end

When(/^I click on the Save button/) do
  page.find(:css, %q{input[id="hoa_link_save"]}).trigger('click')
end

When(/^I click on the Cancel button/) do
  page.find(:css, %q{button[id="hoa_link_cancel"]}).trigger('click')
end

Then(/^I should see the Edit URL controls/) do
  expect(page).to have_css 'div#edit-link-form.collapse.in'
end

Then(/^I should not see the Edit URL controls/) do
  expect(page).to have_css 'div#edit-link-form[style*="height: 0px"]'
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

Given (/^the time now is "([^"]*)"$/) do |time|
  # use delorean
  Time.stub(now: Time.parse(time))
end

# THEN steps

Then /^I should see link "([^"]*)" with "([^"]*)"$/ do |link, url|
  expect(page).to have_link(link, href: url)
end

Then(/^I should( not)? see a link "([^"]*)" to "([^"]*)"$/) do |negate, link, url|
  if negate
    expect(page).to have_no_link(link, href: url)
  else
    expect(page).to have_link(link, href: url)
  end
end

Then /^I should be on the "([^"]*)" page$/ do |page|
  expect(current_fullpath).to eq path_to(page)
end

def current_fullpath
  URI.parse(current_url).request_uri
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

Then (/^I should( not)? see "([^"]*)"$/) do |negative, string|
  unless negative
    expect(page).to have_text string
  else
    expect(page).to_not have_text string
  end
end

Then /^I should( not)? see a (notice|success) flash "([^"]*)"$/ do |negative, type, string|
  unless negative
    expect(page).to have_css '.alert', text: string
    expect(page).to have_css ".alert-#{type}", text: string
  else
    expect(page).not_to have_css '.alert', text: string
    expect(page).not_to have_css ".alert-#{type}", text: string
  end
end

Then /^I should( not)? see "([^"]*)" in "([^"]*)"$/ do |negative, string, scope|
  within(selector_for(scope)) { step %Q{I should#{negative} see "#{string}"} }
end

Then /^I should( not)? see link "([^"]*)"$/ do |negative, link|
  if negative
    expect(page.has_link? link).to be_falsey
  else
    expect(page.has_link? link).to be_truthy
  end
end

Then /^I should( not)? see button "([^"]*)"$/ do |negative, button|
  unless negative
    expect(page.has_link_or_button? button).to be_truthy
  else
    expect(page.has_link_or_button? button).to be_falsey
  end
end

Then /^the "([^"]*)" field(?: within (.*))? should( not)? contain "([^"]*)"$/ do |field, parent, negative, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    field_value ||= ''
    unless negative
      expect(field_value).to match(/#{value}/)
    else
      expect(field_value).to_not match(/#{value}/)
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
  if invisible
    expect(page).not_to have_link(title, href: url_for_title(action: action, controller: controller, title: title))
  else
    expect(page).to have_link(title, href: url_for_title(action: action, controller: controller, title: title))
  end
end

When(/^I select "([^"]*)" to "([^"]*)"$/) do |field, option|
  find(:select, field).find(:option, option).select_option
end

When(/^I select "([^"]*)" from "([^"]*)"$/) do |option, field|
  select option, from: field, visible: false
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
    expect(page).to_not have_css %Q{a[title="#{button.downcase}"]}
  else
    expect(page).to have_css %Q{a[title="#{button.downcase}"]}
  end
end

Then(/^I should see the sub-documents in this order:$/) do |table|
  expected_order = table.raw.flatten
  actual_order = page.all('li.listings-item a').collect(&:text)
  expect(actual_order).to eq expected_order
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

Then(/^I (un)?check "([^"]*)"$/) do |negate, item|
  if negate
    uncheck item
  else
    check item
  end
end

Then(/^I check by value "([^"]*)"$/) do |value|
  find(:css, "input[value='#{value}']").set(true)
end

When(/^I refresh the page$/) do
  visit current_url
end

def assert_link_exists path, text
  expect(page).to have_css "a[href='#{path}']", text: text
end
Then(/^I should see a link to create a new event$/) do
  assert_link_exists(new_event_path, "Create event")
end

Then(/^I should see a link to upcoming events$/) do
  assert_link_exists(events_path, "Upcoming events")
end

Then(/^I should see a link to past scrums$/) do
  assert_link_exists(scrums_path, "Past scrums")
end

Then(/^I should see a link to past events$/) do
  assert_link_exists(hangouts_path, "Past events")
end

Then(/^I should see an image with source "([^"]*)"$/) do |source|
  expect(page).to have_css "img[src*=\"#{source}\"]"
end

Then(/^I should see the "(.*)" icon$/) do |provider|
  expect(page).to have_css ".fa-#{provider}"
end

Then(/^I should see an video with source "([^"]*)"$/) do |source|
  expect(page).to have_css "iframe[src*=\"#{source}\"]"
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

And(/^I debug$/) do
  byebug
end

And(/^I remote debug/) do
  page.driver.debug
end

And(/^the window size is wide$/) do
  Capybara.page.current_window.resize_to(1300,400)
end

When(/^I toggle to( Cannot)? Attend$/) do |negated|
  find("#attendance_checkbox", visible: false).trigger('click')
end

When(/^I scroll to the bottom of the page$/) do
  page.execute_script "window.scrollBy(0,10000)"
end

Then(/^I should( not)? see "([^"]*)" within "([^"]*)"$/) do |negated, project_title, project_list_area|
  within("##{project_list_area}") do
    if negated
      expect(page).to_not have_content(project_title)
    else
      expect(page).to have_content(project_title)
    end
  end
end

Then(/^I should see "([^"]*)" within "([^"]*)":$/) do |project_title, project_list_area, table|
  table.rows.each do |row|
    project_title = row.first
    step %Q{I should see "#{project_title}" within "#{project_list_area}"}
  end
end
Then /^I should receive a file(?: "([^"]*)")?/ do |file|
  result = page.response_headers['Content-Type'].should == "text/calendar"
  if result
    result = page.response_headers['Content-Disposition'].should =~ /#{file}/
  end
  result
end