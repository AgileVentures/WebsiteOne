#TODO YA consider refactoring multiple steps of "I should see a button",
#into plural version of "I should see buttons"

Feature: Create and maintain projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to add a new project

  Background:
    Given the following projects exist:
      | title       | description          | status   |
      | hello world | greetings earthlings | active   |
      | hello mars  | greetings aliens     | inactive |

#  Scenarios for Index page

  #TODO YA consider refactoring to a higher level scenarios and move low-level into view specs
  Scenario: List of projects in table layout
    Given  I am on the "home" page

    When I follow "Our projects"

    Then I should see "List of Projects"
    And I should see "Title"
    And I should see "Description"
    And I should see "Created"
    And I should see "Status"

  Scenario: Columns in projects table
    When I go to the "projects" page

    Then I should see a "List of Projects" table
    And I should see column "Title"
    And I should see column "Description"
    And I should see column "Status"
    And I should see column "Created"

  #TODO YA consider refactoring to use a table
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

#TODO YA Consider refactoring happy and sad scenarios into one scenario outline
  Scenario: Show New Project button if user is logged in
    When I am logged in
    And I am on the "projects" page
    Then I should see button "New Project"

  Scenario: Do not show New Project button if user is not logged in
    Given I am not logged in
    When I am on the "projects" page
    Then I should not see button "New Project"

  Scenario: Display Show, edit, delete buttons in projects table
    Given I am logged in
    When I go to the "projects" page
    Then I should see a "List of Projects" table
    And I should see button "Show"
    And I should see button "Edit"
    And I should see button "Destroy"

  Scenario: Do not display Show, edit, delete buttons in projects table when not logged in
    Given I am not logged in
    When I go to the "projects" page
    Then I should see a "List of Projects" table
    And I should not see button "Show"
    And I should not see button "Edit"
    And I should not see button "Destroy"

#  Scenarios for New page

  Scenario: Creating a new project
    Given I am logged in
    And I am on the "projects" page
    And I follow "New Project"

    Then I should see a form for "creating a new project"

#  Scenarios for Show page

  Scenario: opens "Show" page with projects details
    Given I am logged in
    And I am on the "Projects" page

    When I click the "Show" button for project "hello world"
    Then I should see:
    | Text                  |
    | hello world           |
    | greetings earthlings  |
    | active                |

  Scenario: Show page has a return link
    Given I am on the "Show" page for project "hello mars"
    When I click the "Back" button
    Then I should be on the "projects" page

#  Scenarios for Edit page

  Scenario: Edit page exists
    Given I am logged in
    And I am on the "projects" page
    When I click the "Edit" button for project "hello mars"
    Then I am on the "Edit" page for project "hello mars"
    And I should see button "Submit"

  Scenario: Edit page has a return link
    Given I am on the "Edit" page for project "hello mars"
    When I click the "Back" button
    Then I should be on the "projects" page

  Scenario: Updating a project
    Given I am logged in
    And I am on the "projects" page
    When I click the "Edit" button for project "hello mars"

    And I fill in "Description" with "Hello, Uranus!"
    And I click the "Submit" button

    Then I should be on the "projects" page
    And I should see "Project was successfully updated."
    And I should see "Hello, Uranus!"

#  Scenarios for Save action

  Scenario: Saving a project: show successful message
    Given I am logged in
    And I am on the "projects" page
    And I follow "New Project"

    When I fill in "Title" with "Title 1"
    And I fill in "Description" with "Description 1"
    And I fill in "Status" with "Status 1"
    And I click the "Submit" button

    Then I should be on the "projects" page
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

  #  Scenarios for Destroy action

  Scenario: Destroying a project: successful
    Given I am logged in
    And I am on the "projects" page

    When I click the "Destroy" button for project "hello mars"

    Then I should be on the "projects" page
    And I should see "Project was successfully deleted."

  #TODO YA move into controller spec
  Scenario: Requesting action for non-existing project
    Given I am logged in
    And I am on the "projects" page

    When I click the "Edit" button for project "Non-existent"

    Then I should be on the "projects" page
    And I should see "Project not found."


