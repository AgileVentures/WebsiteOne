@vcr @javascript @disable_twitter
Feature: Manual Edit of Hangout URL
  As a person involved in an event
  So that I can ensure everyone can access the correct link to join an event
  I would like to have means of editing the hangout URL

  Background:
    Given following events exist:
      | name         | description         | category | start_datetime   | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask |
      | Scrum        | Daily scrum meeting | Scrum    | 2014 Feb 4th 7am | 15       | never   | UTC       |                       |                                           |
      | Repeat Scrum | Daily scrum meeting | Scrum    | 2014 Feb 3rd 7am | 15       | weekly  | UTC       | 1                     | 31                                        |
    And the following event instances (with default participants) exist:
      | title        | hangout_url         | created_at       | updated_at          | uid | category | project    | user_id | yt_video_id | hoa_status | url_set_directly | event        |
      | HangoutsFlow | http://hangout.test | 2012 Feb 4th 7am | 2012 Feb 4th 7:04am | 100 | Scrum    | Websiteone | 1       | QWERT55     | started    | true             | Repeat Scrum |
      | HangoutsFlow | http://hangout.test | 2014 Feb 4th 7am | 2014 Feb 4th 7:03am | 100 | Scrum    | Websiteone | 1       | QWERT55     | started    | true             | Repeat Scrum |
    And I am logged in

  Scenario: Edit Hangout URL and ensure event stays live
    Given the date is "2014 Feb 4th 6:59am"
    And I manually set a hangout link for event "Scrum"
    Then "Scrum" shows live for that hangout link for the event duration
    And there should be exactly 3 hangouts

  Scenario: Edit Hangout URL on repeating event and ensure event stays live
    Given the date is "2014 Feb 6th 7am"
    And I manually set a hangout link for event "Repeat Scrum"
    Then "Repeat Scrum" shows live for that hangout link for the event duration
    And "Repeat Scrum" is not live the following day
    And there should be exactly 3 hangouts