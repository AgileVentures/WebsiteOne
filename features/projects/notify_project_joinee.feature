Feature: Notify project joinee when people join project
  As an AV member joining a project
  I want to receive a welcome email about the project
  So that I can understand how to get started and have an email to reach out to

  Background:
    Given the following users exist
      | first_name | last_name | email                  | receive_mailings  |
      | Alice      | Jones     | alicejones@hotmail.com | true              |
      | John       | Doe       | john@doe.com           | true              |
      | Bryan      | Yap       | test@test.com          | false             |
    Given the following projects exist:
      | title         | description           | status   | author |
      | hello world   | greetings earthlings  | active   | Alice  |
      | hello mars    | greetings aliens      | active   | John   |

  Scenario: when a person joins a project they get a welcome email
    Given I am logged in as "John"
    And I go to the "show" page for project "hello world"
    When I click "Join Project"
    Then project joinee "john@doe.com" should receive a "Welcome to the hello world project!" email

  Scenario: Notification should not be sent to project joinee if they disable site emails
    Given I am logged in as "Bryan"
    And I go to the "show" page for project "hello mars"
    When I click "Join Project"
    Then project joinee "test@test.com" should not receive a "Welcome to the hello mars project!" email
