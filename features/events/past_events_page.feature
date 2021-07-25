Feature: List the recent Event Instances on the corresponding Events page
  "As a user
  In order to identify repeating events that are still active
  I would like to see a list of the most recents events"

  Background:
    Given following events exist:
      | name      | id | description        | for                 | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Mob       | 5  | Weekly Mob meeting | Premium Mob Members | PairProgramming | 2014/02/03 09:00:00 UTC | 150      | never   | UTC       |         |                                           |                       |
      | Bob's mob | 3  | All things Bob     |                     | Scrum           | 2018/01/12 17:00:00 UTC | 30       | weekly  | UTC       |         | 3                                         | 1                     |

  Scenario: Guest user cannot watch a premium mob event
    Given an event instance exists for event id 5
    Given an event instance exists for event id 3
    When I visit "/hangouts"
    Then I should see a link to watch the video for event 3
    Then I should not see a link to watch the video for event 5
