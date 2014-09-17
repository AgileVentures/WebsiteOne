
Then(/^I should see "(.*?)" tab is active$/) do |tab|
  Timeout::timeout(3.0) do
    until page.has_css?("##{tab}.active") do
      sleep(0.005)
    end
  end
  expect(page).to have_css "##{tab}.active"
end
