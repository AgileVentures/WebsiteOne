Then(/^I should see a start jitsi meet button$/) do
  expect(page).to have_css('#start-jitsi')
  url = page.find(:css, '#start-jitsi').find(:xpath,"..")[:href]
  expect(url).to eq('https://meet.jit.si/AV_Repeat_Scrum')
end
