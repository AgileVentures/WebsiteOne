@stripe_javascript @javascript
Feature: Subscribe to NonProfit Basic Support
  As a nontechincal admin of a nonprofit or charity
  So that we can maintain our technical offerings
  I would like to subscribe to AV NonProfit Basic Support for charities

  Background:
    Given the following plans exist
      | name                    | id             |
      | NonProfit Basic Support | nonprofitbasic |

  Scenario: Sign up for nonprofitbasic  support
    Given I visit "subscriptions/new?plan=nonprofitbasic"
    And I click "Sign Me Up For NonProfit Basic Support!"
    When I fill in appropriate card details for nonprofitbasic
    Then I should see "Thanks, you're now an AgileVentures NonProfit Basic Support Member!"
