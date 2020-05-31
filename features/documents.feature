@vcr
Feature: Manage Document
  As a project member
  So that I can share my work related to a project
  I would like to be able to create and edit new documents

  Background:
    Given the following projects exist:
      | title       | description          | status   |
      | hello world | greetings earthlings | active   |
      | hello mars  | greetings aliens     | inactive |

    And the following documents exist:
      | title         | body             | project     |
      | Guides        | My guide to      | hello mars  |
      | Documentation | My documentation | hello world |

    And the following revisions exist
      | title         | revisions  |
      | Guides        | 1          |
      | Documentation | 3          |
    And there are no videos

  Scenario: Render of list documents
    Given I am on the "Show" page for project "hello world"
    And I should see "Documentation"
    And I should not see "Howto 2"
    And I should not see "Another doc"
    And I should not see the document "Guides"

  Scenario: Show a document
    Given I am on the "Show" page for project "hello world"
    When I click the sidebar link "Documentation"
    Then I should be on the "Show" page for document "Documentation"
    And I should see "Documentation"
    And I should see "New content 2"


  Scenario: A document can have children
    Given the document "Guides" has a child document with title "Howto"
    Given I am on the "Show" page for document "Guides"
    Then I should see "Howto"
    When I click "Howto"
    Then I should be on the "Show" page for document "Howto"
    And I should see "Guides"

#NOTE: below scenario is for children's documents of documents, not projects'

  Scenario: Documents children should be sorted by create date (newest first)
    Given the document "Guides" has a sub-document with title "SubDoc1" created 3 days ago
    Given the document "Guides" has a sub-document with title "SubDoc2" created 10 days ago
    Given I am on the "Show" page for document "Guides"
    Then I should see the sub-documents in this order:
      | SubDoc1 |
      | SubDoc2 |

