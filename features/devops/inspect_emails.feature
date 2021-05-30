@intercept
@wip
Feature: Inspect outgoing emails
  As a developer
  I want to be able to inspect generated emails
  
  Background:
    Given the following users exist
      | first_name | last_name | email                  | receive_mailings  | 
      | Alice      | Jones     | alicejones@hotmail.com | true              | 
      | John       | Doe       | john@doe.com           | true              |
    
    Given the following projects exist:
      | title         | description           | status   | author |
      | hello world   | greetings earthlings  | active   | Alice  |
 
  Scenario: when a person joins project an email is sent to project creator
    When I am logged in as "John"
    And I go to the "hello world" project "show" page
    When I click "Join Project"
    Then "me@ymail.com" should receive a "John Doe just joined hello world project" email
