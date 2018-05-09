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

Given(/^the following events exist that repeat every weekday:$/) do |table|
  table.hashes.each do |hash|
    hash[:project_id] = Project.find_by(title: hash['project']).id unless hash['project'].blank?
    hash[:repeats_weekly_each_days_of_the_week_mask] = 31
    hash[:repeats_every_n_weeks] = 1
    hash[:repeats] = 'weekly'
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
  @jump_date = jump_date
  Delorean.time_travel_to(Time.parse(@jump_date))
end

And(/^(\d+) minutes pass$/) do |minutes|
  mn = "\"45:00\""
  page.execute_script "window.clock.tick(#{mn});"
  sleep 5
end

When(/^I follow "([^"]*)" for "([^"]*)" "([^"]*)"$/) do |linkid, table_name, hookup_number|
  links = page.all(:css, "table##{table_name} td##{linkid} a")
  link = links[hookup_number.to_i - 1]
  link.click
end

And(/^I click on the "([^"]*)" div$/) do |arg|
  find("div.#{arg}").click
end

And(/^I select "([^"]*)" from the event for dropdown$/) do |for_whom|
  page.select for_whom, from: "event_for"
end

And(/^I select "([^"]*)" from the event project dropdown$/) do |project_name|
  page.select project_name, from: "event_project_id"
end

When(/^I select "([^"]*)" from the event category dropdown$/) do |category|
  page.select category, from: "event_category"
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

And(/^the short local date element should be set to "([^"]*)"$/) do |datetime|
  expect(page).to have_css %Q{time[datetime="#{datetime}"][data-format="%a, %b %d, %Y"]}
end

And(/^the local time element should be set to "([^"]*)"$/) do |datetime|
  expect(page).to have_css %Q{time[datetime="#{datetime}"][data-format="%H:%M"]}
end


And(/^"([^"]*)" is selected in the project dropdown$/) do |project_slug|
  project_id = project_slug == 'All' ? '' : Project.friendly.find(project_slug).id
  expect(find("#project_id").value).to eq project_id.to_s
end


And(/^"([^"]*)" is selected in the event project dropdown$/) do |project_slug|
  project_id = project_slug == 'All' ? '' : Project.friendly.find(project_slug).id
  expect(find("#event_project_id").value).to eq project_id.to_s
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

Given(/^an event "([^"]*)"$/) do |event_name|
  @event = Event.find_by_name(event_name)
  @google_id = '123456789'
end


When(/^the HangoutConnection has pinged to indicate the event (start|continuing)$/) do |type|
  participants = {"0"=>{"id"=>"hangout2750757B_ephemeral.id.google.com^a85dcb4670", "hasMicrophone"=>"true", "hasCamera"=>"true", "hasAppEnabled"=>"true", "isBroadcaster"=>"true", "isInBroadcast"=>"true", "displayIndex"=>"0", "person"=>{"id"=>"108533475599002820142", "displayName"=>"Alejandro Babio", "image"=>{"url"=>"https://lh4.googleusercontent.com/-p4ahDFi9my0/AAAAAAAAAAI/AAAAAAAAAAA/n-WK7pTcJa0/s96-c/photo.jpg"}, "na"=>"false"}, "locale"=>"en", "na"=>"false"}}
  header 'ORIGIN', 'a-hangout-opensocial.googleusercontent.com'
  put "/hangouts/@google_id", {title: @event.name, host_id: '3', event_id: @event.id,
                               participants: participants, hangout_url: 'http://hangout.test',
                               hoa_status: 'live', project_id: '1', category: 'Scrum', yt_video_id: '11'}
end

Then(/^appropriate tweets will be sent$/) do
  if Settings.features.twitter.notifications.enabled == true
    expect(WebMock).to have_requested(:post, 'https://api.twitter.com/1.1/statuses/update.json').
      with { |req| req.body =~ /hangout\.test/ }
  end

end

Then(/^the youtube link will not be sent$/) do
  expect(WebMock).not_to have_requested(:post, 'https://api.twitter.com/1.1/statuses/update.json').
      with { |req| req.body =~ /youtu\.be\/11/ }
