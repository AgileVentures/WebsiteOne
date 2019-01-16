Then(/^my member page should show premium details$/) do
  visit
  expect(page).to have_content 'Premium'
end

Given(/^I fill in appropriate card details for premium(?: for user with email "([^"]*)")?$/) do |email|
  email = email.present? ? email : 'random@morerandom.com'
  submit_card_details_for_button_with('Subscribe £10.00', email)
end

Given(/^I fill in appropriate card details for premium mob/) do
  submit_card_details_for_button_with('Subscribe £25.00')
end

Given(/^I fill in appropriate card details for nonprofitbasic/) do
  submit_card_details_for_button_with('Subscribe £20.00')
end

Given(/^I fill in appropriate card details for premium f2f/) do
  submit_card_details_for_button_with('Subscribe £50.00')
end

Given(/^I fill in appropriate card details for premium plus$/) do
  submit_card_details_for_button_with('Subscribe £100.00')
end

Given(/^I fill in updated card details for premium(?: for user with email "([^"]*)")?$/) do |email|
  email = email.present? ? email : 'random@morerandom.com'
  submit_card_details_for_button_with('Update Card Details', email)
end

When(/^I fill in new card details for premium for user with email "([^"]*)"$/) do |email|
  submit_card_details_for_button_with('Add Card Details', email)
end

When(/^I fill in card details for premium for user that will fail with email "([^"]*)"$/) do |email|
  custom_error = StandardError.new('Unable to create customer')
  StripeMock.prepare_error(custom_error, :new_customer)
  submit_card_details_for_button_with('Add Card Details', email)
end

def submit_card_details_for_button_with(text, email = 'random@morerandom.com', number = '4242 4242 4242 4242')
  stripe_iframe = all('iframe[name=stripe_checkout_app]').last
  Capybara.within_frame stripe_iframe do
    fill_in 'Email', with: email
    fill_in 'Card number', with: number
    fill_in 'CVC', with: '123'
    fill_in 'cc-exp', with: '12/2019'
    click_button text
  end
  sleep(3)
end

Then(/^I should see a paypal form$/) do
  expect(page).to have_xpath("//form[@action='https://www.sandbox.paypal.com/cgi-bin/webscr']")
end

Given(/^the following plans exist$/) do |table|
  table.hashes.each do |hash|
    hash['amount'] = Integer(hash['amount'])
    @stripe_test_helper.try(:create_plan, hash)
    hash[:third_party_identifier] = hash.delete('id')
    Plan.create(hash)
  end
end

And(/^a stripe customer with id "([^"]*)"$/) do |stripe_customer_id|
  StripeMock.create_test_helper.create_customer(id: stripe_customer_id)
end

And(/^there is a card error updating subscription$/) do
  StripeMock.prepare_card_error(:card_declined, :update_subscription)
end

And(/^I should see myself in the premium members list$/) do
  visit '/premium_members'
  within '.user-preview' do
    expect(page).to have_text(@user.first_name)
  end
end

Given(/^my card will be rejected$/) do
  # StripeMock.toggle_debug(true)
  StripeMock.prepare_card_error(:card_declined, :new_customer)
end

PAYPAL_REDIRECT_BODY = {'CONTEXT' => 'wtgSziM4C5x0SI-9CmKcv2vkSeTLK5P_g6HqzC__YTYkcqziFNcB84p79Ja',
                        'txn_type' => 'subscr_signup',
                        'subscr_id' => 'I-PEG1KSWM8TBU',
                        'last_name' => 'buyer',
                        'residence_country' => 'GB',
                        'mc_currency' => 'GBP',
                        'business' => 'sam-facilitator@agileventures.org',
                        'recurring' => '1',
                        'payer_status' => 'verified',
                        'first_name' => 'test',
                        'receiver_email' => 'sam-facilitator@agileventures.org',                        
                        'payer_id' => '9EG5X4H5DJJW4', 
                        'reattempt' => '1',
                        'item_number' => 'not logged in',
                        'subscr_date' => '10:07:19 Dec 12, 2016 PST',
                        'charset' => 'windows-1252',
                        'period1' => '7 D',
                        'mc_amount1' => '0.00',
                        'period3' => '1 M',
                        'mc_amount3' => '10.00',
                        'auth' => 'A31jSI5vY44zpPcQlAUk8WdibsJJT72rGx6ptiGPil6MG30OuCoFtHJ38.CJmmBQ.NNbZg.XEaWj298bVa5FZIw',
                        'form_charset' => 'UTF-8'}

And(/^Paypal updates our endpoint$/) do
  body = PAYPAL_REDIRECT_BODY.clone
  body['item_name'] = 'Premium'
  body['payer_email'] = 'sam-buyer@agileventures.org'
  post subscriptions_path, body
end

And(/^Paypal updates our endpoint for premium mob$/) do
  body = PAYPAL_REDIRECT_BODY.clone
  body['item_name'] = 'Premium Mob'
  body['payer_email'] = 'sam-buyer@agileventures.org'
  post subscriptions_path, body
end

And(/^Paypal updates our endpoint for premium mob via get$/) do
  paypal = Paypal.new 'not sponsored', 'Premium Mob', 'sam-buyer@agileventures.org'
  set_cookie "_WebsiteOne_session=#{page.driver.cookies['_WebsiteOne_session'].value}"
  get "#{subscriptions_paypal_redirect_path}?#{paypal.url_params}"
end

And(/^Paypal updates our endpoint after sponsoring Alice$/) do
  body = PAYPAL_REDIRECT_BODY.clone
  body['item_name'] = 'Premium'
  body['payer_email'] = 'sam-buyer@agileventures.org'
  body['item_number'] = 'alice-jones'

  set_cookie "_WebsiteOne_session=#{page.driver.cookies['_WebsiteOne_session'].value};"
  post subscriptions_path, body
end

And(/^Paypal updates our endpoint after sponsoring Alice via get$/) do
  paypal = Paypal.new 'alice-jones', 'Premium', 'sam-buyer@agileventures.org'
  set_cookie "_WebsiteOne_session=#{page.driver.cookies['_WebsiteOne_session'].value};"
  get "#{subscriptions_paypal_redirect_path}?#{paypal.url_params}"
end

And(/^Paypal updates our endpoint incorrectly$/) do
  post subscriptions_path, PAYPAL_REDIRECT_BODY
end

And(/^I should see "([^"]*)" in last_response$/) do |text|
  expect(last_response.body).to include(text)
end

Then(/^I should see a tooltip explanation of Premium$/) do
  xpath_tooltip = "//form/input[@value='Upgrade to Premium' and @title='#{I18n.t('premium.tooltip')}']"
  expect(page).to have_xpath(xpath_tooltip)
end

Then(/^I should see a tooltip explanation of Premium Mob$/) do
  xpath_tooltip = "//form/input[@value='Upgrade to Premium Mob' and @title='#{I18n.t('premium_mob.tooltip')}']"
  expect(page).to have_xpath(xpath_tooltip)
end

And(/^my profile page should reflect that I am a "([^"]*)" member$/) do |plan_name|
  # sleep(1)
  visit user_path @current_user
  expect(page).to have_content "#{plan_name} Member"
  other_plans(plan_name).each do |other_plan_name|
    expect(page).not_to have_content "#{other_plan_name} Member"
  end
end

def other_plans(plan_name)
  Plan.all.pluck(:name).reject! { |e| e == plan_name }.push('Basic')
end

# use for debugging only
And(/^I am a "([^"]*)" Member$/) do |type|
  puts @user.subscriptions.map { |s| s.inspect }
  expect(@user.membership_type).to eq type
end
