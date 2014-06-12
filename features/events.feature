@time-travel
Feature: Events
  As a site user
  In order to be able to plan activities
  I would like to see event CRUD functionality
  Pivotal Tracker:  https://www.pivotaltracker.com/story/show/66655876

  Background:
    Given following events exist:
      | name       | description             | category        | event_date | start_time              | end_time                | repeats | time_zone                  |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 | 2000-01-01 07:00:00 UTC | 2000-01-01 09:30:00 UTC | never   | UTC                  |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/07 | 2000-01-01 10:00:00 UTC | 2000-01-01 10:15:00 UTC | never   | UTC |

  @time-travel-step
  Scenario: Show index of events
    Given I am on Events index page
    And the date is "2014/02/01 09:15:00 UTC"
    Then I should see "AgileVentures Events"
    And I should see "Scrum"
    And I should see "PP Session"
    #And I should see "GMT"
    #And I should see "EDT"

  Scenario: Show index of events with a New Event button for logged in user
    Given I am logged in
    Given I am on Events index page
    Then I should see "AgileVentures Events"
    And I should see link "New Event"

  Scenario: Show an event when a user is not logged in
    Given I am on Events index page
    And I click "Scrum"
    Then I should see "Scrum"
    And I should see "Daily scrum meeting"
    And I should see "Upcoming schedule"
    And I should see "2014-02-03 at 07:00AM"
    And I should not see "Edit"
    And I should not see "Add url"
    And I should see "Back"

  Scenario: Show an event when a user is logged in
    Given I am logged in
    And I am on Events index page
    And I click "Scrum"
    Then I should see "Scrum"
    And I should see "Daily scrum meeting"
    And I should see "Upcoming schedule"
    And I should see "2014-02-03 at 07:00AM"
    And I should see "Edit"
    And I should see "Add url"
    And I should see "Back"

  Scenario: Update url if valid
    Given I am logged in
    Given I am on the show page for event "Scrum"
    And I click "Add url" button
    And I fill in "Url" with "http://google.com"
    And I click "Save" button
    Then I should be on the event "Show" page for "Scrum"
    And I should see "Event URL has been updated"

  Scenario: Reject url update if invalid
    Given I am logged in
    Given I am on the show page for event "Scrum"
    And I click "Add url" button
    And I fill in "Url" with "http:/google.com"
    And I click "Save" button
    Then I should be on the event "Show" page for "Scrum"
    And I should see "You have to provide a valid hangout url"

  Scenario: Render Next Scrum info on landing page
    And I am on the home page
    Then I should see "Scrum"
    And the next event should be in:
      | period | interval |
      | 1      | day     |
      | 21     | hours    |
      | 45     | minutes  |

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
    Then I should be on the event "Show" page for "Whatever"

  Scenario: Creating a repeating event
    Given I am logged in
    And I am on Events index page
    When I click "New Event"
    And I fill in event field:
      | name        | value             |
      | Name        | Daily Scrum       |
      | Event date  | 2014-02-04        |
      | Description | scrum description |
    And I select "Repeats" to "weekly"
    And I check "Monday"
    And I check "Thursday"
    And I click the "Save" button
    Then I should see "Event Created"
    Then I should be on the event "Show" page for "Daily Scrum"
    When I click "Events" within the navigation bar
    And I should see multiple "Scrum" events

  Scenario: Don't save with empty name
    Given I am logged in
    And I am on Events index page
    When I click "New Event"
    And I fill in event field:
      | name        | value             |
      | Name        |                   |
      | Description | scrum description |
    And I select "Repeats" to "weekly"
    And I check "Monday"
    And I check "Thursday"
    And I click the "Save" button
    Then I should be on the Events "Create" page
    And I should see "Name can't be blank"
