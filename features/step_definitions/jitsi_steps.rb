Then(/^I should see a start jitsi meet button$/) do
  expect(page).to have_css '#start-jitsi'
  # src = page.find(:css, '.btn-jitsi a')['src']
  # expect(src).to eq('https://meet.jit.si/AV_Scrum')
end
