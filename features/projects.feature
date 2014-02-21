Feature: Create and maintain projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to add a new project

  Background:
    Given the following projects exist:
      | title         | description             | status   |
      | hello world   | greetings earthlings    | active   |
      | hello mars    | greetings aliens        | inactive |
      | hello jupiter | greetings jupiter folks | active   |
      | hello mercury | greetings mercury folks | inactive |
      | hello saturn  | greetings saturn folks  | active   |
      | hello sun     | greetings sun folks     | active   |
#  Scenarios for Index page

  Scenario: List of projects in table layout
    Given  I am on the "home" page
    When I follow "Our projects"
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
    When I follow "Our projects"
    Then I should see:
      | Text                    |
      | hello jupiter           |
      | greetings jupiter folks |
      | ACTIVE                  |
      | hello mars              |
      | greetings aliens        |
      | INACTIVE                |

  Scenario: Show New Project button if user is logged in
    When I am logged in
    And I am on the "projects" page
    Then I should see the very stylish "New Project" button

  Scenario: Do not show New Project button if user is not logged in
    Given I am not logged in
    When I am on the "projects" page
    Then I should not see the very stylish "New Project" button

  Scenario: Alphabetically display pagination in "Our Projects" page
    Given I am on the "home" page
    When I follow "Our projects"
    Then I should see:
      | greetings aliens        |
      | greetings jupiter folks |
      | greetings mercury folks |
      | greetings saturn folks  |
      | greetings sun folks     |
    And I should not see "greetings earthlings"
    When I go to the next page
    Then I should not see:
      | greetings aliens        |
      | greetings jupiter folks |
      | greetings mercury folks |
      | greetings saturn folks  |
      | greetings sun folks     |
    And I should see "greetings earthlings"

#  Scenarios for NEW page

  Scenario: Creating a new project
    Given I am logged in
    And I am on the "projects" page
    When I click the very stylish "New Project" button
    Then I should see "Creating a new Project"
    And I should see a form with:
      | Field       |
      | Title       |
      | Description |
      | Status      |

  Scenario: Saving a new project: success
    Given I am logged in
    And I am on the "Projects" page
    When I click the very stylish "New Project" button
    When I fill in:
      | Field       | Text            |
      | Title       | Title New       |
      | Description | Description New |
    And I select "Status" to "Active"
    And I click the "Submit" button
    Then I should be on the "projects" page
    And I should see "Project was successfully created."
    When I go to the next page
    And I should see:
      | Text            |
      | Title New       |
      | Description New |
      | ACTIVE          |

  Scenario: Saving a new project: failure
    Given I am logged in
    And I am on the "projects" page
    And I click the very stylish "New Project" button
    When I fill in "Title" with ""
    And I click the "Submit" button
    Then I should see "Project was not saved. Please check the input."

# Scenarios for SHOW page
# Refactor this step

  Scenario: opens "Show" page with projects details
    Given I am logged in
    And I am on the "Projects" page
    When I click "hello saturn" in the list of projects
    Then I should see:
      | Text                   |
      | hello saturn           |
      | greetings saturn folks |
      | ACTIVE                 |
    And I should see "Created"

  Scenario: Edit page has a return link
    Given I am logged in
    And I am on the "Edit" page for projects "hello mars"
    When I click "Back"
    Then I should be on the "projects" page

  Scenario: Updating a project: success
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    And I fill in "Description" with "Hello, Uranus!"
    And I click the "Submit" button
    Then I should be on the "projects" page
    And I should see "Project was successfully updated."
    And I should see "Hello, Uranus!"

  Scenario: Saving a project: failure
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    When I fill in "Title" with ""
    And I click the "Submit" button
    Then I should see "Project was not updated."

  Scenario: Project show page renders a list of members
    Given The project "hello world" has 5 members
    And I am on the "Show" page for project "hello world"
    Then I should see "Members (5)"

  # Bryan: Stub the YouTube API calls?
  Scenario: Project show page renders a list of videos
    Given I am on the "Show" page for project "hello mars"
    Then I should see "Videos (0)"
#  Scenarios for DESTROY action commented out until this functionality is needed

#  Scenario: Destroying a project: successful
#    Given I am logged in
#    And I am on the "projects" page
#    When I click the "Destroy" button for project "hello mars"
#    Then I should be on the "projects" page
#    And I should see "Project was successfully deleted."
