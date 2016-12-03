Feature: Sign off
  As an existing user
  So that I can not use or be seen on the site
  A signed in user
  Should be able to delete/deactivate their account
  
  Scenario: User signs off
    Given I am logged in
    When I sign off
    When I return to the site
    Then I should be signed out
    And I should not exist as a user
