@vcr
Feature: Private Events
  As a premium member
  So that I can easily work out the time of the next premium event in my timezone
  I would like premium events


  Background:
    Given the following plans exist
      | name                       | amount | free_trial_length_days |
      | Premium                    | 1000   | 7                      |
    Given the following users exist
      | first_name | last_name | email                       | latitude | longitude | updated_at   |
      | Alice      | Jones     | MyEmailAddress@example.com  | 59.33    | 18.06     | 1 minute ago |
      | Bob        | Smith     | BobEmailAddress@example.com | 59.33    | 18.06     | 1 minute ago |
    Given the following subscriptions exist with plan
      | type     | user  |
      | Premium  | Alice |
      | Free     | Bob   |
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |         |                                           |                       |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/07 10:00:00 UTC | 15       | never   | UTC       |         |                                           |                       |
      | Standup    | Daily standup meeting   | Scrum           | 2014/02/03 07:00:00 UTC | 150      | weekly  | UTC       |         | 15                                        | 1                     |
      | ClientMtg  | Daily client meeting    | ClientMeeting   | 2014/02/03 11:00:00 UTC | 150      | never   | UTC       |         |                                           |                       |

  Scenario: Premium memmber should see all events
    Given I am on Events index page
    Then I should see "AgileVentures Events"
    And I should see "Standup"

  @javascript
  Scenario: Premium members should have access to even show pages for pivate events
    Given I am on Events index page
    And they view the event "Standup"
    Then they should see a link to the creator of the event
    Then they should see the icon of the creator of the event
