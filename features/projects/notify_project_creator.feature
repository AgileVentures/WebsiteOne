Feature: Notify project creator when people join project
  As a project organizer/creator
  I want to be notified when new people join my project within the AV site
  so that I can reach out and personally welcome them
  
  Background:
    Given the following users exist
      | first_name | last_name | email                  | receive_mailings  | 
      | Alice      | Jones     | alicejones@hotmail.com | true              | 
      | John       | Doe       | john@doe.com           | false             |    
      | Bryan      | Yap       | test@test.com          | true              |
    Given the following projects exist:
      | title         | description           | status   | author |
      | hello world   | greetings earthlings  | active   | Alice  |
      | hello mars    | greetings aliens      | active   | John   |
  
  Scenario: when a person joins project an email is sent to project creator
    Given I am logged in as "John"
    And I go to the "hello world" project "show" page
    When I click "Join Project"
    Then "alicejones@hotmail.com" should receive a "John Doe just joined hello world project" email

  Scenario: Notification should not be sent to project creator if they disable site emails
    Given I am logged in as "Bryan"
    And I go to the "hello mars" project "show" page
    When I click "Join Project"
    Then "john@doe.com" should not receive a "Bryan Yap just joined hello mars project" email
