@stripe_javascript @javascript
Feature: Subscribe to NonProfit Basic Support
  As a nontechincal admin of a nonprofit or charity
  So that we can maintain our technical offerings
  I would like to subscribe to AV NonProfit Basic Support for charities

  Background:
    Given the following plans exist
      | name                    | id             | amount | free_trial_length_days | category     |
      | NonProfit Basic Support | nonprofitbasic | 2000   | 0                      | organization |

  Scenario: Sign up for nonprofitbasic  support
    Given I exist as a user
    And I visit "subscriptions/new?plan=nonprofitbasic"
    Then I should be on the "sign in" page
    When I sign in with valid credentials
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for nonprofitbasic
    Then I should see "Thanks, your organization has now subscribed to the AgileVentures NonProfit Basic Support Plan"
    And I should see "An AgileVentures specialist will be in touch shortly to help you receive all of your subscription benefits."
    And "random@morerandom.com" should receive a "Welcome to AgileVentures NonProfit Basic Support" email containing "An AgileVentures specialist will be in touch shortly to help you receive all of your subscription benefits."
