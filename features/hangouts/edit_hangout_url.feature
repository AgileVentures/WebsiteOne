Feature: Manual Edit of Hangout URL
  As a person involved in an event
  So that I can ensure everyone can access the correct link to join an event
  I would like to have means of editing the hangout URL

  Background:
    Given the date is "2014-02-04 06:59:00"
    And following events exist:
      | name          | description          | category      | start_datetime          | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask |
      | Scrum         | Daily scrum meeting  | Scrum         | 2014/02/04 07:00:00 UTC | 15      | never   | UTC       |                       |                                           |
      | Repeat Scrum  | Daily scrum meeting  | Scrum         | 2014/02/03 07:00:00 UTC | 15      | weekly  | UTC       | 1                     | 15                                        |
    And the following hangouts exist:
      | Start time          | Title        | Project    | Category | Event        | EventInstance url   | Youtube video id | End time            |
      | 2012-02-04 07:00:00 | HangoutsFlow | WebsiteOne | Scrum    | Repeat Scrum | http://hangout.test | QWERT55          | 2014-02-04 07:02:00 |
      | 2014-02-05 07:00:00 | HangoutsFlow | WebsiteOne | Scrum    | Repeat Scrum | http://hangout.test | QWERT55          | 2014-02-05 07:03:00 |
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
    And I navigate to the show page for event "Repeat Scrum"
    And I open the Edit URL controls
    And I fill in "hangout_url" with "https://hangouts.google.com/hangouts/_/ytl/HEuWPSol0vcSmwrkLzR4Wy4mkrNxNUxVmqHMmCIjEZ8=?hl=en_US&authuser=0"
    And I click on the Save button
    Then I should see link "Join now" with "https://hangouts.google.com/hangouts/_/ytl/HEuWPSol0vcSmwrkLzR4Wy4mkrNxNUxVmqHMmCIjEZ8=?hl=en_US&authuser=0"
    And I jump to one minute before the end of the event at "2014-02-06 07:14:00"
    And I navigate to the show page for event "Repeat Scrum"
    Then I should see link "Join now" with "https://hangouts.google.com/hangouts/_/ytl/HEuWPSol0vcSmwrkLzR4Wy4mkrNxNUxVmqHMmCIjEZ8=?hl=en_US&authuser=0"
