Feature: User status
  As site administrator
  In order to simplify interactions between users
  I would like them to be able to set current availability status on their user profile.

  PT story: https://www.pivotaltracker.com/story/show/78088070

  Background:
    Given the following users exist
      | first_name | last_name | email                  |
      | Alice      | Jones     | alicejones@hotmail.com |
      | Bob        | Butcher   | bobb112@hotmail.com    |
    And the following statuses have been set
      | status         | user   |
      | I want to pair | Alice  |
      | I'm offline    | Bob    |

    Scenario: I should see a users status on his profile page
      Given I visit Bob's profile page
      Then I should see "I'm offline"
      Given I visit Alice's profile page
      Then I should see "I want to pair"
