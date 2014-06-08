@javascript
Feature: Disqus commenting engine
  In order to allow users to learn from discussion on articles and documents
  As a site uesr
  I would like to have means of commenting on articles and documents

  Background:
    Given Disqus is setup

  Scenario: Disqus comments are shown
    Given the following articles exist:
      | Title                    | Content                          | Tag List           |
      | Ruby is on Fire          | Fire is fire and sunny           | Ruby, Rails        |
    And article "Ruby is on Fire" has comment "Cucumber test comment"
    
    When I am on the "Show" page for article "Ruby is on Fire"
    And I wait 3 seconds for Disqus comments to load

    Then I should see "Cucumber test comment" in Disqus section


  Scenario: Disqus comments are shown
    Given the following projects exist:
      | title       | description          | status   |
      | hello world | greetings earthlings | active   |
    Given the following documents exist:
      | title         | body             | project     |
      | Guides        | My guide to      | hello world  |
    And the document "Guides" has a sub-document with title "SubDoc1" created 3 days ago
    And I am on the "Show" page for document "Guides"
    And document "SubDoc1" has comment "Cucumber test comment"

    When I click "SubDoc1"
    And I wait 3 seconds for Disqus comments to load

    Then I should see "Cucumber test comment" in Disqus section
