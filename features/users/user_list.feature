@javascript
Feature: As a site owner
  So I can make collaboration among registered users easier
  I would like to display a index of users with links to user profiles
  And allow users to search for other users using a variety of criterias

  Background:
    Given I am on the "home" page
    And the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 |
      | hello mars    | greetings aliens        |             | inactive |                                             |                                                  |
      | hello jupiter | greetings jupiter folks |             | active   |                                             |                                                  |
      | hello mercury | greetings mercury folks |             | inactive |                                             |                                                  |
      | hello saturn  | greetings saturn folks  | My pitch... | active   |                                             |                                                  |
      | hello sun     | greetings sun folks     |             | active   |                                             |                                                  |
    And there are no videos
    And the following active users exist
      | first_name | last_name | email                   | projects     |
      | Alice      | Jones     | alice@btinternet.co.uk  | hello world  |
      | Bob        | Butcher   | bobb112@hotmail.com     | hello world  |
      |            | Croutch   | c.croutch@enterprise.us | hello saturn |
      | Dave       |           | dave@dixons.me          | hello sun    |
    And I am logged in as user with email "brett@example.com", with password "12345678"

  Scenario: Having All Users page
    When I click "Members" within the navbar
    Then I should be on the "our members" page
    And I should see:
      | Test User   |
      | Alice Jones |
      | Bob Butcher |
      | Croutch     |
      | Dave        |
    And I should see "5" user avatars within the main content
    And I should see "Check out our 5 awesome volunteers from all over the globe!"

  Scenario: Filtering trough users by typing first name in the field 
    When I click "Members" within the navbar
    And I filter users for "Alice"
    Then I should see "Alice"
    And I should not see "Bob"
    And I should not see "Test"

  Scenario: Searching by project involvement
    Given I am on the "Members" page
    When I filter projects for "hello world"
    Then I should see "Alice"
    And I should see "Bob"
    And I should not see "Gary"
    And I should not see "Dave"
