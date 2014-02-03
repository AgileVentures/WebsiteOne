Feature: As a site owner
  So I can make collaboration among registered users easier
  I would like to display a index of users with links to user profiles

  Background:
    Given I am logged in 
    And I am on the "home" page
    And the following users exist
      | first_name  | last_name   | email                   | password  |
      | Alice       | Jones       | alice@btinternet.co.uk  | 12345678  |
      | Bob         | Butcher     | bobb112@hotmail.com     | 12345678  |
      |             | Croutch     | c.croutch@enterprise.us | 12345678  |
      | Dave        |             | dave@dixons.me          | 12345678  |

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
    When I click on the avatar for "Alice"
    Then I should be on the "user profile" page for "Alice"
    And I should see the avatar for "Alice"
    And I should see "Alice Jones"
    And I should see "alice@btinternet.co.uk"
