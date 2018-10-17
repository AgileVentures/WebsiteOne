Feature: Allow payment of Premium with crypto
  As a site user
  I would like to be able to pay for my subscription with crypto currency
  So that users can pay for premium services

  Scenario: User sees an option to pay with crypto on the new subscriptions page
  When I sign in with valid credentials
  When I go to the new subscriptions page
  Then I should see text "Get Premium with crypto currency"


  