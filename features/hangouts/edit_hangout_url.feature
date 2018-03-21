@vcr @javascript @disable_twitter
Feature: Manual Edit of Hangout URL
  As a person involved in an event
  So that I can ensure everyone can access the correct link to join an event
  I would like to have means of editing the hangout URL

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

  Scenario: Edit Hangout URL and ensure event stays live
    Given the date is "2014 Feb 4th 6:59am"
    And I manually set a hangout link for event "Scrum"
    Then "Scrum" shows live for that hangout link for the event duration
    And there should be exactly 3 hangouts
    And there should be exactly 1 hangouts associated with "LS"

  Scenario: Edit Hangout URL on repeating event and ensure event stays live
    Given the date is "2014 Feb 6th 7am"
    And I manually set a hangout link for event "Repeat Scrum"
    Then "Repeat Scrum" shows live for that hangout link for the event duration
    And "Repeat Scrum" is not live the following day
    And there should be exactly 3 hangouts

  Scenario: Event doesn't go live before Hangout URL is updated
    Given that "Repeat Scrum" went live the previous day
    Then it should not go live the next day just because the event start time is passed
    When I manually set a hangout link for event "Repeat Scrum"
    Then "Repeat Scrum" shows live for that hangout link for the event duration

  # wraps bug described in https://github.com/AgileVentures/WebsiteOne/issues/1809
  Scenario: Event doesn't ping old youtube URL
    Given the date is "2014 Feb 5th 6:59am"
    And the event "Repeat Scrum" was last updated at "2014 Feb 4th 7:16am"
    And that we're spying on the SlackService
    When I manually set a hangout link for event "Repeat Scrum"
    Then the Hangout URL is posted in Slack
    And the Youtube URL is not posted in Slack
