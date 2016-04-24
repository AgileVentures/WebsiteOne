@vcr
Feature: User bio
  As a site user
  In order to get to know other users better
  I would like to see a short bio of a user on his profile page

  Background:
    Given the following users exist
      | first_name | last_name | email                   | bio                                        |
      | Alice      | Jones     | alicejones@hotmail.com  | Lives on a farm with many sheep and goats. |
      | Bob        | Butcher   | bobb112@hotmail.com     |                                            |

  Scenario: View user's bio details
    When I visit Alice's profile page
    Then I should see "Lives on a farm with many sheep and goats."

  @javascript
  Scenario: Add bio content to profile
    Given I am logged in
    And I am on "profile" page for user "me"
    And I click the "Edit" button
    And I fill in "Bio" with "Lives on a farm with many sheep and goats"
    And I click "Update"
    Then I should see "Lives on a farm with many sheep and goats"