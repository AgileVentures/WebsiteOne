@vcr
Feature: Create projects
  As a member of AgileVentures
  So that I can create a focal point for an AgileVentures project
  I would like to create a new project profile

  Scenario: Show New Project button if user is logged in
    When I am logged in
    And I am on the "projects" page
    Then I should see the very stylish "New Project" button

  Scenario: Do not show New Project button if user is not logged in
    Given I am not logged in
    When I am on the "projects" page
    Then I should not see the very stylish "New Project" button

  Scenario: Creating a new project
    Given I am logged in
    And I am on the "projects" page
    When I click the very stylish "New Project" button
    Then I should see "Creating a new Project"
    And I should see a form with:
      | Field                |
      | Title                |
      | Description          |
      | Status               |
      | GitHub url (primary) |
      | Issue Tracker link   |

  Scenario Outline: Saving a new project: success
    Given I am logged in
    And I am on the "Projects" page
    When I click the very stylish "New Project" button
    When I fill in "Title" with "<title>"
    And I fill in "Description" with "<description>"
    And I fill in "GitHub url (primary)" with "<gh_link>"
    And I fill in "Issue Tracker link" with "<pt_link>"
    And I select "Status" to "Active"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "<title>"
    And I should see "Project was successfully created."
    And I should see:
      | Text          |
      | <title>       |
      | <description> |
      | ACTIVE        |
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

  @javascript
  Scenario: Saving a new project with multiple repositories: success
    Given I am logged in
    And I am on the "Projects" page
    When I click the very stylish "New Project" button
    When I fill in "Title" with "multiple repo project"
    And I fill in "Description" with "has lots of code"
    And I fill in "GitHub url (primary)" with "http://www.github.com/new"
    And I click "Add more repos"
    Then I should see "GitHub url (2)"
    And I fill in "GitHub url (2)" with "http://www.github.com/new2"
    And I fill in "Issue Tracker link" with "http://www.waffle.com/new"
    And I select "Status" to "Active"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "multiple repo project"
    And I should see "Project was successfully created."
    And I should see:
      | Text                  |
      | multiple repo project |
      | has lots of code      |
      | ACTIVE                |
    And I should see a link to "multiple repo project" on github
    And I should see a link to "multiple repo project" on Pivotal Tracker

