@vcr
Feature: List Single Events
  As a site user
  So I can find events relevant to me that are happening now
  I would like to see one off events

  Background:
    Given the following projects exist:
      | title | description          | pitch | status |
      | wso   | blah                 |       | active |
      | auto  | blah                 |       | active |
      | cs169 | greetings earthlings |       | active |
    And following events exist:
      | name | description      | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks | repeat_ends |
      | Once | Once off meeting | PairProgramming | 2016/05/02 07:00:00 UTC | 150      | never   | UTC       | cs169   |                                           |                       | true        |

  Scenario: Show correct timezone
    Given the date is "2016/05/01 09:15:00 UTC"
    And I am on events index page
    Then I should see "Once"
    And the local time element should be set to "2016-05-02T07:00:00Z"