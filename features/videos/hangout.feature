@time-travel
Feature: Managing videos of scrums and PairProgramming sessions
  In order to manage videos of scrums and PP sessions  easily
  As a site user
  I would like to have means of creating, joining, editing and watching videos

  Background:
    Given following events exist:
      | name       | description             | category        | event_date | start_time              | end_time                | repeats | time_zone                  |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 | 2000-01-01 07:00:00 UTC | 2000-01-01 09:30:00 UTC | never   | UTC                  |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/07 | 2000-01-01 10:00:00 UTC | 2000-01-01 10:15:00 UTC | never   | UTC |
    And I am logged in

  @ignore @javascript
  Scenario: Create a hangout for a scrum event
    #TODO need to find a way of integration testing the Hangout button presence
    #without external requests
    Given I am on the show page for event "Scrum"
    Then I should see hangout button

  Scenario: See the link to the Hangout of the event
    Given the Hangout for event "Scrum" has been started
    And I am on the show page for event "Scrum"
    Then I should see a link "Click to join the hangout" for the event "Scrum"
