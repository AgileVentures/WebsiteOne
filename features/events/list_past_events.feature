Feature: List the recent Event Instances on the corresponding Events page
  As a user
  In order to identify repeating events that are still active
  I would like to see a list of the most recents events

  Background:
    Given following events exist:
      | name       | id | description             | category        | start_datetime          | created_at                         | duration | repeats  | time_zone | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Bob's mob  | 3  | All things Bob          | Scrum           | 2018/01/12 17:00:00 UTC | 2018-01-06 17:00:00 +0000          | 30       | weekly   | UTC       | 16                                        | 1                     |

  Scenario: Event show page lists at most five events
    Given 6 event instances exist
    When a user views the event "Bob's mob"
    Then they should see 5 event instances

  Scenario: Event show page lists the most recent events
    Given 3 event instances exist
    When a user views the event "Bob's mob"
    Then they should see 3 event instances

  Scenario: Event show's relevant information
    Given 1 event instance exists
    When a user views the event "Bob's mob"
    Then they should see all information for the instance "Bob's mob"

  Scenario: Event show page displays a message when there are no associated event instances
    Given 0 event instances exist
    When a user views the event "Bob's mob"
    Then they should see a message stating: "No previous instances of this event"

  Scenario: Event instances without youtube id's are not shown
    Given 2 event instances exist
    And 1 event instance exists without a youtube id
    When a user views the event "Bob's mob"
    Then they should see 2 event instances

  Scenario: Event instances are listed in order
    Given 3 event instances exist
    When a user views the event "Bob's mob"
    Then they should see the most 3 recent events first
