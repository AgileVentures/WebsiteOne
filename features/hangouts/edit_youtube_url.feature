@vcr @javascript @disable_twitter
Feature: Manual Edit of Youtube URL
  As a person involved in an event that starts at 7am
  So that I can ensure everyone can access the correct link to watch an event
  I would like to have means of editing the youtube URL

  Background:
    Given the following projects exist:
      |title | description | status |
      | LS   | LS          | active |
    Given following events exist:
      | name         | description         | category | start_datetime   | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask | project |
      | Scrum        | Daily scrum meeting | Scrum    | 2014 Feb 4th 7am | 15       | never   | UTC       |                       |                                           |  LS     |
      | Repeat Scrum | Daily scrum meeting | Scrum    | 2014 Feb 3rd 7am | 15       | weekly  | UTC       | 1                     | 31                                        |  LS       |
    And the following event instances (with default participants) exist:
      | title        | hangout_url         | created_at       | updated_at          | uid | category | project    | user_id | yt_video_id | hoa_status | url_set_directly | event        |
      | HangoutsFlow | http://hangout.test | 2012 Feb 4th 7am | 2012 Feb 4th 7:04am | 100 | Scrum    | Websiteone | 1       | QWERT55     | started    | true             | Repeat Scrum |
      | HangoutsFlow | http://hangout.test | 2014 Feb 4th 7am | 2014 Feb 4th 7:03am | 100 | Scrum    | Websiteone | 1       | QWERT55     | started    | true             | Repeat Scrum |
    And I am logged in

  Scenario: Editing Youtube URL has no effect on Hangout URL
    Given the date is "2014 Feb 4th 7:01am"
    And I manually set a hangout link for event "Scrum"
    And I manually set youtube link with youtube id "12341234111" for event "Scrum"
    Then Hangout link does not change for "Scrum"
        
  Scenario: Editing Hangout URL has no effect on Youtube URL
    Given the date is "2014 Feb 4th 7:01am"
    And I manually set youtube link with youtube id "12341234111" for event "Scrum"
    And I manually set a hangout link for event "Scrum"
    Then "Scrum" shows youtube link with youtube id "12341234111"

    # we're sort of stuck here because we don't seem to be able to avoid
    # a background js error here - best solution to keep this test might be
    # set up some kind of hook to ignore js errors for this one test, but that's
    # not ideal ... using a real video id makes the issue go away in the live system
    # although not in our test ... this might be some sort of underlying bug in the
    # youtube javascript libraries that get pulled down
    #
    # see https://github.com/AgileVentures/WebsiteOne/issues/1754
    #
  @javascript
  Scenario: Edit Youtube URL and ensure video appears on Project page
    Given the date is "2014 Feb 6th 7:01am"
    And I manually set youtube link with youtube id "cdODZWHUwhc" for event "Repeat Scrum"
    When I am on the "Show" page for project "LS"
    And I click "Videos (1)"
    Then I should see video with youtube id "cdODZWHUwhc"

  Scenario: Edit Youtube URL when event is live and ensure a separate event instance is not created
    Given the date is "2014 Feb 7th 7:01am"
    And I manually set a hangout link for event "Scrum"
    When I manually set youtube link with youtube id "12341234111" for event "Scrum"
    Then a separate event instance is not created