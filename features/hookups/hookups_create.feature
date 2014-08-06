Feature: Create Hookups
  In order to let other members know which hookups are available
  As a user
  I would like to be able to create pending events

  Background:
    Given I am logged in
    And following events exist:
      | name     | description    | category        | start_datetime              | duration                | repeats | time_zone |
      | Hookup 0 | hookup meeting | PairProgramming | 2014/02/03 09:00:00 UTC | 90 | never   | UTC       |
      | Hookup 1 | hookup meeting | PairProgramming | 2015/02/03 07:00:00 UTC | 150 | never   | UTC       |
      | Scrum 0  | hookup meeting | Scrum           | 2015/02/03 07:00:00 UTC | 150 | never   | UTC       |
    When I go to the "Hookups" page

  Scenario: button for a new pending event
    Then I should see button "New Hookup"
    And I should not see:
      | Descriptive Title |
      | Start Time        |
      | Duration          |

  @javascript
  Scenario: show fields for a new pending event (fields)
    Then I should see button "New Hookup"
    When I click "New Hookup" button
    Then I should see:
      | Descriptive Title |
      | Start Time        |
      | Duration          |
    And I should see field "title"
    And I should see button "Create"

  @javascript
  Scenario: hide fields for a new pending event (fields)
    Then I should see button "New Hookup"
    When I click "New Hookup" button
    Then I should see:
      | Descriptive Title |
      | Start Time        |
      | Duration          |
    And I should see field "title"
    And I should see button "Create"
    And I should see button "Cancel"
    When I click "Cancel" button
    Then I should not see:
      | Descriptive Title |
      | Start Time        |
      | Duration          |
    #And I should not see field "title"

  @javascript
  Scenario: hide fields for a new pending event II (fields)
    Then I should see button "New Hookup"
    When I click "New Hookup" button
    Then I should see:
      | Descriptive Title |
      | Start Time        |
      | Duration          |
    And I should see field "title"
    And I should see button "Create"
    And I should see button "Cancel"
    When I click "New Hookup" button
    Then I should not see:
      | Descriptive Title |
      | Start Time        |
      | Duration          |
    #And I should not see field "title"
