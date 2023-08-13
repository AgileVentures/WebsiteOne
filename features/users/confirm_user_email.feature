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

    Then a confirmation email should be sent
    Then I should see a confirmation-email-sent message
    And I should see "Signed up successfully."
  
    And I go to the email confirmation link
    Then I should see a successful confirmation message

  Scenario: User signs up successfully with no consent for mailings
    When I sign up with valid user data

    Then a confirmation email should be sent
    Then I should see a confirmation-email-sent message
    And I should see "Signed up successfully."
  
    And I go to the email confirmation link
    Then I should see a successful confirmation message

    And I visit login page
    When I sign in with valid credentials

    Then I should see "Signed in successfully."
    And I should be on the "getting started" page

    And I go to my "edit profile" page
    Then "receive mailings" should not be checked

  Scenario: User signs up successfully giving consent for mailings
    When I sign up with valid user data giving consent
    
    Then a confirmation email should be sent
    Then I should see a confirmation-email-sent message
    And I should see "Signed up successfully."
  
    And I go to the email confirmation link
    Then I should see a successful confirmation message

    And I visit login page
    When I sign in with valid credentials

    Then I should see "Signed in successfully."
    And I should be on the "getting started" page

    And I go to my "edit profile" page
    Then "receive mailings" should be checked
  
  Scenario: User cannot sign in if email unconfirmed
    When I sign up with valid user data giving consent
    
    Then a confirmation email should be sent
    Then I should see a confirmation-email-sent message
    And I should see "Signed up successfully."

    And I visit login page
    When I sign in with valid credentials

    Then I should see confirm-your-account-before-continuing message
    


    @omniauth
  Scenario: User signs up with a GitHub account
    Given I am on the "registration" page
    When I click "GitHub"

    Then a confirmation email should be sent
    And I should see "Signed up successfully."
  
    And I go to the email confirmation link
    Then I should see a successful confirmation message

  
    @omniauth
  Scenario: User signs in with a Confirmed GitHub account
    Given I am on the "registration" page
    When I click "GitHub"

    Then a confirmation email should be sent
    And I should see "Signed up successfully."
  
    And I go to the email confirmation link
    Then I should see a successful confirmation message

    And I visit login page
    When I click "GitHub"

    Then I should see "Signed in successfully."
    And I should be on the "getting started" page