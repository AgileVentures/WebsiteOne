Given(/^I visit the edit page for the event named "(.*?)"$/) do |event_name|
  visit edit_event_path(Event.find_by(name: event_name))
end

Then(/^the "(.*?)" selector should be set to "(.*?)"$/) do |selector, value|
  #note: expect(page).to have_select(selector, selected: "on") passes right now which encodes the error
  #delete this after finishing this feature
  expect(page).to have_select(selector, selected: value)
end

Then(/^the event is set to end sometime$/) do
  expect(page).to have_select('event_repeat_ends_string', selected: 'on')
end

Given(/^I am on ([^"]*) index page$/) do |page|
  case page.downcase
    when 'events'
      visit events_path
    when 'projects'
      visit projects_path
    else
      visit project_events_path(Project.find_by(title: "cs169"))
  end
end


Given(/^I click on the event body for the event named "(.*?)"$/) do |name|
  e = Event.find_by(name: name)
  page.find(:css, "#details_#{e.id}").click
end

Given(/^following events exist:$/) do |table|
  table.hashes.each do |hash|
    hash[:project_id] = Project.find_by(title: hash['project']).id unless hash['project'].blank?
    hash.delete('project')
    Event.create!(hash)
  end
end

Given(/^following events exist for project "([^"]*)" with active hangouts:$/) do |project_title, table|
  project = Project.where(title: "#{project_title}").take

  table.hashes.each do |hash|
    event = Event.create!(hash)
    event.event_instances.create(hangout_url: 'x@x.com',
                                 updated_at: 1.minute.ago,
                                 category: event.category,
                                 title: event.name,
                                 project_id: project.id
    )

  end
end

Then(/^I should be on the Events "([^"]*)" page$/) do |page|
  case page.downcase
    when 'index'
      expect(current_path).to eq events_path

    when 'create'
      expect(current_path).to eq events_path
    else
      pending
  end
end

Then(/^I should see multiple "([^"]*)" events$/) do |event|
  #puts Time.now
  expect(page.all(:css, 'a', text: event, visible: false).count).to be > 1
end

When(/^the next event should be in:$/) do |table|
  table.rows.each do |period, interval|
    expect(page).to have_content([period, interval].join(' '))
  end
end

Given(/^I am on the show page for event "([^"]*)"$/) do |name|
  event = Event.find_by_name(name)
  visit event_path(event)
end

Then(/^I should be on the event "([^"]*)" page for "([^"]*)"$/) do |page, name|
  event = Event.find_by_name(name)
  page.downcase!
  case page
    when 'show'
      expect(current_path).to eq event_path(event)
    else
      expect(current_path).to eq eval("#{page}_event_path(event)")
  end
end

Given(/^the date is "([^"]*)"$/) do |jump_date|
  Delorean.time_travel_to(Time.parse(jump_date))
end

When(/^I follow "([^"]*)" for "([^"]*)" "([^"]*)"$/) do |linkid, table_name, hookup_number|
  links = page.all(:css, "table##{table_name} td##{linkid} a")
  link = links[hookup_number.to_i - 1]
  link.click
end


And(/^I click on the "([^"]*)" div$/) do |arg|
  find("div.#{arg}").click
end

And(/^I select "([^"]*)" from the event project dropdown$/) do |project_name|
  page.select project_name, from: "event_project_id"
end

And(/^I select "([^"]*)" from the project dropdown$/) do |project_name|
  page.select project_name, from: "project_id"
end

Given(/^I select "([^"]*)" from the time zone dropdown$/) do |timezone|
  page.select timezone, from: "start_time_tz"
end

And(/^the event named "([^"]*)" is associated with "([^"]*)"$/) do |event_name, project_title|
  event = Event.find_by(name: event_name)
  expect(event.project.title).to eq project_title
end

Given(/^the browser is in "([^"]*)" and the server is in UTC$/) do |tz|
  ENV['TZ'] = tz
  visit root_path
  sleep(5)
  ENV['TZ'] = 'UTC'
end

And(/^the local date element should be set to "([^"]*)"$/) do |datetime|
  expect(page).to have_css %Q{time[datetime="#{datetime}"][data-format="%A, %B %d, %Y"]}
end

