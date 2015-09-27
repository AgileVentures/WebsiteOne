Feature: See project related videos
  As a member of AgileVentures
  So that I can see all the videos related to a project
  I would like to see a list of videos on a project page

  Background:
    Given I am logged in
    And the following projects exist:
      | title       | description          | status   | tags            |
      | hello world | greetings earthlings | active   | WSO, WebsiteOne |
      | hello mars  | greetings aliens     | inactive | Autograders     |
    And the project "hello world" has 3 videos of user "John Doe"
    And the project "hello mars" has 2 videos of user "John Doe"


  Scenario: Project show page renders a list of videos
    Given I am on the "Show" page for project "hello world"
    Then I should see "Videos (3)"
    And I should see a "Latest Project videos" table with:
      | columns   |
      | Video     |
      | Host      |
      | Published |
    And I should see:
      | text                           |
      | PP on hello world - feature: 0 |
      | PP on hello world - feature: 1 |
      | PP on hello world - feature: 2 |
      | John Doe                       |
      | 00:00 15/04                    |
      | 00:01 15/04                    |
      | 00:02 15/04                    |
    But I should not see "PP on hello mars"

  Scenario: show video's description in the player's heading of the newest video
    Given I am on the "Show" page for project "hello world"
    Then I should see "PP on hello world - feature: 2" in "video description"

  Scenario: show videos sorted by descending published date
    Given I am on the "Show" page for project "hello world"
    Then I should see "PP on hello world - feature: 2" before "PP on hello world - feature: 1"
    Then I should see "PP on hello world - feature: 1" before "PP on hello world - feature: 0"

  Scenario: show embedded youtube player with the newest video
    Given I am on the "Show" page for project "hello world"
    And I should see video "PP on hello world - feature: 2" in "player"

  Scenario: show only 25 last videos
    Given the project "hello mars" has 25 videos of user "John Doe"
    Given I am on the "Show" page for project "hello mars"
    Then I should see "Videos (27)"
    And I should see 25 rows with text "PP on hello mars" in a table

  @javascript
  Scenario: Selecting videos from the list
    Given I am on the "Show" page for project "hello world"
    When I click "Videos (3)"
    When I click "PP on hello world - feature: 0"
    Then I should see "PP on hello world - feature: 0" in "video description"
    And I should see video "PP on hello world - feature: 0" in "player"

