@javascript
Feature: As a site owner
  So I can make collaboration among registered users easier
  I would like to display a index of users with links to user profiles
  And allow users to search for other users using a variety of criterias

  Background:
    Given I am on the "home" page
    And the following projects exist:
      | title         | description             | status   |
      | hello world   | greetings earthlings    | active   |
      | hello mars    | greetings aliens        | inactive |
      | hello jupiter | greetings jupiter folks | active   |
      | hello mercury | greetings mercury folks | inactive |
      | hello saturn  | greetings saturn folks  | active   |
      | hello sun     | greetings sun folks     | active   |
    And there are no videos
    And the following active users exist
      | first_name | last_name | email                   | projects     | latitude | longitude | updated_at    |
      | Alice      | Jones     | alice@btinternet.co.uk  | hello world  | 59.33    | 18.06     | 1.minute.ago  |
      | Bob        | Butcher   | bobb112@hotmail.com     | hello world  | 59.33    | 18.06     | 5.minutes.ago |
      |            | Croutch   | c.croutch@enterprise.us | hello saturn | -29.15   | 27.74     | 1.hour.ago    |
      | Dave       |           | dave@dixons.me          | hello sun    | 22.57    | 88.36     | 3.days.ago    |
    And I am logged in as "Tester"

  Scenario: Having All Users page
    When I click "Members" within the navbar
    Then I should be on the "our members" page
    And I should see:
      | Tester Person |
      | Alice Jones   |
      | Bob Butcher   |
      | Croutch       |
      | Dave          |
    And I should see "5" user avatars within the main content
    And I should see "Check out our 5 awesome volunteers from all over the globe!"

  Scenario: Filtering trough users by typing first name in the field 
    When I click "Members" within the navbar
    And I filter users for "Alice"
    Then I should see "Alice"
    And I should not see:
    | Bob     |
    | Croutch |
    | Dave    |

  Scenario: Filtering by project involvement
    Given I am on the "our members" page
    When I filter "projects" for "hello world"
    Then I should see:
    | Alice |
    | Bob   |
    And I should not see:
    | Croutch |
    | Dave    |

  Scenario: Find users close to my timezone area
    Given I am on the "our members" page
    When I filter "timezones" for "Close To My Timezone Area"
    Then I should see:
    | Alice |
    | Bob   |
    And I should not see:
    | Croutch |
    | Dave    |

  Scenario: Find users close and wider timezone area
    Given I am on the "our members" page
    When I filter "timezones" for "Wider Timezone Area"
    Then I should see:
    | Alice   |
    | Bob     |
    | Croutch |
    And I should not see "Dave"

  Scenario: Find users who have been online recently
    Given I am on the "our members" page
    When I filter "online status" for "Recently Online"
    Then I should see:
    | Alice |
    | Bob   |
    And I should not see:
    | Croutch |
    | Dave    |
