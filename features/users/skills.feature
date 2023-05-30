@vcr
Feature: As a site user
  In order to find a user with a relevant skill
  I would like to see a users self assessed skills set

  Background:
    Given I am on the "home" page
    And the following users exist
      | first_name | last_name | email                  | skill_list         |
      | Alice      | Jones     | alicejones@hotmail.com | ruby, rails, rspec |
      | Bob        | Butcher   | bobb112@hotmail.com    | ruby, c++          |
    And I am logged in as user with name "Thomas", email "brett@example.com", with password "12345678"

  Scenario: Viewing skills
    Given I am on "profile" page for user "Alice"
    And I should see a "About" tab set to active
    And when I click "Skills"
    Then I should see:
      | title |
      | ruby  |
      | rails |
      | rspec |

  # @javascript
  # Scenario: Adding skills to profile
  #   Given I have skills "c++, java, php"
  #   And I am on my "profile" page
  #   And I should see a "About" tab set to active
  #   And when I click "Skills"
  #   Then I should see:
  #     | title |
  #     | c++   |
  #     | java  |
  #     | php   |
  #   Given I click "Edit"
  #   And I add a new skill: "cucumber"
  #   And I click "Update" button
  #   Then I should be on my "profile" page
  #   And when I click "Skills"
  #   Then I should see:
  #     | title    |
  #     | c++      |
  #     | java     |
  #     | php      |
  #     | cucumber |
