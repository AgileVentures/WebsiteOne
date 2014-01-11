Feature: Create and maintain projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to add a new project

Background:
  Given There are projects in the database

Scenario: List of projects in table layout
  Given  I am on the home page

  When I follow "Our projects"

  Then I should see "List of Projects"
  And I should see "Title"
  And I should see "Description"
  And I should see "Created"
  And I should see "Status"

Scenario: See a list of current projects
  Given  I am on the home page
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
  And I am on the projects page
  Then I should see a button "New Project"

#TODO Y Consider using a shorter version below, as there is only one column in the outline
#TODO Y using outlines increases the test output, because the same steps are run for each column/link
#Scenario Outline: Columns in list of projects table
#  When I am on the projects page
#
#  Then I should see a "List of Projects" table
#  And I should see column <column>
#  Examples:
#  | column |
#  |Title   |
#  |Description|
#  |Status     |
#  |Created    |

Scenario: Columns in projects table
  When I go to the projects page

  Then I should see a "List of Projects" table
  And I should see column Title
  And I should see column Description
  And I should see column Status
  And I should see column Created


Scenario: CRUD buttons in projects table
  Given There are projects in the database
  And I am logged in

  When I go to the projects page

  Then I should see a "List of Projects" table
  And I should see button Show
  And I should see button Edit
  And I should see button Destroy

#  Scenario Outline: Buttons in list of projects table
#    Given There are projects in the database
#    And I am logged in
#    And I am on the projects page
#
#    Then I should see a "List of Projects" table
#    And I should see button <link>
#  Examples:
#    | link   |
#    |Show    |
#    |Edit    |
#    |Destroy |
