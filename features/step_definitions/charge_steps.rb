Given(/^I fill in appropriate card details$/) do
  stripe_iframe = all('iframe[name=stripe_checkout_app]').last
  Capybara.within_frame stripe_iframe do
    fill_in 'Email', with: 'random@morerandom.com'
    fill_in 'Card number', with: '4242 4242 4242 4242'
    fill_in 'CVC', with: '123'
    fill_in 'cc-exp', with: "12/2019"
    click_button "Pay £10.00"
  end
  sleep(3)
end