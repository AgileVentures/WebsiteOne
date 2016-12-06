@vcr
Feature: Tweeting Live Events
  As a site admin
  In order to increase participation in events
  I would like live events to generate twitter notifications

  Background:
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |         | And an event "Scrum"                      |                       |
    And an event "Scrum"

  Scenario: Event going live causes tweet of hangout link to be sent
    When the HangoutConnection has pinged to indicate the event start, an appropriate tweet will be sent

  Scenario: Event stream going live causes tweet of the youtube stream to be sent
    Given that the HangoutConnection has pinged to indicate the event start
    And youtube stream has gone live
    Then an appropriate tweet has been sent # e.g. see live stream