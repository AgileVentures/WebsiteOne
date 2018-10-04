@stripe_javascript @javascript
Feature: Update credit card from user profile
  As a premium user
  So that I am able to continue accessing/paying for cool premium services
  I would like to be able to update my credit card details when necessary

Background:
  Given the following plans exist
    | name         | id          | amount | free_trial_length_days |
    | Premium      | premium     | 1000   | 7                      |
  And the following users exist
    | first_name | last_name | email                   | latitude | longitude | updated_at    |
    | Alice      | Jones     | alice@btinternet.co.uk  | 59.33    | 18.06     | 1 minute ago  |

Scenario: Premium user decides to change card details
  Given I am logged in as a premium user with name "tansaku", email "tansaku@gmail.com", with password "asdf1234"
  When I click on the avatar for "tansaku"
  Then I should be on the "user profile" page for "tansaku"
  Then I should see "Update Card Details"

Scenario: Basic should not see update card details
  Given I am logged in as "Alice"
  When I click on the avatar for "Alice"
  Then I should be on the "user profile" page for "Alice"
  Then I should not see "Update Card Details"

Scenario: Current premium user can only update their card details

Scenario: Not logged in user cannot see update card details
