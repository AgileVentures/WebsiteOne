Given(/^I fill in appropriate card details for premium(?: for user with email "([^"]*)")?$/) do |email|
  stripe_iframe = all('iframe[name=stripe_checkout_app]').last
  # byebug
  email = email.present? ? email : 'random@morerandom.com'
  Capybara.within_frame stripe_iframe do
    fill_in 'Email', with: email
    fill_in 'Card number', with: '4242 4242 4242 4242'
    fill_in 'CVC', with: '123'
    fill_in 'cc-exp', with: "12/2019"
    click_button "Pay £10.00"
  end
  sleep(3)
end

Given(/^I fill in updated card details for premium(?: for user with email "([^"]*)")?$/) do |email|
  stripe_iframe = all('iframe[name=stripe_checkout_app]').last
  # byebug
  email = email.present? ? email : 'random@morerandom.com'
  Capybara.within_frame stripe_iframe do
    fill_in 'Email', with: email
    fill_in 'Card number', with: '4242 4242 4242 4242'
    fill_in 'CVC', with: '123'
    fill_in 'cc-exp', with: "12/2019"
    click_button "Update Card Details"
  end
  sleep(3)
end

Given(/^I fill in appropriate card details for premium plus$/) do
  stripe_iframe = all('iframe[name=stripe_checkout_app]').last
  Capybara.within_frame stripe_iframe do
    fill_in 'Email', with: 'random@morerandom.com'
    fill_in 'Card number', with: '4242 4242 4242 4242'
    fill_in 'CVC', with: '123'
    fill_in 'cc-exp', with: "12/2019"
    click_button "Pay £100.00"
  end
  sleep(3)
end