Feature: Omniauth Signup
  As a developer
  So that I can show my interest in projects and get help and support in my professional development
  I want to quickly register using 3rd party connections such as GitHub and Google

  Background:
    Given I am not logged in
    And the following pages exist
      | title           | body                    |
      | Getting Started | Remote Pair Programming |

  @omniauth
  Scenario: User signs up with a GitHub account (without consent)
    Given I am on the "registration" page
    When I click "GitHub"
    Then I should see "Signed in successfully."
    And the page should contain the google adwords conversion code
    And I should be on the "getting started" page
    And I go to my "edit profile" page
    And "receive mailings" should not be checked

 @omniauth
  Scenario: User signs up with a GitHub account (with consent)
    Given I am on the "registration" page
    And I check "user_receive_mailings"
    When I click "GitHub"
    Then I should see "Signed in successfully."
    And the page should contain the google adwords conversion code
    And I should be on the "getting started" page
    And I go to my "edit profile" page
    And "receive mailings" should be checked

  @omniauth
  Scenario: User signs up with a Google account (without consent)
    Given I am on the "registration" page
    When I click "Google"
    Then I should see "Signed in successfully."
    And the page should contain the google adwords conversion code
    And I should be on the "getting started" page
    And I go to my "edit profile" page
    And "receive mailings" should not be checked

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
