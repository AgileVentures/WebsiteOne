Feature: As a site owner
  So I can make collaboration among registered users easier
  I would like to display a index of users with links to user profiles

  Background:
    Given I am on the "home" page
    And the following users exist
      | first_name | last_name | email                   | password | display_profile |
      | Alice      | Jones     | alice@btinternet.co.uk  | 12345678 | true            |
      | Bob        | Butcher   | bobb112@hotmail.com     | 12345678 | true            |
      |            | Croutch   | c.croutch@enterprise.us | 12345678 | true            |
      | Dave       |           | dave@dixons.me          | 12345678 | true            |
    And I am logged in as user with email "brett@example.com", with password "12345678"

  Scenario: Having All Users page
    When I click "Our members"
    Then I should be on the "our members" page
    And I should see:
      | Test User   |
      | Alice Jones |
      | Bob Butcher |
      | Croutch     |
      | Dave        |
    And I should see "5" user avatars
