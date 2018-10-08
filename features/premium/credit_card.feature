@stripe_javascript @javascript
Feature: Charge Users Money
  As a site admin
  So that users can continue to pay for premium services
  I would like them to be able to change their card details when necessary

  Background:
    Given the following plans exist
      | name         | id          | amount | free_trial_length_days |
      | Premium      | premium     | 1000   | 7                      |
    And the following users exist
      | first_name | last_name | email                   | latitude | longitude | updated_at    |
      | Alice      | Jones     | alice@btinternet.co.uk  | 59.33    | 18.06     | 1 minute ago  |

  Scenario: User without existing card wants to add one
    Given I am logged in as "Alice"
    And I visit "cards/new"
    And I click "Add Card Details"
    When I fill in new card details for premium for user with email "alice@btinternet.co.uk"
    Then I should see "Your card details have been successfully added"

  Scenario: User without existing card wants to add one but encounters an error
    Given I am logged in as "Alice"
    And I visit "cards/new"
    And I click "Add Card Details"
    When I fill in card details for premium for user that will fail with email "tansaku+stripecardtest2@gmail.com"
    Then I should not see "Your card details have been successfully updated"
    And I should see "something has gone wrong with adding your card details."
