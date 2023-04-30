@vcr
Feature: Sign in
  As an existing User
  So that I can use the systems all functions
  I want to be able to login

  Scenario: User is not signed up
    Given I do not exist as a user
    When I sign in with valid credentials
    Then I see an invalid login message
    And I should be signed out

  Scenario: User signs in successfully
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I return to the site
    Then I should be signed in
    And I should not see a sign up link

  Scenario Outline: User enters wrong credentials
    Given I exist as a user
    And I am not logged in
    When I sign in with a wrong <credential>
    Then I see an invalid login message
    And I should be signed out
    Examples:
      |credential|
      |password  |
      |email     |

  Scenario: redirect to the last visited page after login
    Given I exist as a user
    And I am logged in
    And I am not logged in
    And I am on Events index page
    When I sign in with valid credentials
    Then I should be on the Events "Index" page

  # @omniauth
  # Scenario: User is deactivated
  #   Given I exist as a user signed up via google
  #   And I am not logged in
  #   And I have deactivated my account
  #   And I am on the "Sign in" page
  #   And I click "Google"
  #   Then I see a user deactivated message
  #   And I should be signed out
