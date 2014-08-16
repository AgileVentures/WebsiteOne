@javascript
Feature: Add in-page links for projects show page to open the tabbed contents
  As a user
  So that I may share a link directly to a tabbed page
  I would like the url to reflect the current tab contents in the page
 
  Background:
    Given the following projects exist:
      | title         | description             | status   |
      | hello world   | greetings earthlings    | active   |
    And there are no videos

  Scenario: Share the link to documents tab
    When I am on the "Show" page for project "hello world"
    And I click "Documents"
    And I refresh the page
    Then I should see "documents" tab is active

  Scenario: Share the link to members tab
    When I am on the "Show" page for project "hello world"
    And I click "Members" within the main content
    And I refresh the page
    Then I should see "members" tab is active

  Scenario: Share the link to videos tab
    When I am on the "Show" page for project "hello world"
    And I click "Videos"
    And I refresh the page
    Then I should see "videos" tab is active

