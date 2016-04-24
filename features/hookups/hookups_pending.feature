@vcr
Feature: Show Pending Hookups
  In order to let other members know which hookups are available
  As a user
  I would like to be able to create pending events

  Background:
    Given I am logged in
    And the date is "2014-07-15 12:00:00 UTC"
    And following events exist:
      | name     | description    | category        | start_datetime          | duration | repeats | time_zone |
      | Hookup 0 | hookup meeting | PairProgramming | 2014/02/03 09:00:00 UTC | 90       | never   | UTC       |
      | Hookup 1 | hookup meeting | PairProgramming | 2015/02/03 07:00:00 UTC | 150      | never   | UTC       |
      | Scrum 0  | hookup meeting | Scrum           | 2015/02/03 07:00:00 UTC | 150      | never   | UTC       |

  Scenario: displaying existing pending events
    When I go to the "Hookups" page
    Then I should see:
      | Hookup 1       |
      | 07:00-09:30    |
      | Create Hangout |
    And I should see "Hookup 1" in table "pending_hookups"

  Scenario: do not display expired events or scrums
    When I go to the "Hookups" page
    Then I should not see "Hookup 0"
    And I should not see "Scrum 0"

  Scenario: Create hangout
    When I go to the "Hookups" page
    And I follow "start" for "pending_hookups" "0"
    Then I should be on the event "show" page for "Hookup 1"