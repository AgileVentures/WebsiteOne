@vcr
Feature: Activities View
  As a site user
  In order to find a users activities
  I would like to see a users activities feed

  Background:
    Given I am on the "home" page
    And the following users exist
      | first_name | last_name | email                  | skill_list         |
      | Alice      | Jones     | alicejones@hotmail.com | ruby, rails, rspec |
    And the following projects exist:
      | title      | description        | github_url                                  | status | commit_count |
      | WebsiteTwo | awesome autograder | https://github.com/AgileVentures/WebsiteTwo | active | 1            |
    And the following commit_counts exist:
      | project    | user_email             | commit_count |
      | WebsiteTwo | alicejones@hotmail.com | 500          |
    And I am logged in as user with name "Thomas", email "brett@example.com", with password "12345678"

  @javascript
  Scenario: See how commits contribute to Karma
    Given I am on "profile" page for user "Alice"
    And I should see a "About" tab set to active
    And when I click "Activity"
    Then I should see "WebsiteTwo - 500 commits"
    And I should see "Contributions - 500 total commits x 1 - 500 karma"