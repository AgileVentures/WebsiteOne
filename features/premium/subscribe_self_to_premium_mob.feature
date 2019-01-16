@stripe_javascript @javascript
Feature: Subscribe Self to Premium
  As a developer
  So that I can get recurring professsional development support and code review
  I would like to take out an AV Premium Subscription

  Background:
    Given the following plans exist
      | name        | id         | amount | free_trial_length_days |
      | Premium Mob | premiummob | 2500   | 0                      |
    And the email queue is clear

  Scenario: Pay by card
    Given I have logged in
    And I visit "subscriptions/new?plan=premiummob"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium mob
    Then I should see "Thanks, you're now an AgileVentures Premium Mob Member!"
    And "random@morerandom.com" should receive a "Welcome to AgileVentures Premium Mob" email

    # And my member page should show premium details # TODO IMPORTANT - require login?

  Scenario: Pay by PayPal
    Given I have logged in
    And I visit "subscriptions/new?plan=premiummob"
    Then I should see a paypal form within the paypal_section
    When Paypal updates our endpoint for premium mob
    Then "sam-buyer@agileventures.org" should receive a "Welcome to AgileVentures Premium Mob" email
    And I should see "Thanks, you're now an AgileVentures Premium Mob Member!" in last_response

    # And my member page should show premium details # TODO IMPORTANT - will need hookup

  Scenario: Pay by card, but encounter error
    Given I have logged in
    And my card will be rejected
    And I visit "/subscriptions/new?plan=premiummob"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium mob
    Then I should not see "Thanks, you're now an AgileVentures Premium Mob Member!"
    And I should see "The card was declined"
    And "random@morerandom.com" should not receive a "Welcome to AgileVentures Premium Mob" email

  Scenario: Pay by PayPal, but encounter error
    Given I have logged in
    And I visit "subscriptions/new?plan=premiummob"
    Then I should see a paypal form within the paypal_section
    When Paypal updates our endpoint incorrectly
    Then "sam-buyer@agileventures.org" should not receive a "Welcome to AgileVentures Premium Mob" email
    And I should see "redirected" in last_response

  Scenario: Pay by Paypal, when PayPals POST redirect doesn't work
    Given I have logged in
    And I visit "subscriptions/new?plan=premiummob"
    Then I should see a paypal form within the paypal_section
    # a tighter test would grab the return URL from the form
    When Paypal updates our endpoint for premium mob via get
    Then "sam-buyer@agileventures.org" should receive a "Welcome to AgileVentures Premium Mob" email
    And I should see "Thanks, you're now an AgileVentures Premium Mob Member!" in last_response
    
