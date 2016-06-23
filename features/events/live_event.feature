@vcr
Feature: Live Events
  As a site user
  In order to be able participate in an event with others
  I would like to see when an event is live

  Background:
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |         |                                           |                       |

  Scenario: Show event is live when event is started a minute previously
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

  Scenario: Show event is live when event hangout is still active
    And the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 7:00:00 UTC         |
      | Updated at         | 7:08:30 UTC         |
    And the time now is "7:10:00 UTC"
    When I am on the show page for event "Scrum"
    Then I should see:
      | Scrum               |
      | Scrum               |
      | Daily scrum meeting |
    And I should see "This event is now live!"
    And I should see link "Join now" with "http://hangout.test"

  Scenario: Show event is not live when event hangout is has died
    And the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 7:00:00 UTC         |
      | Updated at         | 7:07:30 UTC         |
    And the time now is "7:10:00 UTC"
    When I am on the show page for event "Scrum"
    Then I should see:
      | Scrum               |
      | Scrum               |
      | Daily scrum meeting |
    And I should not see "This event is now live!"

  Scenario: Show event shows as live after event hangout has gone live, and received ping from Connect app
    And the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 7:00:00 UTC         |
      | Updated at         | 7:00:00 UTC         |
      | user_id            | 15                  |
    And the time now is "7:03:00 UTC"
    And the connect app ping WSO concerning the event named "Scrum"
    When I am on the show page for event "Scrum"
    And I should see "This event is now live!"


    # before hangout is running
    # should not see the live link, join now etc

    # hangout is running and broadcasting is terminated
    # should not see the live link

    # hangout was running/broadcasting, but failed to update
    # should not see the live link