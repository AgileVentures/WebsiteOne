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
    And replies to that email should go to "matt@agileventures.org"

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

  @omniauth
  Scenario: User signs up with a GitHub account
    Given I am on the "registration" page
    When I click "GitHub"
    Then I should see "Signed in successfully."
    And I should see "Signed up successfully."
    And the page should contain the google adwords conversion code
    And I should be on the "getting started" page

  @omniauth
  Scenario: User signs up with a Google account
    Given I am on the "registration" page
    When I click "Google"
    Then I should see "Signed in successfully."
    And the page should contain the google adwords conversion code
    And I should be on the "getting started" page

  @omniauth-without-email
  Scenario: User signs up with a GitHub account having no public email (sad path)
    Given I am on the "registration" page
    When I sign up with GitHub
    Then I should see link for instructions to sign up

  @omniauth-without-email
  Scenario: User signs up with a Google account having no public email (sad path)
    Given I am on the "registration" page
    When I click "Google"
    Then I should see the "google" icon
    Then I should see "Your Gplus account needs to have a public email address for sign up"
    And I should not see "Password can't be blank"
    
  @omniauth
  Scenario: User is deactivated and tries to sign up again with google
    Given I exist as a user signed up via google
    And I am not logged in
    And I have deactivated my account
    And I am on the "registration" page
    And I click "Google"
    Then I see a user deactivated message
    And I should be signed out
  
  @omniauth
  Scenario: User is deactivated and tries to sign up again with email
    Given I exist as a user signed up via google
    And I am not logged in
    And I have deactivated my account
    And I am on the "registration" page
    And I submit "mock@email.com" as username
    And I submit "password" as password
    And I click "Sign up" button
    Then I see a user deactivated message
    And I should be signed out
