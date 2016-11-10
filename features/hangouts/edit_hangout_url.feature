Feature: Manual Edit of Hangout URL
  As a person involved in an event
  So that I can ensure everyone can access the correct link to join an event
  I would like to have means of editing the hangout URL

  Background:
    Given the date is "2014-02-04 06:59:00"
    And following events exist:
      | name         | description         | category | start_datetime          | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask |
      | Scrum        | Daily scrum meeting | Scrum    | 2014/02/04 07:00:00 UTC | 15       | never   | UTC       |                       |                                           |
      | Repeat Scrum | Daily scrum meeting | Scrum    | 2014/02/03 07:00:00 UTC | 15       | weekly  | UTC       | 1                     | 31                                        |
    And the following event instances (with default participants) exist:
      | title        | hangout_url         | created_at          | updated_at          | uid | category | project    | user_id | yt_video_id | hoa_status | url_set_directly | event        |
      | HangoutsFlow | http://hangout.test | 2012-02-04 07:00:00 | 2012-02-04 07:02:00 | 100 | Scrum    | Websiteone | 1       | QWERT55     | started    | true             | Repeat Scrum |
      | HangoutsFlow | http://hangout.test | 2014-02-04 07:00:00 | 2014-02-04 07:03:00 | 100 | Scrum    | Websiteone | 1       | QWERT55     | started    | true             | Repeat Scrum |
    And I am logged in
    And I have Slack notifications enabled

  @javascript
  Scenario: Edit Hangout URL and ensure event stays live
    And I navigate to the show page for event "Scrum"
    And I open the Edit URL controls
    And I fill in "hangout_url" with "http://test.com"
    And I click on the Save button
    Then I should see link "Join now" with "http://test.com"
    And I jump to one minute before the end of the event at "2014-02-04 07:14:00"
    And I navigate to the show page for event "Scrum"
    Then I should see link "Join now" with "http://test.com"

  @javascript
  Scenario: Edit Hangout URL on repeating event and ensure event stays live
    Given the date is "2014-02-06 07:00:00"
    # manually setting the hangout link
    And I navigate to the show page for event "Repeat Scrum"
    And I open the Edit URL controls
    And I fill in "hangout_url" with "https://hangouts.google.com/hangouts/_/ytl/HEuWPSol0vcSmwrkLzR4Wy4mkrNxNUxVmqHMmCIjEZ8=?hl=en_US&authuser=0"
    And I click on the Save button
    # checking that event shows live and that link
    And I navigate to the show page for event "Repeat Scrum"
    Then I should see link "Join now" with "https://hangouts.google.com/hangouts/_/ytl/HEuWPSol0vcSmwrkLzR4Wy4mkrNxNUxVmqHMmCIjEZ8=?hl=en_US&authuser=0"
    # checking that the event stays live for the specified duration (as no pings coming from hangout plugin)
    And I jump to one minute before the end of the event at "2014-02-06 07:14:00"
    And I navigate to the show page for event "Repeat Scrum"
    Then I should see link "Join now" with "https://hangouts.google.com/hangouts/_/ytl/HEuWPSol0vcSmwrkLzR4Wy4mkrNxNUxVmqHMmCIjEZ8=?hl=en_US&authuser=0"
    # Check that the event the following day is not automatically taken live
    And I jump to one minute before the end of the event at "2014-02-07 07:01:00" # actually a week later
    And I navigate to the show page for event "Repeat Scrum"
    Then I should not see "This event is now live!"

    # and navigate to past events page, and check that we have at least 3 events ...

#    When I visit "/hangouts"
#    Then I should see 3 hangouts