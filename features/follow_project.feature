@vcr
Feature: Join projects
    "As a user
    So that I can participate in projects
    I would like to join projects as a member
    And I can see who is a member of which project"

  https://www.pivotaltracker.com/story/show/63372740

  Background:
    Given the following projects exist:
      | title       | description          | status   |
      | hello world | greetings earthlings | active   |
      | hello mars  | greetings aliens     | inactive |
    And there are no videos

  Scenario: Join a project
    Given I have logged in
    And I am not a member of project "hello mars"
    And I am on the "Show" page for project "hello mars"
    And I click the "Join Project" button
    Then I should become a member of project "hello mars"
    And I should see "You just joined hello mars"

  Scenario: Leave a project
    Given I have logged in
    And I am a member of project "hello mars"
    And I am on the "Show" page for project "hello mars"
    And I click "Leave Project"
    Then I should stop being a member of project "hello mars"
    And I should see "You are no longer a member of hello mars"
