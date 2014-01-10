Feature: Creating a new project
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to add a new project

Background:
  Given  I am on the home page

Scenario: See a list of current projects
  When I follow "Our projects"
#  title for the table
  Then I should see "List of projects"
  And I should see "Title"
  And I should see "Description"
  And I should see "Created"
  And I should see "Status"

  And I should see a button "Create a new project"