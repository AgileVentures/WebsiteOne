@vcr @disable_twitter
Feature: Start Events
  As a site user
  In order to encourage the event's host to start the event at start time
  I would like to see the event be marked as 'Should start' on the site when it's time

  Background:
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |         |                                           |                       |

  Scenario: Shows a message at start time to indicate that the event should be started
    Given an event "Scrum"
    When the time now is "2014/02/03 07:00:09 UTC"
    And I am on the show page for event "Scrum"
    Then I should see "It's time! Please start the event."

  Scenario: Does not show a start event message prior to start time
    Given an event "Scrum"
    When the time now is "2014/02/03 06:59:59 UTC"
    And I am on the show page for event "Scrum"
    Then I should not see "It's time! Please start the event."

  Scenario: In the events page the event has a start now button when it's time
    Given the time now is "2014/02/03 07:00:09 UTC"
    When I am on events index page
    Then I should see "Event time! Start now"

  Scenario: Should not see Event time message and link when the event is live
    Given an event "Scrum"
    And the "Scrum" host has started the event
    When I am on the show page for event "Scrum"
    Then I should not see "It's time! Please start the event."
    When I am on events index page
    Then I should not see "Event time! Start now"
