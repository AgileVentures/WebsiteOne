Feature: Events

  Background:
    Given following events exist:
      | name       | description             | category        | from_date  | to_date    | is_all_day | from_time               | to_time                 | repeats | time_zone                  |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/01 | 2014/02/01 | false      | 2000-01-01 09:15:00 UTC | 2000-01-01 09:30:00 UTC | never   | Eastern Time (US & Canada) |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/11 | 2014/02/11 | false      | 2000-01-01 10:00:00 UTC | 2000-01-01 10:15:00 UTC | never   | Eastern Time (US & Canada) |

  Scenario: Show index of events
    Given I am on Events index page
    Then show me the page
    Then I should see "AgileVentures Events"
    And I should se buttons:
      | All              |
      | Scrum            |
      | Pair Programming |



