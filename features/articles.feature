@vcr
Feature:
  As a developer
  So that I may share or retrieve knowledge between the AgileVentures group
  I would like to be able to create, read and update special documents in the guides section

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

