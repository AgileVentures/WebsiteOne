Feature: See project related videos
  As a member of AgileVentures
  So that I can see all the videos related to a project
  I would like to see a list of videos on a project page

  Background:
    Given I am logged in
    And my YouTube Channel ID with some videos in it
    And my YouTube channel is connected
    And the following projects exist:
      | title       | description          | status   | tags            |
      | hello world | greetings earthlings | active   | WSO, WebsiteOne |
      | hello mars  | greetings aliens     | inactive | Autograders     |
    And I am a member of project "hello world"
    And I am a member of project "hello mars"


  Scenario: Project show page renders a list of videos
    Given I am on the "Show" page for project "hello world"
    Then I should see "Videos (7)"
    And I should see a "List of Project videos" table with:
      | columns   |
      | Video     |
      | Host      |
      | Published |
    And I should see:
      | text                         |
      | WebsiteOne - Pairing session |
      | John Doe                     |
      | 2014-02-13                   |
      | PP on WSO                    |
      | John Doe                     |
      | 2014-01-13                   |
    But I should not see "Autograders"

  Scenario: show first video's description in the player's heading
    Given I am on the "Show" page for project "hello world"
    Then I should see "WebsiteOne - Pairing session - refactoring authentication controller" in "video description"

  Scenario: show videos sorted by published date
    Given I am on the "Show" page for project "hello world"
    Then I should see "WebsiteOne - Pairing session" before "PP on WSO"

  Scenario: show embedded youtube player with the first video
    Given I am on the "Show" page for project "hello world"
    And I should see video "WebsiteOne - Pairing session - refactoring authentication controller" in "player"

  @javascript
  Scenario: Selecting videos from the list
    Given I am on the "Show" page for project "hello world"
    When I click "Videos (7)"
    When I click "PP WSO: User management"
    Then I should see "PP WSO: User management" in "video description"
    And I should see video "PP WSO: User management" in "player"