end

Then(/^the youtube link will be sent$/) do
  expect(WebMock).not_to have_requested(:post, 'https://api.twitter.com/1.1/statuses/update.json').twice.
      with { |req| req.body =~ /youtu\.be\/11/ }
end

Then(/^the hangout link will be sent$/) do
  if Settings.features.twitter.notifications.enabled == true
    expect(WebMock).to have_requested(:post, 'https://api.twitter.com/1.1/statuses/update.json').
      with { |req| req.body =~ /hangout\.test/ }
  end
end

Then(/^the event should (still )?be live$/) do |ignore|
  visit event_path(@event)
  expect(page).to have_content('This event is now live!')
end

And(/^after three (more )?minutes$/) do |ignore|
  Delorean.time_travel_to '3 minutes from now'
end

And(/^after one (more )?minute$/) do |ignore|
  Delorean.time_travel_to '1 minute from now'
end

When(/^the HangoutConnection pings to indicate the event is ongoing$/) do
  event_instance = @event.event_instances.first
  header 'ORIGIN', 'a-hangout-opensocial.googleusercontent.com'
  put "/hangouts/#{event_instance.uid}", {title: event_instance.title, host_id: event_instance.user_id, event_id: @event.id,
                                          participants: event_instance.participants, hangout_url: event_instance.hangout_url,
                                          hoa_status: 'live', project_id: event_instance.project_id, category: event_instance.category,
                                          yt_video_id: event_instance.yt_video_id}

end

Then(/^the event should be dead$/) do
  visit event_path(@event)
  expect(page).not_to have_content('This event is now live!')
end

Given(/^the event "([^"]*)"$/) do |name|
  @event = Event.find_by(name: name)
end

Then(/^they should see the icon of the creator of the event$/) do
  expect(page).to have_xpath("//a[@href='#{user_path(@event.creator)}']/img[contains(@src, 'https://www.gravatar.com/avatar/0bc83cb571cd1c50ba6f3e8a78ef1346?s=80&d=retro')]")
end

Then(/^they should see the icon of the modifier of the event$/) do
  expect(page).to have_xpath("//a[@href='#{user_path(@event.modifier)}']/img[contains(@src, 'https://www.gravatar.com/avatar/8c5d77ccca5d26e3ae00ddb782876d74?s=80&d=retro')]")
end

Then(/^they should see a link to the creator of the event$/) do
  expect(page).to have_link(@event.creator.display_name, href: user_path(@event.creator))
end

Then(/^they should see a link to the modifier of the event$/) do
  expect(page).to have_link(@event.modifier.display_name, href: user_path(@event.modifier))
end

Then(/^they should see the date of when it was created$/) do
  expect(page).to have_content(@event.created_at.strftime "%F")
end

Then(/^they should see the date of when it was modified$/) do
  expect(page).to have_content(@event.updated_at.strftime "%F")
end

Given(/^that "([^"]*)" created the "([^"]*)" event$/) do |first_name, event_name|
  @event = Event.find_by(name: event_name)
  @event.creator = User.find_by(first_name: first_name)
  @event.save
end

Given(/^that "([^"]*)" modified the "([^"]*)" event$/) do |first_name, event_name|
  step "I am logged in as \"#{first_name}\""
  step "I visit the edit page for the event named \"#{event_name}\""
  step "I click the \"Save\" button"
end

And(/^The box for "([\w]+)" should be checked$/) do |day|
  box = page.find("#event_repeats_weekly_each_days_of_the_week_#{day.downcase}")
  expect(box).to be_checked
end


When(/^I click the calendar icon$/) do
  find('#calendar_link').click
end

Then(/^the export to google calendar link should not be visible$/) do
  expect(page).not_to have_css("#calendar_links", visible: true)
end


And(/^I should not see any HTML tags$/) do
  expect(page).not_to match /<.*>/
end

Then(/^I should see (\d+) "([^"]*)" events$/) do |number, event|
  expect(page.all(:css, 'a', text: event, visible: false).count).to be == number.to_i
end
