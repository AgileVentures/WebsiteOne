@vcr
Feature: Browse and create projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to see existing and create new projects

  Background:
    Given the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               | commit_count | last_github_update |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 | 2795         | 01/12/1999         |
      | hello mars    | greetings aliens        |             | active   |                                             |                                                  | 2000         | 01/11/2000         |
      | hello jupiter | greetings jupiter folks |             | active   |                                             | https://jira.atlassian.com/projects/CONFEXT      | 2000         | 01/10/2000         |
      | hello mercury | greetings mercury folks |             | active   |                                             |                                                  | 1900         | 01/08/2000         |
      | hello saturn  | greetings saturn folks  | My pitch... | active   |                                             |                                                  | 1900         | 01/09/2000         |
      | hello sun     | greetings sun folks     |             | active   |                                             |                                                  | 1800         | 01/01/2000         |
      | hello venus   | greetings venus folks   |             | active   |                                             |                                                  |              | 01/01/2000         |
      | hello terra   | greetings terra folks   |             | active   |                                             |                                                  |              | 01/01/2000         |
      | hello pluto   | greetings pluto folks   |             | inactive |                                             |                                                  | 2000         | 01/01/2000         |

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

  Scenario: See a list of current projects
    Given  I am on the "home" page
    When I follow "Projects" within the navbar
    Then I should see:
      | Text                    |
      | hello world             |
      | hello jupiter           |
      | greetings jupiter folks |
      | hello saturn            |
      | greetings saturn folks  |
      | ACTIVE                  |
    And I should not see:
      | Text     |
      | INACTIVE |

  Scenario: Show New Project button if user is logged in
    When I am logged in
    And I am on the "projects" page
    Then I should see the very stylish "New Project" button

  Scenario: Do not show New Project button if user is not logged in
    Given I am not logged in
    When I am on the "projects" page
    Then I should not see the very stylish "New Project" button

  Scenario: Display most recently updated at top "Our Projects" page paginated
    Given I am on the "home" page
    When I follow "Projects" within the navbar
    Then I should see:
      | greetings aliens        |
      | greetings jupiter folks |
      | greetings mercury folks |
      | greetings saturn folks  |
      | greetings sun folks     |
    When I go to the next page
    Then I should see:
      | greetings earthlings    |
    And I should not see:
      | greetings aliens        |
      | greetings jupiter folks |
      | greetings mercury folks |
      | greetings saturn folks  |
      | greetings sun folks     |

#  Scenarios for NEW page

  Scenario: Creating a new project
    Given I am logged in
    And I am on the "projects" page
    When I click the very stylish "New Project" button
    Then I should see "Creating a new Project"
    And I should see a form with:
      | Field               |
      | Title               |
      | Description         |
      | Status              |
      | GitHub link         |
      | Issue Tracker link |

  Scenario Outline: Saving a new project: success
    Given I am logged in
    And I am on the "Projects" page
    When I click the very stylish "New Project" button
    When I fill in "Title" with "<title>"
    And I fill in "Description" with "<description>"
    And I fill in "GitHub link" with "<gh_link>"
    And I fill in "Issue Tracker link" with "<pt_link>"
    And I select "Status" to "Active"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "<title>"
    And I should see "Project was successfully created."
    And I should see:
      | Text            |
      | <title>         |
      | <description>   |
      | ACTIVE          |
    And I should see a link to "<title>" on github
    And I should see a link to "<title>" on Pivotal Tracker

    Examples:
      | title     | description     | gh_link                   | pt_link                                         |
      | Title Old | Description Old | http://www.github.com/old | http://www.pivotaltracker.com/s/projects/982890 |
      | Title New | Description New | http://www.github.com/new | http://www.pivotaltracker.com/n/projects/982890 |

  Scenario: Saving a new project: failure
    Given I am logged in
    And I am on the "projects" page
    And I click the very stylish "New Project" button
    When I fill in "Title" with ""
    And I click the "Submit" button
    Then I should see "Project was not saved. Please check the input."