And(/^the local time element should be set to "([^"]*)"$/) do |datetime|
  expect(page).to have_css %Q{time[datetime="#{datetime}"][data-format="%H:%M"]}
end


And(/^"([^"]*)" is selected in the project dropdown$/) do |project_slug|
  project_id = project_slug == 'All' ? '' : Project.friendly.find(project_slug).id
  expect(find("#project_id").value).to eq project_id.to_s
end

And(/^the start time is "([^"]*)"$/) do |start_time|
  expect(find("#start_time").value).to eq start_time
end

And(/^the start date is "([^"]*)"$/) do |start_date|
  expect(find("#start_date").value).to eq start_date
end

# would like this to be more robust
Given(/^daylight savings are in effect now$/) do
  Delorean.time_travel_to(Time.parse('2015/06/14 09:15:00 UTC'))
end

And(/^the user is in "([^"]*)"$/) do |zone|
  @zone = zone
end

# must visit edit event page to ensure form is loaded
# before we fix zone as per instance variable set in above step
# and then rerun the handleUserTimeZone js method that is run
# on page load.  We use this approach because we cannot find a
# reliable way of setting Capybara timezone that will work on CI
def stub_user_browser_to_specific_timezone
  visit edit_event_path(@event)
  page.execute_script("timeZoneUtilities.detectUserTimeZone = function(){return '#{@zone}'};")
  page.execute_script('editEventForm.handleUserTimeZone();')
  @form_tz = find("#start_time_tz").value
  @tz = TZInfo::Timezone.get(@zone)
  expect(@form_tz).to eq(@zone)
end

And(/^edits an event with start date in standard time$/) do
  @event = Event.find_by(name: 'Daily Standup')
  stub_user_browser_to_specific_timezone
  @start_date = find("#start_date").value
  @start_time = find("#start_time").value
end

When(/^they save without making any changes$/) do
  click_link_or_button 'Save'
end

Then(/^the event date and time should be unchanged$/) do
  expect(current_path).to eq event_path(@event)
  stub_user_browser_to_specific_timezone
  expect(find("#start_date").value).to match @start_date
  expect(find("#start_time").value).to match @start_time
end

Given(/^it is now past the end date for the event$/) do
  @event = Event.find_by(name: 'Daily Standup')
  Delorean.time_travel_to(@event.repeat_ends_on + 1.day)
end

And(/^they edit and save the event without making any changes$/) do
  visit edit_event_path(@event)
  @start_date = find("#start_date").value
  @start_time = find("#start_time").value
  click_link_or_button 'Save'
end

# would love to split this in two so we can re-use for two other scenarios
Given(/^daylight savings are in effect and it is now past the end date for the event$/) do
  @event = Event.find_by(name: 'Daily Standup')
  Delorean.time_travel_to(@event.repeat_ends_on.change(month: 6) + 1.year)
end

Then(/^the user should see the date and time adjusted for their timezone in the edit form$/) do
  stub_user_browser_to_specific_timezone
  @start_date = find("#start_date").value
  @start_time = find("#start_time").value
  expect(@start_date).to eq @tz.utc_to_local(@event.start_datetime).to_date.strftime("%Y-%m-%d")
  expect(@start_time).to eq @tz.utc_to_local(@event.start_datetime).to_time.strftime("%I:%M %p")
end

Given(/^an existing event$/) do
  @event = Event.find_by(name: 'Daily Standup')
end

Then(/^the user should see the date and time adjusted for their timezone and updated by (\d+) hours in the edit form$/) do |hours|
  stub_user_browser_to_specific_timezone
  @start_date = find("#start_date").value
  @start_time = find("#start_time").value
  expect(@start_time).to eq @tz.utc_to_local(@event.start_datetime - hours.to_i.hours).to_time.strftime("%I:%M %p")
  expect(@start_date).to eq @tz.utc_to_local(@event.start_datetime - hours.to_i.hours).to_date.strftime("%Y-%m-%d")
end

When(/^they view the event "([^"]*)"$/) do |event_name|
  @event = Event.find_by(name: event_name)
  visit event_path(@event)
  page.execute_script("timeZoneUtilities.detectUserTimeZone = function(){return '#{@zone}'};")
  page.execute_script('showEvent.showUserTimeZone();')
end