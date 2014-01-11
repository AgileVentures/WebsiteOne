Feature: Create and maintain projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to add a new project

Background:
  #TODO set constraint: unique titles?
  Given the follow projects exist:
    | title       | description          | status   | id |
    | hello world | greetings earthlings | active   | 1  |
    | hello mars  | greetings aliens     | inactive | 2  |

Scenario: List of projects in table layout
  Given  I am on the "home" page

  When I follow "Our projects"

  Then I should see "List of Projects"
  And I should see "Title"
  And I should see "Description"
  And I should see "Created"
  And I should see "Status"

Scenario: See a list of current projects
  Given  I am on the "home" page
  And There are projects in the database
  When I follow "Our projects"
  Then I should see "Title 1"
  And I should see "Description 1"
  And I should see "Status 1"
  And I should see "Title 2"
  And I should see "Description 2"
  And I should see "Status 2"

Scenario: Show New Project button if user is logged in
  When I am logged in
  And I am on the "projects" page
  Then I should see a button "New Project"

Scenario: Columns in projects table
  When I go to the "projects" page

  Then I should see a "List of Projects" table
  And I should see column "Title"
  And I should see column "Description"
  And I should see column "Status"
  And I should see column "Created"

Scenario: Show, edit, delete buttons in projects table
  Given I am logged in
  When I go to the "projects" page
  Then I should see a "List of Projects" table
  And I should see button "Show"
  And I should see button "Edit"
  And I should see button "Destroy"

Scenario: Creating a new project
  Given I am logged in
  And I am on the "projects" page
  And I follow "New Project"

  Then I should see a form for "creating a new project"
  And I should see field "Title"
  And I should see field "Description"
  And I should see field "Status"
  And I should see form button "Create"

Scenario: Saving a new project
  Given I am logged in
  And I am on the "projects" page
  And I follow "New Project"
  When I fill in "Title" with "Title 1"
  And I fill in "Description" with "Description 1"
  And I fill in "Status" with "Status 1"
  And I click the "Create" button
  Then I should see "Project was successfully created."


Scenario: Edit page exists
  Given I am logged in
  And I am on the "projects" page
  And I click the first "Edit" button
  Then I should be on the edit page
  And I should see form button "Update Project"

Scenario: Saving project edits at Edit page
  Given I am logged in
  And I am on the "edit" page
  And I fill in "Status" with "undetermined"
  And I click "Update Project"
  Then I should see "undetermined"

Scenario: Destroying a project
  Given I am logged in
  And I am on the "projects" page
  Then the Destroy button works for "hello world"



