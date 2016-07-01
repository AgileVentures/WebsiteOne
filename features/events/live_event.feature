@vcr
Feature: Live Events
  As a site user
  In order to be able participate in an event with others
  I would like to see when an event is live

  Background:
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |         |                                           |                       |

  Scenario: Event is seem to be live when event is started a minute previously
    Given an event "Scrum"
    And that the HangoutConnection has pinged to indicate the event start
    Then the event should be live
    And after one minute
    Then the event should still be live

  Scenario: Ongoing ping from HangoutConnection app keeps event alive
    Given an event "Scrum"
    And that the HangoutConnection has pinged to indicate the event start
    Then the event should be live
    And after three minutes
    When the HangoutConnection pings to indicate the event is ongoing
    Then the event should still be live
    And after three more minutes
    When the HangoutConnection pings to indicate the event is ongoing
    Then the event should still be live

  Scenario: Lack of ping from HangoutConnection after two minutes kills events
    Given an event "Scrum"
    And that the HangoutConnection has pinged to indicate the event start
    Then the event should be live
    And after three minutes
    Then the event should be dead