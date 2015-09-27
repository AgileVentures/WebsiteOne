@javascript
Feature: Disqus commenting engine
  In order to allow users to learn from discussion on articles and documents
  As a site user
  I would like to have means of commenting on articles and documents

  Background:
    Given Disqus is setup

  Scenario: Disqus comments are shown for Articles
    Given the following articles exist:
      | Title      | Content                | Tag List    |
      | qui a iste | Fire is fire and sunny | Ruby, Rails |
    And article "qui a iste" has comment "Cucumber test comment"

    When I am on the "Show" page for article "qui a iste"
    And I wait up to 3 seconds for Disqus comments to load

    Then I should see "Cucumber test comment" in Disqus section

  Scenario: Disqus comments are shown for Documets
    Given the following projects exist:
      | title       | description          | status   |
      | hello world | greetings earthlings | active   |
    Given the following documents exist:
      | title         | body             | project     |
      | Guides        | My guide to      | hello world  |
    And the document "Guides" has a sub-document with title "deserunt id et" created 3 days ago
    And I am on the "Show" page for document "Guides"
    And document "deserunt id et" has comment "Cucumber test comment"

    When I click "deserunt id et"
    And I wait up to 3 seconds for Disqus comments to load

    Then I should see "Cucumber test comment" in Disqus section
