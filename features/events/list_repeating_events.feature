@vcr
Feature: List Events
  As a site user
  So I can find events relevant to me
  I would like to see a list of events linked to a given project

  Background:
    Given the following projects exist:
      | title | description          | pitch | status |
      | cs169 | greetings earthlings |       | active |
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Standup    | Daily standup meeting   | Scrum           | 2014/02/03 07:00:00 UTC | 150      | weekly  | UTC       |         |   15                                      |     1                 |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/07 10:00:00 UTC | 15       | weekly  | UTC       | cs169   |   15                                      |     1                 |

  @javascript
  Scenario: Show correct timezone
    Given the date is "2016/05/01 09:15:00 UTC"
    And the browser is in "Europe/London" and the server is in UTC
    And I am on events index page
    Then I should see "Standup"
    And I should see "08:00-10:30 (BST)"