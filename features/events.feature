Feature: Events

  Background:
    Given following events exist:
      | name           | description             | category        | event_date | start_time              | end_time                | repeats | time_zone                  |
      | EuroAsia Scrum | Daily scrum meeting     | Scrum           | 2014/02/03 | 2000-01-01 07:00:00 UTC | 2000-01-01 09:30:00 UTC | never   | London                     |
      | PP Session     | Pair programming on WSO | PairProgramming | 2014/02/11 | 2000-01-01 10:00:00 UTC | 2000-01-01 10:15:00 UTC | never   | Eastern Time (US & Canada) |

  Scenario: Show index of events
    Given I am on Events index page
    Then I should see "AgileVentures Events"

  Scenario: Show index of events with a New Event button for logged in user
    Given I am logged in
    Given I am on Events index page
    Then I should see "AgileVentures Events"
    And I should see link "New Event"


  Scenario: Render Next Scrum info on landing page
    And I am on the home page
    Then I should see "Scrum"
    And the next event should be in:
      | period | interval |
      | 1      | days     |
      | 21     | hours    |
      | 45     | minutes  |

  @javascript @selenium
  Scenario: Create a new event
    Given I am logged in
    And I am on Events index page
    When I click "New Event"
    And I fill in event field:
      | name        | value          |
      | Name        | Whatever       |
      | Description | something else |
    And I click the "Save" button
    Then I should see "Event Created"
    Then I should be on the Events index page

  @javascript @selenium
  Scenario: Creating a repeating event
    Given I am logged in
    And I am on Events index page
    When I click "New Event"
    And I fill in event field:
      | name        | value             |
      | Name        | Scrum             |
      | Description | scrum description |
    And I select "Repeats" to "weekly"
    And I check "Monday"
    And I check "Thursday"
    And I click the "Save" button
    Then I should see "Event Created"
    Then I should be on the Events index page
    Then I should see multiple "Scrum" events

  @javascript @selenium
  Scenario: Don't save with empty name
    Given I am logged in
    And I am on Events index page
    When I click "New Event"
    And I fill in event field:
      | name        | value             |
      | Name        |              |
      | Description | scrum description |
    And I select "Repeats" to "weekly"
    And I check "Monday"
    And I check "Thursday"
    And I click the "Save" button
    Then I should see "Name can't be blank"


    #Name can't be blank