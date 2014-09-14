Feature: Display Public Activity
  As a user
  In order to get a better overview of what is going on
  I would like to see latest activities in projects that I participate in presented as a activity feed

  As a site visitor
  In order to get a clearer picture of what is going on in all AgileVenture projects
  I would like to see an activity feed

  Background:
    Given the following articles exist:
      | Title                    | Content                          | Tag List           |
      | Ruby is on Fire          | Fire is fire and sunny           | Ruby, Rails        |

    Given I am logged in
    And I edit article "Ruby is on Fire"

  Scenario: Navigate to activity feed
    Given I am on the "Dashboard" page
    And I click the "Activity feed" link
    Then I should see "activity-feed" tab is active
    And I should see a activity feed
