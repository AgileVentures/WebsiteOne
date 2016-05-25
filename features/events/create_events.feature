@vcr
Feature: Events
  As a site user
  In order to be able to plan activities
  I would like to create events

  Background:
    Given I am logged in
    And the following projects exist:
      | title | description          | pitch | status | commit_count |
      | WSO   | greetings earthlings |       | active | 2795         |
      | EdX   | greetings earthlings |       | active | 2795         |
    And I am on Events index page
    When I click "New Event"

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
    Then I should be on the event "Show" page for "Whatever"
    And the event named "Whatever" is associated with "EdX"

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
    And I should see "19:00-19:30 (UTC)"

  Scenario: Projects should be ordered alphabetically
    Then I should see "EdX" before "WSO"

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