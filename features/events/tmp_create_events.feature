# this file was created to work on the bug
# https://github.com/AgileVentures/WebsiteOne/issues/3099
@javascript
Feature: Events with TimeZones
  As a user
  So that events are displayed with the correct date
  I would like to view events with correct time zone information

  Scenario: Creating a weekly event with a positive UTC time-zone difference
    Given I have logged in
    Given the user is located in "Africa/Algiers"
    And I am on Events index page
    When I click "New Event"
    And the date is "2019-05-19"
    When I fill in event field:
      | name        | value                |
      | Name        | Daily Standup Africa |
      | Start Date  | 2019-05-19           |
      | Start Time  | 00:30                |
      | Description | we stand up          |
    And I select "Africa/Algiers" from the time zone dropdown
    And I select "Repeats" to "weekly"
    And I check "Sunday"
    And I fill in event field:
      | name     | value      |
      | End Date | 2019-06-01 |
    And I click the "Save" button
    Then I should see "Event Created"
    And I should see "Sunday"
