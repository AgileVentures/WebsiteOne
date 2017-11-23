@stripe_javascript @javascript
Feature: Subscribe Self to Premium
  As a developer
  So that I can get recurring professsional development support and code review
  I would like to take out an AV Premium Subscription

  Background:
    Given the following plans exist
      | name                       | id                          | amount | free_trial_length_days |
      | Premium                    | premium                     | 1000   | 7                      |
      | Premium (first month free) | av_premium_first_month_free | 1000   | 31                     |
    And the email queue is clear

  Scenario: Pay by card
    Given I visit "subscriptions/new"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "Thanks, you're now an AgileVentures Premium Member!"
    And I should see "Your 7 day free trial has now started"
    And "random@morerandom.com" should receive a "Welcome to AgileVentures Premium" email

  Scenario: Logged in user has sponsor set to self
    Given I am logged in
    And I visit "subscriptions/new"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "Thanks, you're now an AgileVentures Premium Member!"
    And I should see "Your 7 day free trial has now started"
    And "random@morerandom.com" should receive a "Welcome to AgileVentures Premium" email
    And I should be my own sponsor

  Scenario: Pay by card (with free trial month)
    Given I visit "subscriptions/new?plan=av_premium_first_month_free"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "Thanks, you're now an AgileVentures Premium (first month free) Member!"
    And I should see "Your 31 day free trial has now started"
    And "random@morerandom.com" should receive a "Welcome to AgileVentures Premium" email

    # And my member page should show premium details # TODO IMPORTANT - require login?

  Scenario: Pay by PayPal
    Given I visit "subscriptions/new"
    Then I should see a paypal form within the paypal_section
    When Paypal updates our endpoint
    Then "sam-buyer@agileventures.org" should receive a "Welcome to AgileVentures Premium" email
    And I should see "Thanks, you're now an AgileVentures Premium Member!" in last_response

    # And my member page should show premium details # TODO IMPORTANT - will need hookup

  Scenario: Pay by card, but encounter error
    Given my card will be rejected
    And I visit "/subscriptions/new"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should not see "Thanks, you're now an AgileVentures Premium Member!"
    And I should see "The card was declined"
    And "random@morerandom.com" should not receive a "Welcome to AgileVentures Premium" email

  Scenario: Pay by PayPal, but encounter error
    Given I visit "subscriptions/new"
    Then I should see a paypal form within the paypal_section
    When Paypal updates our endpoint incorrectly
    Then "sam-buyer@agileventures.org" should not receive a "Welcome to AgileVentures Premium" email
    And I should see "redirected" in last_response

  Scenario: Pay by card, and default to Premium
    Given I visit "subscriptions/new?plan=76a5uydstjg"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "Thanks, you're now an AgileVentures Premium Member!"
    And "random@morerandom.com" should receive a "Welcome to AgileVentures Premium" email
