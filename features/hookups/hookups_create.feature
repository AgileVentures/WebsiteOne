@javascript
Feature: Create Hookups
  In order to let other members know which hookups are available
  As a user
  I would like to be able to create pending events

  Background:
    Given I am logged in
    And following events exist:
      | name     | description    | category        | start_datetime          | duration | repeats | time_zone |
      | Hookup 0 | hookup meeting | PairProgramming | 2014/02/03 09:00:00 UTC | 90       | never   | UTC       |
      | Hookup 1 | hookup meeting | PairProgramming | 2015/02/03 07:00:00 UTC | 150      | never   | UTC       |
      | Scrum 0  | hookup meeting | Scrum           | 2015/02/03 07:00:00 UTC | 150      | never   | UTC       |
    When I go to the "Hookups" page

  Scenario: button for a new pending event
    Then I should see button "New Hookup"

  Scenario: show fields for a new pending event (fields)
    When I click "New Hookup" button
    Then I should see field "title_field"
    Then I should see field "start_date"
    Then I should see field "start_time"
    Then I should see field "duration"

  Scenario: show buttons for a new pending event (fields)
    When I click "New Hookup" button
    Then I should see button "Create"
    And I should see button "Cancel"
    And I should see disabled button "New Hookup"

  Scenario: hide fields for a new pending event (fields)
    When I click "New Hookup" button
    When I click "Cancel" button
    Then I should not see:
      | Descriptive Title |
      | Start Time in UTC |
    And I should not see field "title_field"
    And I should not see field "start_date"
    And I should not see field "start_time"
    And I should not see field "duration"
    And I should not see button "Cancel"
    And I should not see the Create Hookup form

  Scenario: try creating without title, then set title and create to use previous date/time
    Given the time now is "2014-07-15 12:00:00 UTC"
    When I click "New Hookup" button
    And I fill in "start_date" with "2014-08-15"
    And I fill in "start_time" with "09:00:00"
    And I click "Create"
    Then I should not see "hookup july 15" in table "pending_hookups"
    When I click "New Hookup" button
    And I fill in "title" with "hookup july 15"
    And I click "Create"
    Then I should see "hookup july 15" in table "pending_hookups"

