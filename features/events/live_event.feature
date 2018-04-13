@vcr @disable_twitter
Feature: Live Events
  As a site user
  In order to be able participate in an event with others
  I would like to see when an event is live

  Background:
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |         |                                           |                       |

  Scenario: Event is seen to be live when event is started a minute previously
    Given an event "Scrum"
    And the HangoutConnection has pinged to indicate the event start
    Then the event should be live
    And after one minute
    Then the event should still be live

  Scenario: Ongoing ping from HangoutConnection app keeps event alive
    Given an event "Scrum"
    And the HangoutConnection has pinged to indicate the event start
    Then the event should be live
    And after three minutes
    When the HangoutConnection pings to indicate the event is ongoing
    Then the event should still be live
    And after three more minutes
    When the HangoutConnection pings to indicate the event is ongoing
    Then the event should still be live

  Scenario: Lack of ping from HangoutConnection after two minutes kills events
    Given an event "Scrum"
    And the HangoutConnection has pinged to indicate the event start
    Then the event should be live
    And after three minutes
    Then the event should be dead
    
  Scenario: Shows a message at start time to indicate that the event should be started
    Given an event "Scrum"
    When the time now is "2014/02/03 07:00:09 UTC"
    And I am on the show page for event "Scrum"
    Then I should see "It's time! Please start the event."

  Scenario: In the events page the event has a start now button when it's time
    Given the time now is "2014/02/03 07:00:09 UTC"
    When I am on events index page
    Then I should see "Event time! Start now"

  Scenario: Start Now button redirects to hangout instructions
    Given the time now is "2014/02/03 07:00:09 UTC"
    And I am on events index page
    Then I should see a link "Event time! Start now" to "https://support.google.com/youtube/answer/7083786"

  Scenario: Should not see Event time message and link when the event is live
    Given an event "Scrum"
    And the HangoutConnection has pinged to indicate the event start
    When I am on events index page
    Then I should not see "It's time! Please start the event."
    When I am on events index page
    Then I should not see "Event time! Start now"
