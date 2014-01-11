Feature: Create and maintain projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to add a new project

Background:
#TODO YA create specific projects from a table
  Given There are projects in the database

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
  And I am logged in

  When I go to the "projects" page

  Then I should see a "List of Projects" table
  And I should see button "Show"
  And I should see button "Edit"
  And I should see button "Destroy"

Scenario: Creating a new project
  Given I am logged in
  And I am on the "projects" page
  And I follow "New Project"
  Then show me the page
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




