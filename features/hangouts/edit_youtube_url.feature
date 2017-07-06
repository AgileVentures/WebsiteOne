@vcr @javascript @disable_twitter
Feature: Manual Edit of Youtube URL
  As a person involved in an event
  So that I can ensure everyone can access the correct link to watch an event
  I would like to have means of editing the youtube URL

  Background:
    Given the following projects exist:
      |title | description | status |
      | LS   | LS          | active |
    Given following events exist:
      | name         | description         | category | start_datetime   | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask | project |
      | Scrum        | Daily scrum meeting | Scrum    | 2014 Feb 4th 7am | 15       | never   | UTC       |                       |                                           |  LS     |
      | Repeat Scrum | Daily scrum meeting | Scrum    | 2014 Feb 3rd 7am | 15       | weekly  | UTC       | 1                     | 31                                        |         |
    And the following event instances (with default participants) exist:
      | title        | hangout_url         | created_at       | updated_at          | uid | category | project    | user_id | yt_video_id | hoa_status | url_set_directly | event        |
      | HangoutsFlow | http://hangout.test | 2012 Feb 4th 7am | 2012 Feb 4th 7:04am | 100 | Scrum    | Websiteone | 1       | QWERT55     | started    | true             | Repeat Scrum |
      | HangoutsFlow | http://hangout.test | 2014 Feb 4th 7am | 2014 Feb 4th 7:03am | 100 | Scrum    | Websiteone | 1       | QWERT55     | started    | true             | Repeat Scrum |
    And I am logged in

  Scenario: Edit Youtube URL and ensure URL is saved
    Given the date is "2014 Feb 4th 6:59am"
    And I manually set a youtube link for event "Scrum"
    Then "Scrum" shows that youtube link for event duration

  Scenario: Edit Youtube URL and ensure video appears on Project page
    Given the date is "2014 Feb 6th 7:01am"
    And I manually set youtube link with youtube id "1234" for event "Repeat Scrum"
    When I am on the "Show" page for project "hello world"
    And I click "Videos (3)"
    Then I should see video with youtube id "1234"