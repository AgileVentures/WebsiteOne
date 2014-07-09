Feature: Managing hangouts of scrums and PairProgramming sessions
  In order to manage hangouts of scrums and PP sessions  easily
  As a site user
  I would like to have means of creating, joining, editing and watching hangouts

  Background:
    Given following events exist:
      | name  | description         | category | event_date | start_time              | end_time                | repeats | time_zone |
      | Scrum | Daily scrum meeting | Scrum    | 2014/02/03 | 2000-01-01 07:00:00 UTC | 2000-01-01 09:30:00 UTC | never   | UTC       |
    And I am logged in
    And I have Slack notifications enabled

  @javascript
  Scenario: Create a hangout for a scrum event
    Given I am on the show page for event "Scrum"
    Then I should see hangout button
    And I should see "Edit hangout link"

  Scenario: Show hangout details
    Given the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |
      | Started at   | 10:25:00            |
    And the time now is "10:30:00"
    When I am on the show page for event "Scrum"
    Then I should see Hangouts details section
    And I should see:
        | Category            |
        | Scrum               |
        | Title               |
        | Daily scrum meeting |
        | Updated             |
        | 5 minutes ago       |
    And I should see link "http://hangout.test" with "http://hangout.test"

  @javascript
  Scenario: Show restart hangout
    Given the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |
    When I am on the show page for event "Scrum"
    Then I should see "Restart hangout"
    But the hangout button should not be visible


  @javascript
  Scenario: Restart hangout
    Given the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |
    And I am on the show page for event "Scrum"

    When I click the link "Restart hangout"
    Then I should see "Restarting Hangout would update the details of the hangout currently associated with this event."
    And the hangout button should be visible

    When I click the button "Close"
    Then the hangout button should not be visible

  @javascript
   Scenario: Edit URL
     Given I am on the show page for event "Scrum"
     When I click the link "Edit hangout link"
     Then I should see button "Cancel"

     When I fill in "hangout_url" with "http://test.com"
     And I click the "Save" button
     Then I should see link "http://test.com" with "http://test.com"

  @javascript
  Scenario: Cancel Edit URL
    Given I am on the show page for event "Scrum"
    When I click the link "Edit hangout link"
    And I click the button "Close"
    Then I should not see button "Save"

  @time-travel-step
  Scenario: Render Join live event link
    Given the date is "2014/02/03 07:05:00 UTC"
    And the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |
      | Started at   | 07:00:00            |

    When I am on the show page for event "Scrum"
    Then I should see link "EVENT IS LIVE" with "http://hangout.test"

    When I am on the home page
    Then I should see "Scrum is live!"
    And I should see link "Click to join!" with "http://hangout.test"
