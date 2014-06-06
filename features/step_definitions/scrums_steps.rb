

Given(/^I visit "(.*?)" page$/) do |path|
  visit path
end


Then(/^I should see 20 scrums in descending order by published date:$/) do
  dates = page.text.scan(/\d{4}-\d{2}-\d{2}/)
  expect(dates.count).to eq(20)
  expect(dates.sort { |x,y| y <=> x }).to eq(dates)
end

Then(/^I should see a modal window with the first scrum$/) do
  expect(page.find("#player")[:style]).to eq("display: block; ")
  title = page.body.gsub(/\n/,'').scan(/<\/span><\/a>\s*(.*?)\s*<\/h4>/)[0]
  page.should have_selector('#playerTitle', text: title[0])
end

Then(/^I should see a modal window with the second scrum$/) do
  vid = page.body.gsub(/\n/,'').scan(/<a class=\"yt_link.*?id=\"(.*?)"/).flatten
  expect(page.find("#player")[:style]).to eq("display: block; ")
  page.should have_selector('#playerTitle', text: title[0])
end

Then(/^I should not see a modal window$/) do
  page.evaluate_script("$('.modal').css('display')").should eq "none"
end

When(/^I close the video window$/) do
    pending # express the regexp above with the code you wish you had
end

Then(/^the video should stop playing$/) do
    pending # express the regexp above with the code you wish you had
end

When(/^I stop the video$/) do
    pending # express the regexp above with the code you wish you had
end

When(/^I click the first scrum in the timeline$/) do
  title = page.body.gsub(/\n/,'').scan(/<\/span><\/a>\s*(.*?)\s*<\/h4>/)[0]
  vid = page.body.gsub(/\n/,'').scan(/<a class=\"yt_link.*?id=\"(.*?)"/).flatten
  page.find(:xpath, "//a[@id=\"#{vid[0]}\"]").click
end

When(/^I click the second scrum in the timeline$/) do
  vid = page.body.gsub(/\n/,'').scan(/<a class=\"yt_link.*?id=\"(.*?)"/).flatten
  page.find(:xpath, "//a[@id=\"#{vid[1]}\"]").trigger('click')
  title = page.body.gsub(/\n/,'').scan(/<\/span><\/a>\s*(.*?)\s*<\/h4>/)[1]
end
When(/^I close the modal$/) do
  page.find(:css,".close").click
end
