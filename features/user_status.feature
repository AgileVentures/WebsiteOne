@vcr
Feature: User status
  "As site administrator
  In order to simplify interactions between users
  I would like them to be able to set current availability status on their user profile."

  PT story: https://www.pivotaltracker.com/story/show/78088070

  Background:
    Given the following users exist
      | first_name | last_name | email                  | updated_at               |
      | Alice      | Jones     | alicejones@hotmail.com | 2014-09-30 05:09:00 UTC' |
      | Bob        | Butcher   | bobb112@hotmail.com    | 2014-09-30 04:00:00 UTC' |

    And the following statuses have been set
      | status            | user  |
      | Ready to pair     | Alice |
      | Doing code review | Bob   |

  @time-travel-step
  Scenario: I should see a users status on index page if user is online
    Given the date is "2014-09-30 05:15:00 UTC"
    And I visit "/users"
    And I should see "2" user avatars within the main content
    And I should see "Ready to pair"
    And I should not see "I'm offline"

  @time-travel-step
  Scenario: I should see a users status on their profile page if user is online
    Given the date is "2014-09-30 05:15:00 UTC"
    Given I visit Alice's profile page
    Then I should see "Ready to pair"

  @time-travel-step
  Scenario: I should not see a users status on their profile page if user is offline
    Given the date is "2014-09-30 05:15:00 UTC"
    And I visit Bob's profile page
    Then I should not see "I'm offline"

  @javascript
  Scenario: Set status
    Given I am logged in as user with name "Thomas", email "thomas@agileventures.org", with password "qwerty1234"
    And I am on my "Profile" page
    And I click "Set status"
    And I select "user_status" to "Ready to pair"
    And I click "Update status"
    Then I should see "Ready to pair"
