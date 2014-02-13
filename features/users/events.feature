Feature: Events tracking
  In order to find events easily
  As a site user
  I would like events to have better description:
  title, topic, goals, participants, description

  Background:
    Given I am logged in
    And the following projects exist:
      | title     | description          | status |
      | AutGraders | greetings earthlings | active |
    And I am a member of project "hello world"

  Scenario: Create an event
    When I go to project "AutoGraders"
    Then I should see button "Create a new event"




