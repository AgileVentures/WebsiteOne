Feature: Create and maintain projects
  In order to manage my account settings
  As I user I would like to have a "My account" page
  And I would like to be able to edit change my credentials

  Background:
    Given I am logged in as user with email "current@email.com", with password "12345678"
    And I am on the "home" page

  Scenario: Having My account page
    When I follow "My Account"
    Then I should see a user form for "Editing my user details"
    And the "Email" field should contain "current@email.com"
    And the "Password" field should not contain "12345678"

  Scenario: Editing details: successful
    Given I follow "My Account"
    And I fill in "Email" with "a@a.com"
    And I fill in "Password" with "87654321"
    And I fill in "Password confirmation" with "87654321"
    And I fill in "Current password" with "12345678"

    When I click the "Update" button
    Then I should be on the "home" page
    And I should see "You updated your account successfully."

  Scenario: Editing details: failure
    When I follow "My Account"
    And I fill in "Email" with "new@email.com"
    And I fill in "Password" with "87654321"
    And I fill in "Password confirmation" with "87654321"
    And I fill in "Current password" with "wrong password"

    When I click the "Update" button
    And I should see "There was an error updating your account."
    And I should see "Current password is invalid"





