@vcr
Feature: Browse  projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to see existing projects

  Background:
    Given the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               | commit_count | last_github_update      |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 | 2795         | 2000-01-13 09:37:14 UTC |
      | hello mars    | greetings aliens        |             | active   |                                             |                                                  | 2000         | 1999-01-11 09:37:14 UTC |
      | hello jupiter | greetings jupiter folks |             | active   |                                             | https://jira.atlassian.com/projects/CONFEXT      | 2000         | 1999-01-10 09:37:14 UTC |
      | hello mercury | greetings mercury folks |             | active   |                                             |                                                  | 1900         | 1999-01-09 09:37:14 UTC |
      | hello saturn  | greetings saturn folks  | My pitch... | active   |                                             |                                                  | 1900         | 1999-01-09 08:37:14 UTC |
      | hello sun     | greetings sun folks     |             | active   |                                             |                                                  | 1800         | 1999-01-01 09:37:14 UTC |
      | hello venus   | greetings venus folks   |             | active   |                                             |                                                  |              | 1999-01-01 09:37:14 UTC |
      | hello terra   | greetings terra folks   |             | active   |                                             |                                                  |              | 1999-01-01 09:37:14 UTC |
      | hello pluto   | greetings pluto folks   |             | inactive |                                             |                                                  | 2000         | 1999-01-01 09:37:14 UTC |
      | hello alpha   | greetings alpha folks   |             | active   |                                             |                                                  | 300          | 2000-01-12 09:37:14 UTC |
    And there are no videos

#  Scenarios for Index page

  Scenario: List of projects in table layout
    Given  I am on the "home" page
    When I follow "Projects" within the navbar
    Then I should see "List of Projects"
    Then I should see:
      | Text   |
      | Create |
      | Status |

  Scenario: Columns in projects table
    When I go to the "projects" page
    Then I should see "List of Projects" table

  @javascript
  Scenario: Display most recently updated at top "Our Projects" page paginated
    Given I am on the "home" page
    When I follow "Projects" within the navbar
    Then I should see:
      | greetings alpha folks   |
      | greetings earthlings    |
      | greetings aliens        |
      | greetings jupiter folks |
      | greetings mercury folks |
    And I should not see:
      | greetings saturn folks |
      | greetings sun folks    |
      | greetings venus folks  |
      | greetings terra folks  |
      | greetings pluto folks  |
    When I scroll to the bottom of the page
    Then I should see:
      | greetings saturn folks |
      | greetings sun folks    |
      | greetings venus folks  |
      | greetings terra folks  |
      | greetings pluto folks  |
    And I should not see:
      | greetings alpha folks  |            
    When I scroll to the bottom of the page
    Then I should see:
      | greetings alpha folks  |
