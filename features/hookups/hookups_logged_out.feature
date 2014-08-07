Feature: Hookups manager logged out
  In order to let other members know which hookups are available
  As a user (not logged in)
  I would like to be able to view events but not manage or create them. (join?)

  Background:
    Given following events exist:
      | name     | description    | category        | start_datetime          | duration | repeats | time_zone |
      | Hookup 0 | hookup meeting | PairProgramming | 2014/02/03 09:00:00 UTC | 90       | never   | UTC       |
      | Hookup 1 | hookup meeting | PairProgramming | 2015/02/03 07:00:00 UTC | 150      | never   | UTC       |
      | Scrum 0  | hookup meeting | Scrum           | 2015/02/03 07:00:00 UTC | 150      | never   | UTC       |
    When I go to the "Hookups" page

  Scenario: adding a new pending event when not logged in
    Given I am on the "Hookups" page
    Then I should not see button "New Hookup"
