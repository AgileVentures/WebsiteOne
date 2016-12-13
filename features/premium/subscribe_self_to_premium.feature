@stripe_javascript @javascript
Feature: Subscribe Self to Premium
  As a developer
  So that I can get recurring professsional development support and code review
  I would like to take out an AV Premium Subscription

  Background:
    Given the following plans exist
      | name        | id          |
      | Premium     | premium     |

  Scenario: Pay by card
    Given I visit "subscriptions/new"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "Thanks, you're now an AgileVentures Premium Member!"
    And the user should receive a "Welcome to AgileVentures Premium" email

    # And my member page should show premium details # TODO IMPORTANT - require login?

  Scenario: Pay by Paypal
    Given I visit "subscriptions/new"
    Then I should see a paypal form within the paypal_section
    When Paypal updates our endpoint
    Then the user should receive a "Welcome to AgileVentures Premium" email
    And I should see "Thanks, you're now an AgileVentures Premium Member!" in last_response

    # And my member page should show premium details # TODO IMPORTANT - will need hookup