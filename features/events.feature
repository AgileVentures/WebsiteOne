Feature: Events
  As a site user
  In order to be able to plan activities
  I would like to see event CRUD functionality
  Pivotal Tracker:  https://www.pivotaltracker.com/story/show/66655876

  Background:
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/07 10:00:00 UTC | 15       | never   | UTC       |

  @time-travel-step
  Scenario: Show index of events
    Given the date is "2014/02/01 09:15:00 UTC"
    And I am on Events index page
    Then I should see "AgileVentures Events"
    And I should see "Scrum"
    And I should see "07:00-09:30 (UTC)"
    And I should see "PP Session"
    And I should see "10:00-10:15 (UTC)"

  Scenario: Show index of events with a New Event button for logged in user
    Given I am logged in
    Given I am on Events index page
    Then I should see "AgileVentures Events"
    And I should see link "New Event"

  Scenario: Show an planned event when a user is not logged in
    Given the date is "2014/02/01 09:15:00 UTC"
    And I am on Events index page
    And I click "Scrum"
    Then I should see "Scrum"
    And I should see "Daily scrum meeting"
    And I should see "Next scheduled event"
    And I should see "Monday, February 03, 2014"
    And I should see "07:00-09:30 (UTC)"
    And I should not see "Edit"
    And I should not see "Event Actions"

  Scenario: Show an planned event when a user is logged in
    Given I am logged in
    And the date is "2014/02/01 09:15:00 UTC"
    And I am on Events index page
    And I click "Scrum"
    Then I should see "Scrum"
    And I should see "Daily scrum meeting"
    And I should see "Next scheduled event"
    And I should see "Monday, February 03, 2014"
    And I should see "07:00-09:30 (UTC)"
    And I should see "Edit"


  Scenario: Show info about event in progress
    And the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 7:00:00 UTC         |
    And the time now is "7:01:00 UTC"
    When I am on the show page for event "Scrum"
    Then I should see:
      | Scrum               |
      | Scrum               |
      | Daily scrum meeting |
    And I should see "This event is now live!"
    And I should see link "Join now" with "http://hangout.test"


  Scenario: Render Next Scrum info on landing page
    Given the date is "2014/02/01 09:15:00 UTC"
    And I am on the home page
    Then I should see "Scrum"
    And the next event should be in:
      | period | interval |
      | 1      | day      |
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
      | Start Date  | 2014-02-04     |
      | Start Time  | 09:00          |
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
      | Start Date  | 2014-02-04        |
      | Start Time  | 09:00             |
      | Description | scrum description |
    And I select "Repeats" to "weekly"
    And I check "Monday"
    And I check "Thursday"
    And I click the "Save" button
    Then I should see "Event Created"
    Then I should be on the event "Show" page for "Daily Scrum"
    When I dropdown the "Events" menu
    And I click "Upcoming events"
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

  @javascript
  Scenario: Show events information
    Given the date is "2014/02/03 07:01:00 UTC"
    And the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 07:00:00 UTC        |
    And I am on Events index page
    Then I should see "Scrum"
    And I should see "07:00-09:30 (UTC)"
    And I should see link "Event live! Join now" with "http://hangout.test"
    Then I should see "PP Session"
    And I should see "10:00-10:15 (UTC)"
