@vcr
Feature: Event Videos
  "As a site user
  In order to see a list of videos for a specific event
  I would like to see these videos on the event show page"

  Background:
    Given following events exist:
      | name         | description         | category | start_datetime          | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask |
      | Repeat Scrum | Daily scrum meeting | Scrum    | 2014/03/03 07:00:00 UTC | 15       | daily   | UTC       |                       |                                           |
    And the following event instances exist:
      | title        | hangout_url         | created_at       | updated_at          | uid | category | project    | user_id | yt_video_id | hoa_status | url_set_directly | event        |
      | RepeatScrum1 | http://hangout.test | 2012 Feb 4th 7am | 2012 Feb 4th 7:04am | 100 | Scrum    | Websiteone | 1       | QWERT55     | finished   | true             | Repeat Scrum |
      | RepeatScrum2 | http://hangout.test | 2014 Feb 4th 7am | 2014 Feb 4th 7:03am | 100 | Scrum    | Websiteone | 1       | QWERT55     | finished   | true             | Repeat Scrum |

  Scenario: show embedded youtube player with the first video
    Given I am on the show page for event "Repeat Scrum"
    Then I should see video "RepeatScrum1" in "player"

# @javascript
# Scenario: Selecting videos from the list
#   Given I am on the show page for event "Repeat Scrum"
#   When I click "RepeatScrum2"
#   Then I should see "RepeatScrum2" in "video description"
#   And I should see video "RepeatScrum2" in "player"
