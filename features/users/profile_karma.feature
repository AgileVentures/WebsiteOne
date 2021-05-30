@vcr
Feature: Showing Karma summary on profile page
  "As a member of the community
  In order to see my status in the community
  I want to see karma on profile page."

  Background:
    Given the following users exist
      | first_name | last_name | email               | display_profile |
      | Alice      | Jones     | alice@jones.com     | false           |
      | Bob        | Butcher   | bobb112@hotmail.com | true            |
    And user "Bob" have karma:
      | total | hangouts_attended_with_more_than_one_participant |
      | 20    | 20                                               |

  Scenario: Having karma count on users profile page
    Given I am logged in as "Bob"
    And I am on my "Profile" page
    Then the karma summary is "20"

  Scenario: Having karma count as zero on users profile page with zero hangouts_attended_with_more_than_one_participant
    Given I am logged in as "Alice"
    And I am on my "Profile" page
    Then the karma summary is "0"