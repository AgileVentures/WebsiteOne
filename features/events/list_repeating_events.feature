@vcr
Feature: List Repeating Events
  As an event creator
  So that I don't have to keep making separate events for repeating meetings
  I would like everyone to see repeats of regular events

  Background:
    Given the following events exist that repeat every weekday:
      | name    | description     | category | start_datetime          | duration | time_zone |
      | Standup | always<br>woot! | Scrum    | 2014/02/03 07:00:00 UTC | 150      | UTC       |

  Scenario: Show correct timezone for repeating event
    Given the date is "2016/05/01 09:15:00 UTC"
    When I am on events index page
    Then I should see "Standup"
    And I should see "woot!"
    And the local time element should be set to "2016-05-10T07:00:00Z"
    And I should not see any HTML tags
