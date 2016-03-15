Feature: Events
  As a site user
  In order to be able to plan activities
  I would like to create events

  Background:
    Given I am logged in
    And I am on Events index page
    When I click "New Event"

  Scenario: Create a new event
    Given I fill in event field:
      | name        | value          |
      | Name        | Whatever       |
      | Description | something else |
      | Start Date  | 2014-02-04     |
      | Start Time  | 09:00          |
    And I click the "Save" button
    Then I should see "Event Created"
    Then I should be on the event "Show" page for "Whatever"

  @javascript
  Scenario: Creating a repeating event requires an end date
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
