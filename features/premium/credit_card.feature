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

  Scenario: User decides to change card details
    Given I am logged in as a premium user with name "tansaku", email "tansaku@gmail.com", with password "asdf1234"
    And I visit "cards/tansaku/edit"
    And I click "Update Card Details"
    When I fill in updated card details for premium for user with email "tansaku+stripe@gmail.com"
    Then I should see "Your card details have been successfully updated"

  Scenario: User changes card details, but encounters error
    Given I am logged in as user with name "tansaku", email "tansaku@gmail.com", with password "asdf1234"
    And I visit "cards/tansaku/edit"
    And I click "Update Card Details"
    When I fill in updated card details for premium for user with email "tansaku+stripe@gmail.com"
    Then I should not see "Your card details have been successfully updated"
    And I should see "something has gone wrong with changing your card details."

  Scenario: User cannot change card details if not logged in
    Given I visit "cards/tansaku/edit"
    Then I should be on the "sign in" page

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

