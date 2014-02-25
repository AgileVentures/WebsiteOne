Feature: Events

  Background:
    Given following events exist:
      | name       | description             | from_date  | to_date    | is_all_day |
      | Scrum      | Daily scrum meeting     | 2014/02/01 | 2014/02/01 | false      |
      | PP Session | Pair programming on WSO | 2014/02/11 | 2014/02/11 | false      |

  Scenario: Show index of events
    Given I am on Events index page
    Then I should see "Events"

