@vcr
Feature: List Events
  As a site user
  So I can find events relevant to me
  I would like to see a list of events linked to a given project

  Background:
    Given the following projects exist:
      | title | description          | pitch | status |
      | cs169 | greetings earthlings |       | active |
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project |
      | Standup    | Daily standup meeting   | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |         |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/07 10:00:00 UTC | 15       | never   | UTC       | cs169   |
    Given the date is "2014/02/01 09:15:00 UTC"

  Scenario: Show index of events
    And I am on Events index page
    Then I should see "AgileVentures Events"
    And I should see "Standup"
    And I should see "07:00-09:30 (UTC)"
    And I should see "PP Session"
    And I should see "10:00-10:15 (UTC)"

  Scenario: Show events associated with cs169
    And I am on the project events index page
    Then I should not see "Standup"
    And I should see "PP Session"

  Scenario: Choose which project events to display
    And I am on events index page
    And I select "cs169" from the project dropdown
    Then I should not see "Standup"
    And I should see "PP Session"