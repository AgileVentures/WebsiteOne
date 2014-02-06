Feature: As a site owner
  So I can make collaboration among registered users easier
  I would like to display a index of users with links to user profiles

  Background:
    Given I am on the "home" page
    And the following users exist
      | first_name  | last_name   | email                   | password  |
      | Alice       | Jones       | alice@btinternet.co.uk  | 12345678  |
      | Bob         | Butcher     | bobb112@hotmail.com     | 12345678  |
      |             | Croutch     | c.croutch@enterprise.us | 12345678  |
      | Dave        |             | dave@dixons.me          | 12345678  |
    And I am logged in as user with email "brett@example.com", with password "12345678"

  Scenario: Having All Users page
    When I click "Our members"
    Then I should be on the "our members" page
    And I should see:
      | Test User    |
      | Alice Jones  |
      | Bob Butcher  |
      | Croutch      |
      | Dave         |
    And I should see "5" user avatars

  Scenario: Having user profile page
    Given I am on the "Our members" page
    And user "Alice" has joined on "01/01/2015"
    When I click on the avatar for "Alice"
    Then I should be on the "user profile" page for "Alice"
    And I should see the avatar for "Alice" at 275 px
    And I should see "Alice Jones"
    And I should see "Joined on: 1st Jan 2015"

  Scenario: Having edit button on the profile page
    Given I am on the "Our members" page
    When I click on the avatar for "brett@example.com"
    Then I should be on the "user profile" page for "brett@example.com"
    And I should see button "Edit"
    And I click the "Edit" button
    And I should be on the "my account" page
