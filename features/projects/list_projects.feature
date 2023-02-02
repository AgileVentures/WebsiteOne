@vcr
Feature: Browse  projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to see existing projects

  Background:

    Given the following users exist
      | first_name | last_name | email            | admin |
      | Thomas     | Admin     | thomas@admin.com | true  |
    Given the following projects exist:
      | title         | description             | pitch       | status  | github_url                                  | pivotaltracker_url                               | commit_count | last_github_update      |
      | hello world   | greetings earthlings    |             | active  | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 | 2795         | 2000-01-13 09:37:14 UTC |
      | hello mars    | greetings aliens        |             | active  |                                             |                                                  | 2000         | 1999-01-11 09:37:14 UTC |
      | hello jupiter | greetings jupiter folks |             | active  |                                             | https://jira.atlassian.com/projects/CONFEXT      | 2000         | 1999-01-10 09:37:14 UTC |
      | hello mercury | greetings mercury folks |             | active  |                                             |                                                  | 1900         | 1999-01-09 09:37:14 UTC |
      | hello saturn  | greetings saturn folks  | My pitch... | active  |                                             |                                                  | 1900         | 1999-01-09 08:37:14 UTC |
      | hello sun     | greetings sun folks     |             | active  |                                             |                                                  | 1800         | 1999-01-01 09:37:14 UTC |
      | hello venus   | greetings venus folks   |             | inactive  |                                             |                                                  |              | 1999-01-01 09:37:14 UTC |
      | hello terra   | greetings terra folks   |             | active  |                                             |                                                  |              | 1999-01-01 09:37:14 UTC |
      | hello pluto   | greetings pluto folks   |             | pending |                                             |                                                  | 2000         | 1999-01-01 09:37:14 UTC |
      | hello alpha   | greetings alpha folks   |             | active  |                                             |                                                  | 300          | 2000-01-12 09:37:14 UTC |
    And there are no videos

  #  Scenarios for Index page

  Scenario: List of projects in table layout
    Given  I am on the "home" page
    When I follow "Projects" within the navbar
    Then I should see "Projects By Recent Activity"

  Scenario: Columns in projects table
    When I go to the "projects" page
    Then I should see "Projects By Recent Activity" table

  @javascript
  Scenario: Display most recently updated at top "Our Projects" page
    Given I am on the "home" page
    When I follow "Projects" within the navbar
    Then I should see "<title>" and "<last_github_update>" within "project-list":
      | title         | last_github_update |
      | hello world   | 2000-01-13 |
      | hello alpha   | 2000-01-12 |
      | hello mars    | 1999-01-11 |
      | hello mercury | 1999-01-09 |
      | hello jupiter | 1999-01-10 |
      | hello saturn | 1999-01-09 |
      | hello sun    | 1999-01-01 |
      | hello terra  | 1999-01-01 |
#    And I should not see "<title>" and "<last_github_update>" within "project-list":
#      | title        | last_github_update |
#      | hello venus  | 1999-01-01 |

  # Scenario:  Display pending projects
  #   Given I am logged in as "Thomas"
  #   And I am on the "pending projects" page
  #   Then I should see "<title>" within "project-list":
  #     | title       |
  #     | hello pluto |
