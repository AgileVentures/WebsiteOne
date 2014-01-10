Feature: Create and maintain projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to add a new project

Background:


Scenario: See a list of current projects
  Given  I am on the home page
  When I follow "Our projects"
  Then I should see "List of projects"
  And I should see "Title"
  And I should see "Description"
  And I should see "Created"
  And I should see "Status"
  And I should see a button "Create a new project"

Scenario Outline: Columns in list of projects table
  When I am on the projects page
  Then I should see a "List of Projects" table
  And I should see column <column>
  Examples:
  | column |
  |Title   |
  |Description|
  |Status     |

Scenario Outline: Buttons in list of projects table
  When I am on the projects page
  Then I should see a "List of Projects" table
  And I should see button <button>
Examples:
  | button |
  |Show    |
  |Edit    |
  |Destroy |


