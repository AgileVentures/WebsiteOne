Feature: Create and maintain projects
  In order to manage my account settings
  As I user I would like to have a "My account" page
  And I would like to be able to edit change my credentials

  Background:
    Given I am logged in as user with name "Bob", email "current@email.com", with password "12345678"
    And I am on the "home" page

  Scenario: Having My account page
    Given I am on my "Edit Profile" page
    Then I should see "Account details"
    And I should see a form "Account details" with:
      | Field                 |                     |
      | First name            |                     |
      | Last name             |                     |
      | Email                 | current@email.com   |

  @javascript
  Scenario: Editing details: successful
    Given I am on my "Edit Profile" page
    And I fill in "Account details":
      | Field                 | Text      |
      | First name            | John      |
      | Last name             | Doe       |
      | Email                 | a@a.com   |
    When I click the "Update" button
    Then I should be on the "user profile" page for "John"
    And I should see "You updated your account successfully."

  @javascript
  Scenario: Editing details: successful
    Given I am on my "Edit Profile" page
    And I fill in "Account details":
      | Field                 | Text      |
      | First name            | John      |
      | Last name             | Doe       |
      | Email                 |           |
    When I click the "Update" button
    Then I should see "Email can't be blank"

  #   @javascript @webkit
  #   Scenario: Cancel my account
  #     Given I am on my "Edit Profile" page
  #     When I click "Cancel my account"
  #     And I accept the warning popup
  #     Then I should be on the "home" page
  #     And I should see "Your account was successfully cancelled."
  #     And my account should be deleted

  @omniauth
  Scenario: Link my GitHub profile link to my profile
    Given I have a GitHub profile with username "tochman"
    And I am on my "Edit Profile" page
    When I click "GitHub"
    And my profile should be updated with my GH username
    When I am on "profile" page for user "me"
    Then I should see a link "tochman" to "https://github.com/tochman"

  Scenario: Deleting my profile
    Given the following projects exist:
      | title       | description          | status   | author |
      | hello world | greetings earthlings | active   | Bob    |
    And the following documents exist:
      | title         | body             | project     |
      | Documentation | My documentation | hello world |
    When I delete my profile
    And I am on the "Show" page for project "hello world"
    Then I should see "by Anonymous"
