@vcr
Feature: Add current_user options to navbar
  "As site developer
  In order to enhance user experience
  I want to add options available for the current user to the navigation bar"

  Scenario: render user info in header
    Given I am logged in as user with email "thomas@agileventures.org", with password "12345678"
    And I am on the "home" page
    And I see a navigation header
    Then I should see my name
    And I should see "1" avatars