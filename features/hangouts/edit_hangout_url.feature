@disable_twitter
Feature: Manual Edit of Hangout URL
  As a person involved in an event
  So that I can ensure everyone can access the correct link to join an event
  I would like to have means of editing the hangout URL

  Background:
    Given the following projects exist:
      | title | description | status |
      | LS    | LS          | active |
    Given following events exist:
      | name         | description         | category | start_datetime | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask | project |
      | Scrum        | Daily scrum meeting | Scrum    | TODAYS_DATE    | 15       | never   | UTC       |                       |                                           | LS      |
      | Repeat Scrum | Daily scrum meeting | Scrum    | TODAYS_DATE    | 15       | weekly  | UTC       | 1                     | 127                                       |         |
      | The daily    | Daily scrum meeting | Scrum    | TODAYS_DATE    | 15       | weekly  | UTC       | 1                     | 127                                       |         |
    And the following event instances (with default participants) exist:
      | title        | hangout_url         | created_at       | updated_at          | uid | category | project    | user_id | yt_video_id | hoa_status | url_set_directly | event        |
      | HangoutsFlow | http://hangout.test | 2012 Feb 4th 7am | 2012 Feb 4th 7:04am | 100 | Scrum    | Websiteone | 1       | QWERT55     | started    | true             | Repeat Scrum |
      | HangoutsFlow | http://hangout.test | 2014 Feb 4th 7am | 2014 Feb 4th 7:03am | 100 | Scrum    | Websiteone | 1       | QWERT55     | started    | true             | Repeat Scrum |
    And I have logged in

  @javascript
  Scenario: Hangout link is active at start of event
    Given a hangout link was set for event "Scrum" 0 minutes ago
    Then "Scrum" shows a live hangout link at start of event

  @javascript
  Scenario: Hangout link is active near the end of event
    Given a hangout link was set for event "Scrum" 10 minutes ago
    Then "Scrum" shows a live hangout link near the end of the event

  @javascript
  Scenario: Hangout link is NOT active after event ends
    Given a hangout link was set for event "Scrum" 20 minutes ago
    Then "Scrum" does NOT show a live hangout link after the event ends

  @javascript
  Scenario: Edit Hangout URL on repeating event at start of event
    Given a hangout link was set for event "Repeat Scrum" 0 minutes ago
    Then "Repeat Scrum" shows a live hangout link at start of event

  @javascript
  Scenario: Edit Hangout URL on repeating event near the end
    Given a hangout link was set for event "Repeat Scrum" 10 minutes ago
    Then "Repeat Scrum" shows a live hangout link near the end of the event

  @javascript
  Scenario: Edit Hangout URL on repeating event after event ends
    Given a hangout link was set for event "Repeat Scrum" 20 minutes ago
    Then "Repeat Scrum" does NOT show a live hangout link after the event ends

  @javascript
  Scenario: Repeating event is NOT live after one day
    Given a hangout link was set for event "Repeat Scrum" 1440 minutes ago
    Then "Repeat Scrum" does NOT show a live hangout link after the event ends

  @javascript
  # wraps bug described in https://github.com/AgileVentures/WebsiteOne/issues/1809
  Scenario: Event doesn't ping old youtube URL
    Given the date is "2014 Feb 5th 6:59am"
    And the event "Repeat Scrum" was last updated at "2014 Feb 4th 7:16am"
    And that we're spying on the SlackService
    And the Slack notifications are enabled
    When I manually set a hangout link for event "Repeat Scrum"
    Then the Hangout URL is posted in Slack
# And the Youtube URL is not posted in Slack
