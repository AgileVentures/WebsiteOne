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

  Scenario: Show hangout details
    Given the Hangout for event "Scrum" has been started with details:
      | Hangout link | http://hangout.test |       |      |
    When I am on the show page for event "Scrum"
    Then I should see a hangout link "Click to join the hangout" for the event "Scrum"


