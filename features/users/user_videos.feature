Feature: As a site owner
  So I can make collaboration among registered users easier
  I would like to display a index of users with links to user profiles

  Background:
    Given I am logged in as user with email "brett@example.com", with password "12345678"
    And the following users exist
      | first_name  | last_name   | email                   | password  |
      | Alice       | Jones       | alice@btinternet.co.uk  | 12345678  |

  Scenario: List of users youtube videos
    Given I am on "profile" page for user "Alice"
    Given user "Alice" has YouTube Channel ID "UCgTOz02neY70sqnk05zNkGA" with some videos in it
    And I should see a list of videos for user "Alice"
