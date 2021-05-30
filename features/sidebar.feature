@vcr
Feature: Sidebar navigation
  "As a user
  So that I may navigate through project documents with ease
  I want to have a sidebar to navigate project documents with"

  Background:
    Given the following projects exist:
      | title       | description          | status   | id |
      | hello world | greetings earthlings | active   | 1  |
      | hello mars  | greetings aliens     | inactive | 2  |
      | hello moon  | greetings moonians   | active   | 3  |
      | hello pluto | greetings plutonians | active   | 4  |

    And the following documents exist:
      | title         | body             | project_id |
      | Howto         | How to start     | 1          |
      | Documentation | My documentation | 1          |
      | Another doc   | My content       | 2          |
      | Howto 2       | My documentation | 2          |
    And there are no videos


  Scenario: Sidebar is visible except on projects index page
    Given I have logged in
    And I am on the "Edit" page for project "hello mars"
    Then I should see the sidebar
    Given I am on the "Show" page for project "hello mars"
    Then I should see the sidebar
    Given I am on the "projects" page
    When I click the very stylish "New Project" button
    Then I should see the sidebar

  Scenario: Sidebar always shows the relevant information
    Given I have logged in
    And I am on the "Show" page for document "Howto 2"
    Then I should see a link to "Show" page for project "hello world" within the sidebar
    And I should see a link to "Show" page for document "Howto" within the sidebar
    And I should see a link to "Show" page for document "Documentation" within the sidebar
    And I should not be able to see a link to "Show" page for project "hello mars" within the sidebar
    And I should not be able to see a link to "Show" page for document "Another doc" within the sidebar
    And I should not be able to see a link to "Show" page for document "Howto 2" within the sidebar

  Scenario: Sidebar projects are organised alphabetically
    Given I am on the "projects" page
    Then I should see "hello moon" before "hello pluto"
    And I should see "hello pluto" before "hello world"
    Given I have logged in
    And I am on the "Edit" page for project "hello mars"
    Then I should see "hello moon" before "hello pluto"
    And I should see "hello pluto" before "hello world"
    Given I am on the "Show" page for project "hello mars"
    Then I should see "hello moon" before "hello pluto"
    And I should see "hello pluto" before "hello world"
