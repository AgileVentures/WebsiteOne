@vcr
Feature:
  "As a developer
  So that I may share or retrieve knowledge between the AgileVentures group
  I would like to be able to create, read and update special documents in the guides section"

  Background:
    Given the following articles exist:
      | Title                    | Content                          | Tag List           |
      | Ruby is on Fire          | Fire is fire and sunny           | Ruby, Rails        |
      | Rails is not for trains  | Train `tracks` do not work       | Rails              |
      | JQuery cannot be queried | JQuery moves **towards** the ... | Javascript, JQuery |

  Scenario: There should be a list of articles on the index page
    Given I am on the "Articles" page
    Then I should see "Ruby is on Fire"
    And I should see "Rails is not for trains"
    And I should see "JQuery cannot be queried"

  Scenario: Should be able to visit an article from the article index page
    Given I am on the "Articles" page
    When I click "Ruby is on Fire"
    Then I should be on the "Show" page for article "Ruby is on Fire"

  Scenario: There should be a link to articles filtered by certain tags
    Given I am on the "Articles" page
    Then I should see "Ruby"
    When I click "Ruby" within the sidebar
    Then I should be on the "Articles with Ruby tag" page
    And I should see "Ruby is on Fire"
    And I should not see "Rails is not for trains"
    And I should not see "JQuery cannot be queried"

  Scenario: Should be able to create a new article from the article index page
    Given I have logged in
    When I am on the "Articles" page
    And I click the very stylish "New Article" button
    Then I should see "Create a New Article"
    When I fill in "Title" with "Hello, Uranus!"
    And I fill in "Content" with "**An example of** ``Markdown``"
    And I click the "Create" button
    Then I should see "Hello, Uranus!" within the main content
    And I should see "An example of Markdown"

  Scenario: Should be able to edit an article from the article show page
    Given I have logged in
    And I am on the "Show" page for article "Ruby is on Fire"
    And I click the very stylish "Edit article" button
    Then I should be on the "Edit" page for article "Ruby is on Fire"
    And I fill in "Content" with "**New content** ``New Markdown``"
    And I click the "Update" button
    Then I should be on the "Show" page for article "Ruby is on Fire"
    And I should see "Successfully updated the article"
    And I should see "New content New Markdown"

  @javascript
  Scenario: Should be able to preview an article when editing
    Given I am logged in as user with email "brett@example.com", with password "12345678"
    And I am on the "Show" page for article "Ruby is on Fire"
    And I click the very stylish "Edit article" button
    Then I should be on the "Edit" page for article "Ruby is on Fire"
    And I fill in "Title" with "Thomas is on Fire"
    And I fill in "Content" with "**New content** ``New Markdown``"
    And I click the Preview button
    Then I should see a preview containing:
      | Thomas is on Fire        |
      | New content New Markdown |
