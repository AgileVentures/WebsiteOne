@vcr
Feature: Profile
  "As a user of the site
  In order to get to know other users
  I want to be able to view a user profile page with information about the user."

  Background:
    Given I am on the "home" page
    And the following users exist
      | first_name | last_name | email                  | github_profile_url         | last_sign_in_ip |
      | Alice      | Jones     | alice@btinternet.co.uk | http://github.com/AliceSky | 127.0.0.1       |
      | Bob        | Butcher   | bobb112@hotmail.com    |                            |                 |
    And the following projects exist:
      | title         | description             | status   |
      | hello world   | greetings earthlings    | active   |
      | hello mars    | greetings aliens        | inactive |
      | hello jupiter | greetings jupiter folks | active   |
      | hello mercury | greetings mercury folks | inactive |
      | hello saturn  | greetings saturn folks  | active   |
      | hello sun     | greetings sun folks     | active   |
    And I am logged in as user with email "brett@example.com", with password "12345678"
    And I am on the "Our members" page

  Scenario: Having user profile page
    When I click on the avatar for "Alice"
    Then I should be on the "user profile" page for "Alice"
    And I should see the avatar for "Alice" at 250 px
    And I should see "Alice Jones"
    And I should see "Sweden"
    And I should see "AliceSky"
    And I should see "Member for"

  Scenario: Having edit button on the profile page
    When I click on the avatar for "brett@example.com" within the main content
    Then I should be on the "user profile" page for "brett@example.com"
    And I should see button "Edit"
    And I click the "Edit" button
    And I should be on the "my account" page

  Scenario: Not seeing an edit button on others profile pages
    When I click on the avatar for "Bob"
    And I should not see button "Edit"

  Scenario: Having a list of followed projects on my profile page
    Given user "Bob" follows projects:
      | title         | description             | status |
      | hello world   | greetings earthlings    | active |
      | hello jupiter | greetings jupiter folks | active |
    When I click the first instance of "Bob Butcher"
    Then I should be on the "user profile" page for "Bob"
    And I should see:
      | title         |
      | hello world   |
      | hello jupiter |
