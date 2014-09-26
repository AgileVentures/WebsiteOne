Feature: Join projects
  As a user
  So that I can participate in projects
  I would like to join projects as a member
  And I can see who is a member of which project

  https://www.pivotaltracker.com/story/show/63372740

Background:
  Given the following projects exist:
    | title       | description          | status   |
    | hello world | greetings earthlings | active   |
    | hello mars  | greetings aliens     | inactive |
  And there are no videos


  Scenario: Join a project
  Given I am logged in
  And I am not a member of project "hello mars"
  And I am on the "Show" page for project "hello mars"
  And I click the very stylish "Join Project" button
  Then I should become a member of project "hello mars"
  And I should see "You just joined hello mars"
  And I should see my gravatar in the project members list

Scenario: Leave a project
  Given I am logged in
  And I am a member of project "hello mars"
  And I am on the "Show" page for project "hello mars"
  And I click the very stylish "Leave Project" button
  Then I should stop being a member of project "hello mars"
  And I should see "You are no longer a member of hello mars"
  And I should not see my gravatar in the project members list
