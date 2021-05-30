@vcr
Feature: Password retrieval
  "As an existing User
  So that I can recover a lost password
  I want to be able to ask that system for a new password"

  Background:
    Given the following users exist
      | first_name | last_name | email                  | github_profile_url         |
      | Alice      | Jones     | alice@btinternet.co.uk | http://github.com/AliceSky |
    And the email queue is clear
    And I am not logged in
    When I go to the "Sign In" page
    And I click "Forgot your password?"

  Scenario: Retrieving password for existing user
    When I fill in "user_email" with "alice@btinternet.co.uk"
    And I click "Send me reset password instructions"
    Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."
    And I should receive a "Reset password instructions" email
    When I click on the retrieve password link in the last email
    Then I should be on the "password reset" page for "alice@btinternet.co.uk"
    And I fill in "user_password" with "12345678"
    And I fill in "user_password_confirmation" with "12345678"
    And I click "Change my password"
    Then I should be on the "getting started" page
    And I should see "Your password was changed successfully. You are now signed in."

  Scenario: Retrieve password for a non-existent user
    When I fill in "user_email" with "non-existent_user@example.com"
    And I click "Send me reset password instructions"
    And I should see "Email is not registered"
    And I should not receive an email