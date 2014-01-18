#TODO YA consider refactoring multiple steps of "I should see a button",
#into plural version of "I should see buttons"

Feature: Create and maintain projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to add a new project

Background:
  Given the following projects exist:
    | title         | description           | status   |
    | hello world   | greetings earthlings  | active   |
    | hello mars    | greetings aliens      | inactive |
    | delete-in-bg! | deleted while in use  | missing  |

Scenario: List of projects in table layout
  Given  I am on the "home" page
  When I follow "Our projects"
  And There are projects in the database
  Then I should see "List of Projects"
  And I should see "Created"
  And I should see "Status"

Scenario: See a list of current projects
  Given  I am on the "home" page
  And There are projects in the database
  When I follow "Our projects"
  And I should see a "Title 1" link
  And I should see "Description 1"
  And I should see "Status 1"
  And I should see a "Title 2" link
  And I should see "Description 2"
  And I should see "Status 2"

#TODO YA Consider refactoring happy and sad scenarios into one scenario outline
Scenario: Show New Project button if user is logged in
  When I am logged in
  And I am on the "projects" page
  Then I should see button "New Project"

Scenario: Do not show New Project button if user is not logged in
  Given I am not logged in
  When I am on the "projects" page
  Then I should not see button "New Project"

Scenario: Columns in projects table
  When I go to the "projects" page
  Then I should see a "List of Projects" table

Scenario: Display Show, edit, delete buttons in projects table
  Given I am logged in
  When I go to the "projects" page
  Then I should see a "List of Projects" table
  And I should see button "Edit"
  And I should see button "Destroy"

Scenario: Do not display edit, delete buttons in projects table when not logged in
  Given I am not logged in
  When I go to the "projects" page
  Then I should see a "List of Projects" table
  And I should not see button "Edit"
  And I should not see button "Destroy"

Scenario: Creating a new project
  Given I am logged in
  And I am on the "projects" page
  And I follow "New Project"
  Then I should see a form for "creating a new project"

Scenario: Edit page exists
  Given I am logged in
  And I am on the "projects" page
  When I click the "Edit" button for project "hello mars"
  Then I am on the "Edit" page for project "hello mars"
  And I should see form button "Submit"

Scenario: Updating a project
  Given I am logged in
  And I am on the "projects" page
  When I click the "Edit" button for project "hello mars"
  And I fill in "Description" with "Hello, Uranus!"
  And I click the "Submit" button
  Then I am redirected to the "projects" page
  And I should see "Project was successfully updated."
  And I should see "Hello, Uranus!"

Scenario: Saving a project: show successful message
  Given I am logged in
  And I am on the "projects" page
  And I follow "New Project"
  When I fill in "Title" with "Title 1"
  And I fill in "Description" with "Description 1"
  And I fill in "Status" with "Status 1"
  And I click the "Submit" button
  Then I am redirected to the "projects" page
  And I should see "Project was successfully created."
  And I should see "Title 1"
  And I should see "Description 1"
  And I should see "Status 1"

Scenario: Saving a project: show error message
  Given I am logged in
  And I am on the "projects" page
  And I follow "New Project"
  When I fill in "Title" with ""
  And I click the "Submit" button
  Then I should see "Project was not saved. Please check the input."

Scenario: Show page has a return link
  Given I am on the "Show" page for project "hello mars"
  When I click the "Back" button
  Then I am redirected to the "projects" page

Scenario: Edit page has a return link
  Given I am logged in
  Given I am on the "Edit" page for project "hello mars"
  When I click the "Back" button
  Then I am redirected to the "projects" page

Scenario: Destroying a project: successful
  Given I am logged in
  And I am on the "projects" page
  When I click the "Destroy" button for project "hello mars"
  Then I am redirected to the "projects" page
  And I should see "Project was successfully deleted."

Scenario: Edit a project which has been deleted after rendering
  Given I am logged in
  And I am on the "projects" page
  When I click the "Edit" button for project "delete-in-bg!"
  Then I am redirected to the "projects" page
  And I should see "Project not found."
