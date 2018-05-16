#@vcr
Feature: As a developer
  In order to be able to use the sites features
  I want to register as a user
  https://www.pivotaltracker.com/story/show/63047058

  Background:
    Given I am not logged in
    And the following pages exist
      | title           | body                    |
      | Getting Started | Remote Pair Programming |

  Scenario: Let a visitor register as a site user
    Given I am on the "registration" page
    And I submit "user@example.com" as username
    And I submit "password" as password
    And I click "Sign up" button
    Then I should be on the "getting started" page
    And I should see "Signed up successfully."
    And the page should contain the google adwords conversion code
    And the user "user@example.com" should have karma
    And I should see a successful sign up message
    And I should receive a "Welcome to AgileVentures.org" email
    And replies to that email should go to "info@agileventures.org"

 Scenario: User signs up successfully with no consent for mailings
    When I sign up with valid user data
    Then I should see a successful sign up message
    And I go to my "edit profile" page
    Then "receive mailings" should not be checked

Scenario: User signs up successfully giving consent for mailings
    When I sign up with valid user data giving consent
    Then I should see a successful sign up message
    And I go to my "edit profile" page
    Then "receive mailings" should be checked

  Scenario: User signs up with invalid email
    When I sign up with an invalid email
    Then I should see an invalid email message

  Scenario: User signs up without password
    When I sign up without a password
    Then I should see a missing password message

  Scenario: User signs up without password confirmation
    When I sign up without a password confirmation
    Then I should see a missing password confirmation message

  Scenario: User signs up with mismatched password and confirmation
    When I sign up with a mismatched password confirmation
    Then I should see a mismatched password message
