Feature: Create and maintain projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to add a new project

Scenario: See a table of current projects
  Given  I am on the home page
  When I follow "Our projects"
  Then I should see "List of Projects"
  And I should see "Title"
  And I should see "Description"
  And I should see "Created"
  And I should see "Status"

Scenario: See a list of current projects
  Given  I am on the home page
  And There is a project in the database
  When I follow "Our projects"
  Then I should see "Title 1"
  And I should see "Description 1"
  And I should see "Status 1"

Scenario: Show New Project button if user is logged in

#TODO Make an cuc/rspec test for checking if devise functions for logging in are working
  When I am logged in
  And I am on the projects page
  Then I should see a button "New Project"

Scenario Outline: Columns in list of projects table
  When I am on the projects page
  Then I should see a "List of Projects" table
  Then I should see column <column>
  Examples:
  | column |
  |Title   |
  |Description|
  |Status     |
  |Created    |

Scenario Outline: Buttons in list of projects table
  Given There is a project in the database
  And I am logged in
  And I am on the projects page
  Then I should see a "List of Projects" table
  And I should see button <link>
  Examples:
  | link   |
  |Show    |
  |Edit    |
  |Destroy |

