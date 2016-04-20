@vcr
Feature: List Repeating Events
  As a site user
  So I can find events relevant to me that are happening now
  I would like to see repeats of regular events

  Background:
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Standup    | Daily standup meeting   | Scrum           | 2014/02/03 07:00:00 UTC | 150      | weekly  | UTC       |         |   15                                      |     1                 |

  Scenario: Show correct timezone
    Given the date is "2016/05/01 09:15:00 UTC"
    And I am on events index page
    Then I should see "Standup"
    And the local time element should be set to "2016-05-10T07:00:00Z"
