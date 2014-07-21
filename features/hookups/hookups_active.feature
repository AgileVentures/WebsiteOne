Feature: Show Active Hookups
  In order to let other members know which hookups are active and available
  As a user
  I would like to view and manage active events

  Background:
    Given I am logged in
    Given the time now is "2014-02-03 09:15:00 UTC"
    And following events exist with active hangouts:
      | name     | description    | category        | start_datetime          | duration | repeats | time_zone |
      | Hookup 0 | hookup meeting | PairProgramming | 2014/02/03 09:00:00 UTC | 90       | never   | UTC       |
      | Hookup 1 | hookup meeting | PairProgramming | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |
      | Scrum 0  | hookup meeting | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |
    # the events are all active due to attached hangouts, and the "now" time within the start/end range.
    When I go to the "Hookups" page


  Scenario: displaying existing active events
    Then I should see "Active Hookups" before "Hookup 0"
    And I should see "Hookup 0" before "Pending Hookups"
    And I should see "Hookup 1" before "Pending Hookups"

