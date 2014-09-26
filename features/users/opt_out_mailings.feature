Feature: As a site user
  In order to opt-out of mailings
  I want to be able to toggle email retrieval settings

  Background:
    Given the following users exist
      | first_name  | last_name   | email                   | receive_mailings  |
      | Alice       | Jones       | alice@btinternet.co.uk  |     false         |
      | Bob         | Butcher     | bobb112@hotmail.com     |     true          |

  Scenario: Receive mailings should be false
    Given I am logged in as "Alice"
    And I am on my "Edit Profile" page
    Then "Receive mailings" should not be checked

  Scenario: Receive mailings should be true by default
    Given I am logged in as "Bob"
    And I am on my "Edit Profile" page
    Then "Receive mailings" should be checked

  @javascript    
  Scenario: A logged in user should be able to toggle mail receival
    Given I am logged in as "Bob"
    And I am on my "Edit Profile" page
    When I set Receive mailings to be false 
    And I click "Update"
    And I am on my "Profile" page 
    And I click "Edit" 
    Then "Receive mailings" should not be checked
    


