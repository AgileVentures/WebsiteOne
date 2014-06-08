@time-travel
@javascript
Feature: Managing hangouts of scrums and PairProgramming sessions
  In order to manage hangouts of scrums and PP sessions  easily
  As a site user
  I would like to have means of creating, joining, editing and watching hangouts

  Background:
    Given following events exist:
      | name       | description             | category        | event_date | start_time              | end_time                | repeats | time_zone                  |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 | 2000-01-01 07:00:00 UTC | 2000-01-01 09:30:00 UTC | never   | UTC                  |
    And I am logged in

  @ignore
  Scenario: Create a hangout for a scrum event
    #TODO need to find a way of integration testing the Hangout button presence
    #without external requests
    Given I am on the show page for event "Scrum"
    Then I should see hangout button

  Scenario: Show hangout details
    Given the Hangout for event "Scrum" has been started with details:
      | Host         | Sam Joseph          |
      | Youtube link | http://youtube.test |
      | Start time   | 10:00               |
      | Currently in | David               | Sam   |
      | Participants | Sam                 | David | Yaro |
    When I am on the show page for event "Scrum"
    Then I should see:
      | Status            | In progress |
      | Host              | Sam Joseph  |
      | Youtube recording |             |
      | Start time        | 10:00       |
      | Currently in      | Sam         | David |
      | Participants      | Sam         | Yaro  | David |
    And I should see youtube recording at link "http://youtube.test"
    And I should see a link "Click to join the hangout" for the event "Scrum"
    And I should see a youtube player with hangout recording
    But I should not see hangout button

  Scenario: Hide hangout details section
    Given the Hangout for event "Scrum" has not been started
    When I am on the show page for event "Scrum"
    Then I should not see hangout details section

  Scenario: Update hangout participants
    Given the Hangout for event "Scrum" has been started with details:
      | Currently in | David | Sam   |
      | Participants | Sam   | David | Yaro |
    And user "David" leaves the hangout
    But user "Jon" joins the hangout
    When I am on the show page for event "Scrum"
    Then I should see:
      | Currently in | Sam | Jon  |
      | Participants | Sam | Yaro | David | Jon |

  Scenario: Update hangout status
    Given the Hangout for event "Scrum" has been started with details:
      | Host         | Sam Joseph |
      | Start time   | 10:00      |
      | Participants | Sam        | David | Yaro |
    And the Hangout for event "Scrum" has finished at "10:25"
    When I am on the show page for event "Scrum"
    Then I should see:
      | Status   | Finished |
      | Duration | 00:25:00 |
    And I should not see a link "Click to join the hangout"

  Scenario: Clickable avatars for host and participants
    Given the Hangout for event "Scrum" has been started with details:
      | Host         | Sam Joseph |
      | Currently in | David      | Sam   |
      | Participants | Sam        | David | Yaro |
    When I am on the show page for event "Scrum"
    Then I should see avatars for:
      | Sam   |
      | David |
      | Yaro  |
    When I click on avatar for user "Yaro"
    Then I should be on profile page for user "Yaro"


