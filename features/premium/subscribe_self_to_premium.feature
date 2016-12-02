Feature: Subscribe Self to Premium
  As a developer
  So that I can get recurring professsional development support and code review
  I would like to take out an AV Premium Subscription

  Scenario: Pay by card
    Given I visit "subscriptions/new"
    And I click "subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "Thanks, you're now an AgileVentures Premium Member!"
    And the user should receive a "Welcome to AgileVentures Premium" email
    And my member page should show premium details

  Scenario: Pay by Paypal
    Given I visit "subscriptions/new"
    And I click "subscribe" within the paypal_section
    Then I should be redirected to Paypal's payment screens
    And the user should receive a "Welcome to AgileVentures Premium" email
    And my member page should show premium details