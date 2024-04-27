@vcr
Feature: List Events by Project
  As a site user
  So I can find events relevant to me
  I would like to see a list of events linked to a given project

  Background:
    Given the following projects exist:
      | title      | description          | pitch | status    |
      | wso        | blah                 |       | active    |
      | auto       | blah                 |       | active    |
      | cs169      | greetings earthlings |       | active    |
      | project x  | great movie project  |       | inactive  |
      | mega main  | great movie project  |       | closed    |
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project |
      | Standup1   | Daily standup meeting   | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |         |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/07 10:00:00 UTC | 15       | never   | UTC       | cs169   |
    Given the date is "2014/02/01 09:15:00 UTC"


  Scenario: Show index of events
    Given I am on Events index page
    Then "All" is selected in the project dropdown
    And I select "All" from the project dropdown
    And I click "Filter by Project" button
    Then I should see "AgileVentures Events"
    And I should see "Standup"
    And I should see "07:00-09:30 (UTC)"
    And I should see "PP Session"
    And I should see "10:00-10:15 (UTC)"
    And the short local date element should be set to "2014-02-03T07:00:00Z"
    And the local time element should be set to "2014-02-03T07:00:00Z"
    And the short local date element should be set to "2014-02-07T10:00:00Z"
    And the local time element should be set to "2014-02-07T10:00:00Z"

  Scenario: Projects should be ordered alphabetically
    Given I am on Events index page
    Then I should see "cs169" before "WSO"

  Scenario: Show events associated with cs169
    And I am on the project events index page
    Then I should not see "Standup1"
    And I should see "PP Session"

  Scenario: Choose which project events to display
    Given I am on Events index page
    And I select "cs169" from the project dropdown
    And I click "Filter by Project" button
    Then I should not see "Standup1"
    And I should see "PP Session"
    And "cs169" is selected in the project dropdown

  Scenario: projects dropdown should only have active projects
    Given I am on the events index page
    Then the dropdown with id "project_id" should only have active projects

# @javascript
#   Scenario: Project drop-down resets on hit back
#     Given I am on the home page
#     When I dropdown the "Events" menu
#     And I click "Upcoming events"
#     And I select "cs169" from the project dropdown
#     And I click "Filter by Project" button
#     Then I should see "Standup1"
#     And I hit back
#     Then "All" is selected in the project dropdown
#     And I should see "PP Session"

