@time-travel
Feature: Managing hangouts of scrums and PairProgramming sessions
  In order to manage hangouts of scrums and PP sessions  easily
  As a site user
  I would like to have means of creating, joining, editing and watching hangouts

  Background:
    Given following events exist:
      | name  | description         | category | event_date | start_time              | end_time                | repeats | time_zone |
      | Scrum | Daily scrum meeting | Scrum    | 2014/02/03 | 2000-01-01 07:00:00 UTC | 2000-01-01 09:30:00 UTC | never   | UTC       |
    And I am logged in

  @javascript @ignore
  Scenario: Create a hangout for a scrum event
    Given I am on the show page for event "Scrum"
    Then I should see hangout button
    And I should see button "Edit link"

  @ignore
  Scenario: Show hangout details
    Given the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |
      | Started at   | 10:25:00            |
    When I am on the show page for event "Scrum"
    Then I should see Hangouts details section
    And I should see:
        | Category            |
        | Scrum               |
        | Title               |
        | Daily scrum meeting |
        | Updated             |
        | 10:25:00            |
    And I should see link "Click to join the hangout" with "http://hangout.test"

  @ignore
  Scenario: Show restart hangout
    Given the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |
    When I am on the show page for event "Scrum"
    Then the hangout button should not be visible
    And I should see button "Click to restart the hangout"

  @ignore
  @javascript
  Scenario: Restart hangout
    Given the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |
    And I am on the show page for event "Scrum"
    When I click "Click to restart the hangout"

    Then I should see "Restarting Hangout would update the details of the hangout currently associated with this event."
    And I should see button "Cancel"
    And the hangout button should be visible
    And I should not see Hangouts details section
    And I should not see "Click to restart the hangout"

    When I click the "Cancel" button
    Then I should see Hangouts details section
    And I should see "Click to restart the hangout"
    And the hangout button should not be visible

  @javascript
   Scenario: Edit URL
     Given I am on the show page for event "Scrum"
     When I click the "Edit hangout link manually" button
     Then I should see button "Cancel"

     When I fill in "hangout_url" with "http://test.com"
     And I click the "Save" button
     Then I should see link "Click to join the hangout" with "http://test.com"
