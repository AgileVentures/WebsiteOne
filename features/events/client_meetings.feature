@vcr
Feature: Provide a ClientMeeting Category
  As a project manager
  In order to be able to distinguish between client meetings and other types of meeting
  I would like to see and create "client meeting" events

  Background:
    Given following events exist:
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | ClientMtg  | Daily client meeting    | ClientMeeting   | 2014/02/03 11:00:00 UTC | 150      | never   | UTC       |         |                                           |                       |
    And I have logged in
    And the following projects exist:
      | title | description          | pitch | status | commit_count |
      | WSO   | greetings earthlings |       | active | 2795         |
      | EdX   | greetings earthlings |       | active | 2795         |
      | AAA   | for roadists         |       | active |              |

  # @javascript
  # Scenario: Show Client Meeting event
  #   Given the date is "2014/02/03 07:01:00 UTC"
  #   And I am on Events index page
  #   Then I should see "ClientMtg"
  #   And I should see "11:00-13:30 (UTC)"

  @javascript
  Scenario: Create Client Meeting event
    Given I am on Events index page
    When I click "New Event"
    And I fill in event field:
      | name        | value          |
      | Name        | Whatever       |
      | Description | something else |
      | Start Date  | 2014-02-04     |
      | Start Time  | 09:00          |
    And I select "EdX" from the event project dropdown
    And I select "ClientMeeting" from the event category dropdown
    And I should not see "End Date"
    And I click on the "event_date" div
    And I click the "Save" button
    Then I should see "Event Created"
    Given the event "Whatever"
    Then I should be on the event "Show" page for "Whatever"
    And the event named "Whatever" is associated with "EdX"
    And I should see "Event type: ClientMeeting"
