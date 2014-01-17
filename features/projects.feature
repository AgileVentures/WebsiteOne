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

  #TODO YA consider refactoring to a higher level scenarios and move low-level (headers and columns) into view specs
  Scenario: List of projects in table layout
    Given  I am on the "home" page

    When I follow "Our projects"

    Then I should see "List of Projects"
    Then I should see:
      | Text          |
      | Title         |
      | Create        |
      | Description   |
      | Status        |

  Scenario: Columns in projects table
    When I go to the "projects" page

    Then I should see "List of Projects"
    And I should see column "Title"
    And I should see column "Description"
    And I should see column "Status"
    And I should see column "Created"

  Scenario: See a list of current projects
    Given  I am on the "home" page
    When I follow "Our projects"
    Then I should see:
      | Text                 |
      | hello world          |
      | greetings earthlings |
      | active               |
      | hello mars           |
      | greetings aliens     |
      | inactive             |

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
    And I should see buttons:
      | Button  |
      | Show    |
      | Edit    |
      | Destroy |

  Scenario: Do not display Show, edit, delete buttons in projects table when not logged in
    Given I am not logged in
    When I go to the "projects" page
    Then I should see "List of Projects"
    And I should not see buttons:
      | Button  |
      | Show    |
      | Edit    |
      | Destroy |

#  Scenarios for NEW page

  Scenario: Creating a new project
    Given I am logged in
    And I am on the "projects" page

    When I click "New Project"

    Then I should see "Creating a new Project"
    And I should see a form with:
      | Field        |   |
      | Title        |   |
      | Description  |   |
      | Status       |   |

  Scenario: Saving a new project: success
    Given I am logged in
    And I am on the "projects" page
    And I follow "New Project"

    When I fill in:
      | Field        | Text              |
      | Title        | Title New         |
      | Description  | Description New   |
      | Status       | Status New        |
    And I click the "Submit" button

    Then I should be on the "projects" page
    And I should see:
      | Text              |
      | Title New         |
      | Description New   |
      | Status New        |
    And I should see "Project was successfully created."

  Scenario: Saving a new project: failure
    Given I am logged in
    And I am on the "projects" page
    And I click "New Project"

    When I fill in "Title" with ""
    And I click the "Submit" button

    Then I should see "Project was not saved. Please check the input."

#  Scenarios for SHOW page

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
    When I click "Back"
    Then I should be on the "projects" page

#  Scenarios for EDIT page

  Scenario: opens "Edit" page with projects details
    Given I am logged in
    And I am on the "Projects" page

    When I click the "Edit" button for project "hello world"
    Then I should see a form with:
      | Field        | Text                  |
      | Title        | hello world           |
      | Description  | greetings earthlings  |
      | Status       | active                |

  Scenario: Edit page has a return link
    Given I am on the "Edit" page for project "hello mars"
    When I click "Back"
    Then I should be on the "projects" page

  Scenario: Updating a project: success
    Given I am on the "Edit" page for project "hello mars"

    And I fill in "Description" with "Hello, Uranus!"
    And I click the "Submit" button

    Then I should be on the "projects" page
    And I should see "Project was successfully updated."
    And I should see "Hello, Uranus!"

  Scenario: Saving a project: failure
    Given I am on the "Edit" page for project "hello mars"

    When I fill in "Title" with ""
    And I click the "Submit" button

    Then I should see "Project was not updated."

  #  Scenarios for DESTROY action

  Scenario: Destroying a project: successful
    Given I am logged in
    And I am on the "projects" page

    When I click the "Destroy" button for project "hello mars"

    Then I should be on the "projects" page
    And I should see "Project was successfully deleted."


