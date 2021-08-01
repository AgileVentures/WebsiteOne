Feature: List projects with deactivated users
  "As a user
  So that I can browse projects
  Display anonymous for users that have deactivated their account"

  Scenario: Display anonymous when the project owner account is deactivated
    Given "Billy Bob" creates the project "Home run"
    And project "Home run" is activated
    And "Billy Bob" deactivates his account
    When I visit "/projects"
    Then I should see "Home run"

  Scenario: You can view the default anonymous ("Ghost") user page
    Given the anonymous user exists
    And "Billy Bob" creates the project "Home run"
    When "Billy Bob" deactivates his account
    And I visit "/users/-1"
    Then I should be on the anonymous profile page
