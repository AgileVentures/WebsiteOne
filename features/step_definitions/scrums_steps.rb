# frozen_string_literal: true

Then(/^I should see 20 events in descending order by published date$/) do
  dates = page.text.scan(/\d{4}-\d{2}-\d{2}/)
  clocks = page.all(:css, '.fa-clock-o')
  expect(clocks.count).to eq(20)
  expect(dates.sort { |x, y| y <=> x }).to eq(dates)
end

Then(/^I should see a modal window with the (first|second) scrum$/) do |ord|
  ord_hash = { 'first' => 0, 'second' => 1 }
  expect(page.find('#scrumVideo')[:style]).to include('display: block;')
  title = page.body.delete("\n").scan(%r{</i>\s*(.*?)\s*</a>})[ord_hash[ord]]
  expect(page).to have_selector('#playerTitle', text: title[1])
end

Then(/^I should not see a modal window$/) do
  expect(page.evaluate_script("$('.modal').css('display')")).to eq 'none'
end

When(/^I click the (first|second) scrum in the timeline$/) do |ordinal|
  page.all(:css, 'a.scrum_yt_link').send(ordinal.to_sym).click
end

When(/^I close the modal$/) do
  page.find(:css, '.close').click
  expect(page).not_to have_css('.close')
end

Given('that there are {int} past events') do |number|
  number.times do
    create(:event_instance,
           category: 'Scrum',
           created_at: rand(1.months.seconds.to_i).seconds.ago,
           project_id: nil)
  end
end

Given('that there are {int} past non-scrum events') do |number|
  number.times do
    create(:event_instance,
           category: 'Pair Programming',
           created_at: rand(1.months.seconds.to_i).seconds.ago,
           project_id: nil)
  end
end

Given('there is one past scrum with invalid youtube id') do
  create(:event_instance,
         yt_video_id: nil,
         title: 'Invalid',
         category: 'Scrum',
         project_id: nil)
end

Then("video with youtube id nil shouldn't be clickable") do
  event = EventInstance.find_by_title('Invalid')
  expect(page).not_to have_css("a##{event.id}")
end

Then('wait {int} second') do |int|
  sleep int
end
