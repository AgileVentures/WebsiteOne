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

  @javascript
  Scenario: Create a hangout for a scrum event
    Given I am on the show page for event "Scrum"
    Then I should see hangout button

#  Scenario: Start the hangout
#    Given I am on the show page for event "Scrum"
#    When I click the "Start" button
#    Then I should see a new window for the creation of the Hangout

  Scenario: Show hangout details
    Given the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |       |      |
    When I am on the show page for event "Scrum"
    Then I should see Hangouts_Details_Section
    And I should see link "Click to join the hangout" with "http://hangout.test"
    And I should see button "Edit link"
    And I should see "Title"
    And I should see "Type"
    And I should see "Daily scrum meeting"
    And I should see "Scrum"

  Scenario: Show restart hangout
    Given the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |       |      |
    When I am on the show page for event "Scrum"
    Then the hangout button should not be visible
    And I should see link "Click to restart the hangout"


  Scenario: Restart hangout
    Given the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |       |      |
    And I am on the show page for event "Scrum"
    When I click "Click to restart the hangout"
    Then I should see "Restarting Hangout would update the details of the hangout currently associated with this event.  Do you want to continue?"
    #When I click the "Yes" button
    Then the hangout button should be visible
    And I should not see Hangouts_Details_Section

   Scenario: Edit URL
     Given the Hangout for event "Scrum" has been started with details:
       | Hangout link | http://hangout.test |       |      |
     And I am on the show page for event "Scrum"
     When I click the "Edit link" button
     Then I should see button "Cancel"
     When I fill in "event_url" with "http://test.com"
     And I click the "Save" button
     Then I should see link "Click to join the Hangout" with "http://test.com"
