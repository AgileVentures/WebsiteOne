Feature:
  As a developer
  So that I may share or retrieve knowledge between the AgileVentures group
  I would like to be able to create, read and update special documents in the guides section

  Background:
    Given the following articles exist:
      |        Title              |           Content                   |         Tag List        |
      | Ruby is on Fire           | Fire is fire and sunny              |   Ruby, Rails           |
      | Rails is not for trains   | Train `tracks` do not work          |   Rails                 |
      | JQuery cannot be queried  | JQuery moves **towards** the ...    |   Javascript, JQuery    |

  Scenario: There should be a link to the articles page on the Getting Started page
    Given I am on the static "Getting Started" page
    When I click "articles"
    Then I should be on the "Articles" page

  Scenario: There should be a list of articles on the index page
    Given I am on the "Articles" page
    Then I should see "Ruby is on Fire"
    And I should see "Rails is not for trains"
    And I should see "JQuery cannot be queried"

  Scenario: There should be a working link to each project

  Scenario: There should be a link to articles filtered by certain tags

  Scenario: The article show page should contain the article content, title and other metadata