Feature: List projects with deactivated users
  As a user
  So that I can browse projects
  Display anonymous for users that have deactivated their account

  Scenario: Display anonymous when the project owner account is deactivated
    Given "Billy Bob" creates the project "Home run"
    And "Billy Bob" deactivates his account
    When I visit "/projects"
    Then I should see "Home run"
    And I should see "by anonymous"
