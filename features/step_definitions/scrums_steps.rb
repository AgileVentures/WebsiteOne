Then(/^I should see 20 scrums in descending order by published date:$/) do
  dates = page.text.scan(/\d{4}-\d{2}-\d{2}/)
  clocks = page.all(:css, '.fa-clock-o')
  expect(clocks.count).to eq(20)
  expect(dates.sort { |x,y| y <=> x }).to eq(dates)
end

Then(/^I should see a modal window with the (first|second) scrum$/) do |ord|
  ord_hash ={"first" => 0, "second" => 1}
  expect(page.find("#scrumVideo")[:style]).to include("display: block;")
  title = page.body.gsub(/\n/,'').scan(/<\/i>\s*(.*?)\s*<\/a>/)[ord_hash[ord]]
  expect(page).to have_selector("#playerTitle", text: title[1])
end

Then(/^I should not see a modal window$/) do
  expect(page.evaluate_script("$('.modal').css('display')")).to eq "none"
end

When(/^I click the (first|second) scrum in the timeline$/) do |ordinal|
  page.all(:css, "a.scrum_yt_link").send(ordinal.to_sym).click
end

When(/^I close the modal$/) do
  page.find(:css,'.close').click
  expect(page).not_to have_css('.close')
end

Given(/^that there are (\d+) past scrums$/) do |number|
  FactoryGirl.create_list(:event_instance, number.to_i, category: 'Scrum', created_at: rand(1.months.seconds.to_i).seconds.ago, project_id: nil)
end
