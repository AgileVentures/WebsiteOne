# @javascript
# @stripe_javascript
# Feature: Update credit card from user profile
#   "As a premium user
#   So that I am able to continue accessing/paying for cool premium services
#   I would like to be able to update my credit card details directly from my profile page when necessary"

#   Background:
#     Given the following plans exist
#       | name    | id      | amount | free_trial_length_days |
#       | Premium | premium | 1000   | 7                      |
#     And the following users exist
#       | first_name | last_name | email          | latitude | longitude | updated_at   |
#       | Alice      | Jones     | alica@mail.com | 59.33    | 18.06     | 1 minute ago |

#   @stripe_javascript
#   Scenario: User decides to change card details
#     Given I am logged in as a premium user with name "user", email "user@mail.com", with password "asdf1234"
#     When I click on the avatar for "user"
#     Then I should be on the "user profile" page for "user"
#     When I click "Update Card Details"
#     And I fill in updated card details for premium for user with email "user+stripe@gmail.com"
#     Then I should see "Your card details have been successfully updated"

#   Scenario: Basic user should not see update card details
#     Given I am logged in as "Alice"
#     When I click on the avatar for "Alice"
#     Then I should be on the "user profile" page for "Alice"
#     Then I should not see "Update Card Details"

#   Scenario: Premium profile owners can only see update card details on their profiles
#     Given I am logged in as a premium user with name "user", email "user@mail.com", with password "asdf1234"
#     And A premium user with name "Emily Smith", email "emily@gmail.com", with password "asdf1234" exists
#     When I visit the profile page for "Emily"
#     Then I should be on the "user profile" page for "Emily"
#     Then I should not see "Update Card Details"

#   Scenario: Not logged in user cannot see update card details
#     Given A premium user with name "Emily Smith", email "emily@gmail.com", with password "asdf1234" exists
#     When I visit the profile page for "Emily"
#     Then I should not see "Update Card Details"
