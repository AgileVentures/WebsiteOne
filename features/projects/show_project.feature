@vcr
Feature: Display Projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to view an existing project

  Background:
    Given the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               | commit_count |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 | 2795         |
      | hello mars    | greetings aliens        |             | inactive |                                             |                                                  | 2000         |
      | hello jupiter | greetings jupiter folks |             | active   |                                             | https://jira.atlassian.com/projects/CONFEXT      | 2000         |
      | hello mercury | greetings mercury folks |             | inactive |                                             |                                                  | 1900         |
      | hello saturn  | greetings saturn folks  | My pitch... | active   |                                             |                                                  | 1900         |
      | hello sun     | greetings sun folks     |             | active   |                                             |                                                  |              |
      | hello venus   | greetings venus folks   |             | active   |                                             |                                                  |              |
      | hello terra   | greetings terra folks   |             | active   |                                             |                                                  |              |
      | hello pluto   | greetings pluto folks   |             | inactive |                                             |                                                  | 2000         |

    And The projects have no stories on Pivotal Tracker
    And the following source repositories exist:
      | url                               | project   |
      | https://github.com/HelloSun       | hello sun |
      | https://github.com/HelloSunExtras | hello sun |

    And there are no videos

  Scenario: Project show page renders a list of members
    Given The project "hello world" has 10 members
    And I am on the "Show" page for project "hello world"
    Then I should see "Members (10)"
    But I should see 5 member avatars

  Scenario: Project show page has links to github and Pivotal Tracker
    Given I am on the "Show" page for project "hello world"
    And I should see a link to "hello world" on github
    And I should see a link "hello world" that connects to the issue tracker's url

  Scenario: Project show page has links to multiple github repos
    Given I am on the "Show" page for project "hello sun"
    And I should see link "HelloSun"
    And I should see link "HelloSunExtras"

  Scenario: Project show page should not show Meet button for users that not follow the project
    Given I have logged in
    And I am on the "Show" page for project "hello world"
    Then I should not see "Start Google Meet"
