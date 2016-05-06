@javascript @vcr
Feature: Events
  As a site user
  In order to be able to update planned activities
  I would like to edit events

  Background:
    Given I am logged in
    And I am on Events index page
    When I click "New Event"
    And I select "Repeats" to "weekly"
    And I check "Monday"
    And I check "Thursday"
    Given I fill in event field:
      | name        | value         |
      | Name        | Daily Standup |
      | Start Date  | 2014-02-04    |
      | Start Time  | 09:00         |
      | Description | we stand up   |
      | End Date    | 2014-03-04    |
    Then the event is set to end sometime
    And I click on the "repeat_ends_on" div
    And I click the "Save" button
    And I am on Events index page

  Scenario: Check that edit page reflects initial settings
    And I visit the edit page for the event named "Daily Standup"
    Then the "Repeat ends" selector should be set to "on"

  Scenario: Edit an existing event to never end
    And I visit the edit page for the event named "Daily Standup"
    And I select "Repeat ends" to "never"
    And I click the "Save" button
    Then I should be on the Events "index" page
    And I visit the edit page for the event named "Daily Standup"
    Then the "Repeat ends" selector should be set to "never"