Then(/^I should see 20 scrums in descending order by published date:$/) do
  dates = page.text.scan(/\d{4}-\d{2}-\d{2}/)
  clocks = page.all(:css, ".glyphicon-time")
  expect(clocks.count).to eq(20)
  expect(dates.sort { |x,y| y <=> x }).to eq(dates)
end

Given(/^I play a video$/) do
  playvideo = page.first(:xpath, "//h4[@class=\"timeline-title\"]/a[contains(@class,\"yt_link\")]")['href']
  click_link playvideo
end

Then(/^I should see a modal window with the (first|second) scrum$/) do |ord|
  ord_hash ={"first" => 0, "second" => 1}
  expect(page.find("#player")[:style]).to eq("display: block; ")
  title = page.body.gsub(/\n/,'').scan(/<\/span><\/a>\s*(.*?)\s*<\/h4>/)[ord_hash[ord]]
  page.should have_selector('#playerTitle', text: title[0])
end

Then(/^I should not see a modal window$/) do
  page.evaluate_script("$('.modal').css('display')").should eq "none"
end

When(/^I click the first scrum in the timeline$/) do
  title = page.body.gsub(/\n/,'').scan(/<\/span><\/a>\s*(.*?)\s*<\/h4>/)[0]
  vid = page.body.gsub(/\n/,'').scan(/<a class=\"scrum_yt_link.*?id=\"(.*?)"/).flatten
  page.find(:xpath, "//a[@id=\"#{vid[0]}\"]").click
end

When(/^I click the second scrum in the timeline$/) do
  vid = page.body.gsub(/\n/,'').scan(/<a class=\"scrum_yt_link.*?id=\"(.*?)"/).flatten
  page.find(:xpath, "//a[@id=\"#{vid[1]}\"]").trigger('click')
  title = page.body.gsub(/\n/,'').scan(/<\/span><\/a>\s*(.*?)\s*<\/h4>/)[1]
end

When(/^I close the modal$/) do
  page.find(:css,".close").click
end
