@vcr
Feature: Events
  As a site user
  In order to be able to plan activities
  I would like to create events

  Background:
    Given I have logged in
    And the following projects exist:
      | title            | description          | pitch | status   | commit_count |
      | WSO              | greetings earthlings |       | active   | 2795         |
      | EdX              | greetings earthlings |       | active   | 2795         |
      | AAA              | for roadists         |       | active   |              |
      | Inactive Project | Has inactive project |       | inactive |              |
      | Closed Project   | Has closed project   |       | closed   |              |
    And I am on Events index page
    When I click "New Event"
    Given the date is "2014/02/01 09:15:00 UTC"

  Scenario: New event defaults to cs169 project when it exists
    Given the following projects exist:
    |title | description | pitch | status | commit_count|
    |CS169 | stuff       |       | active |  5000       |
    And I am on Events index page
    When I click "New Event"
    Then "cs169" is selected in the event project dropdown

  @javascript
  Scenario: Create a new event
    Given I fill in event field:
      | name        | value          |
      | Name        | Whatever       |
      | Description | something else |
      | Start Date  | 2014-02-04     |
      | Start Time  | 09:00          |
    And I select "EdX" from the event project dropdown
    And I should not see "End Date"
    And I click on the "event_date" div
    And I click the "Save" button
    Then I should see "Event Created"
    Given the event "Whatever"
    Then I should be on the event "Show" page for "Whatever"
    And the event named "Whatever" is associated with "EdX"
#    And I should see "09:00-09:30 (UTC)"
    Then they should see a link to the creator of the event

  @javascript
  Scenario: Create a new event for Associate Members members
    Given I fill in event field:
      | name        | value          |
      | Name        | Whatever       |
      | Description | something else |
      | Start Date  | 2014-02-04     |
      | Start Time  | 09:00          |
    And I select "EdX" from the event project dropdown
    And I select "Associate Members" from the event for dropdown
    And I should not see "End Date"
    And I click on the "event_date" div
    And I click the "Save" button
    Then I should see "Event Created"
    Given the event "Whatever"
    Then I should be on the event "Show" page for "Whatever"
    And the event named "Whatever" is associated with "EdX"
#    And I should see "09:00-09:30 (UTC)"
    Then they should see a link to the creator of the event
    And I should see "for: Associate Members"

  @javascript
  Scenario: Create a new event in a non-UTC timezone
    Given I fill in event field:
      | name        | value          |
      | Name        | Whatever       |
      | Description | something else |
      | Start Date  | 2014-02-04     |
      | Start Time  | 09:00          |
    And I select "Hawaii" from the time zone dropdown
    And I click the "Save" button
    Then I should see "Event Created"
    And I should be on the event "Show" page for "Whatever"
#    And I should see "19:00-19:30 (UTC)"

  Scenario: Projects should be ordered alphabetically
    Then the dropdown with id "event_project_id" should only have active projects
    And I should see "EdX" before "WSO"

  Scenario: Create a new event for a different project
    Given I fill in event field:
      | name        | value          |
      | Name        | Whatever       |
      | Description | something else |
      | Start Date  | 2014-02-04     |
      | Start Time  | 09:00          |
    And I select "WSO" from the event project dropdown
    And I click the "Save" button
    Then I should see "Event Created"
    Then I should be on the event "Show" page for "Whatever"
    And the event named "Whatever" is associated with "WSO"

  @javascript
  Scenario: Creating a repeating event requires an end date
    Given the date is "2014-02-01"
    Given I fill in event field:
      | name        | value         |
      | Name        | Daily Standup |
      | Start Date  | 2014-02-04    |
      | Start Time  | 09:00         |
      | Description | we stand up   |
    And I select "Repeats" to "weekly"
    And I check "Monday"
    And I check "Thursday"
    Then the event is set to end sometime
    And I click the "Save" button
    Then I should see "Repeat ends on can't be blank"
    And I fill in event field:
      | name     | value      |
      | End Date | 2014-03-04 |
    And I click on the "repeat_ends_on" div
    And I click the "Save" button
    Then I should see "Event Created"
    Then I should be on the event "Show" page for "Daily Standup"
    When I dropdown the "Events" menu
    And I click "Upcoming events"
    And I should see multiple "Standup" events

  Scenario: Creating a biweekly event
    Given the date is "2018-03-19"
    Given I fill in event field:
      | name        | value            |
      | Name        | Biweekly Meeting |
      | Start Date  | 2018-03-23       |
      | Start Time  | 09:00            |
      | Description | meet and discuss |
    When I select "Repeats" to "biweekly"
    And I click the "Save" button
    Then I should see "Repeat ends on can't be blank and You must have at least one repeats weekly each days of the week"
    When I check "Monday"
    And I click on the "repeat_ends_on" div
    And I fill in event field:
      | name     | value      |
      | End Date | 2018-05-01 |
    And I click the "Save" button
    Then I should see "Event Created"
    Then I should be on the event "Show" page for "Biweekly Meeting"
    And I should see "Occurs every two weeks at the specified times"
    When I dropdown the "Events" menu
    And I click "Upcoming events"
    Then I should see 3 "Biweekly Meeting" events

  Scenario: Creating a new event without a project association selected defaults to no project
    Given I create an event without a project association
    Then the event is not associated with any project

# dimensions

#     * start date (future, past)
#     * operation (creating, editing)
#     * timezone user is in (one of many - choose representative set)
#     * daylight savings difference between next event and start event (true, false)
#     * repeating event (true, false)
#       * repeated event already terminated
#     * will combination of timezone and date lead to change in date field (true, false)
