@stripe_javascript @javascript
Feature: Allow Admin to Downgrade Membership
  As a site admin
  So that I can keep records up to date
  I would like to be able to downgrade users premium plans

  Background:
    Given I am logged in as a privileged user
    And the following plans exist
      | name                       | id                          | amount | free_trial_length_days |
      | Premium                    | premium                     | 1000   | 7                      |
      | Basic                      | basic                       | 0      | 0                      |

    And the following premium users exist
      | first_name | last_name | email                | github_profile_url         | last_sign_in_ip |
      | Billy      | Bob       | bob@btinternet.co.uk | http://github.com/BillyBob | 127.0.0.1       |

  Scenario: find member and downgrade them
    When I search for user with email "bob@btinternet.co.uk"
    # And I debug
    And I click the first instance of "Billy Bob"
    When I select "Plan" to "Basic"
    And I click "Adjust Level"
    Then I should not see "Premium Member"
    # And their subscription should be ended # would be nice to check API correct ...?