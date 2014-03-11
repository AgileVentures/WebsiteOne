@focus
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
    
    And the following sub-documents exist:
      | title   | body         | created_at          | project    |
      | SubDoc1 | Blog One     | created 3 days ago  | hello mars |
      | SubDoc2 | Another Blog | created 10 days ago | hello mars |
    And there are no videos

  Scenario: Render of list documents
    Given I am on the "Show" page for project "hello world"
    And I should see "Documentation"
    And I should not see "Howto 2"
    And I should not see "Another doc"
    And I should not see the document "Guides"

  Scenario: Create a new document
    Given I am logged in
    Given I am on the "Show" page for project "hello world"
    When I click the very stylish "New Document" button
    And I fill in "Title" with "New doc title"
    And I click "Submit"
    Then I should see "Document was successfully created."

  Scenario: Create a new document page should have a back button
    Given I am logged in
    Given I am on the "Show" page for project "hello world"
    When I click the very stylish "New Document" button
    And I click "Back"
    Then I should be on the "Show" page for project "hello world"

  Scenario: Show a document
    Given I am on the "Show" page for project "hello mars"
  #???
    When I click the sidebar link "Guides"
    Then I should be on the "Show" page for document "Guides"
    And I should see "Guides"
    And I should see "New content 0"
    And I should see a link to "Edit" page for document "Guides"


  Scenario: A document can have children
    Given the document "Guides" has a child document with title "Howto"
    Given I am on the "Show" page for document "Guides"
    Then I should see "Howto"
    When I click "Howto"
    Then I should be on the "Show" page for document "Howto"
    And I should see "Guides"

#NOTE: below scenario is for children's documents of documents, not projects'

  # Bryan: DESCENDING means SubDoc1 comes first (the most recent date is greater)
  Scenario: Documents children should be sorted in DESCENDING order by create date
    Given the document "Guides" has a sub-document with title "SubDoc1" created 3 days ago
    Given the document "Guides" has a sub-document with title "SubDoc2" created 10 days ago
    Given I am on the "Show" page for document "Guides"
    Then I should see the sub-documents in this order:
      | SubDoc1 |
      | SubDoc2 |


#Scenario: Destroy a document
#  Given I am logged in
#  Given I am on the "Show" page for project "hello world"
## And I am on the "Documents" page for project "hello world"
#  When I click the "Destroy" button for document "Howto"
#  Then I should be on the "Documents" page for project "hello world"
#  And I should see "Document was successfully deleted."

  Scenario: Has a link to edit a document using the Mercury Editor
    Given the document "Guides" has a child document with title "Howto"
    Given I am logged in
    And I am on the "Show" page for document "Howto"
    When I click the very stylish "Edit" button
    Then I should be in the Mercury Editor

  @javascript @selenium
  Scenario: Mercury editor shows Save and Cancel buttons, hides New Document button,
  Save button works

    Given the document "Guides" has a child document with title "Howto"
    And I am logged in
    And I am using the Mercury Editor to edit document "Howto"
    Then I should see button "Save" in Mercury Editor
    And I should see button "Cancel" in Mercury Editor
    And I should not see button "New document" in Mercury Editor

    When I fill in the editable field "Title" with "My new title"
    And I fill in the editable field "Body" with "This is my new body text"
    And I click "Save" in Mercury Editor
    Then I should see "The document has been successfully updated."
    And I should be on the "Show" page for document "My new title"
    And I should see "This is my new body text"

  @javascript @selenium
  Scenario: Mercury editor Cancel button works

    Given the document "Guides" has a child document with title "Howto"
    And I am logged in
    And I am using the Mercury Editor to edit document "Howto"

    When I fill in the editable field "Title" with "My new title"
    And I click "Cancel" in Mercury Editor
    And I should be on the "Show" page for document "Howto"
    And I should see "Howto"

  Scenario: The Mercury Editor cannot be accessed by non-logged in users
    Given I am on the "Show" page for document "Documentation"
    Then I should not see "Edit"
    And I try to use the Mercury Editor to edit document "Documentation"
    Then I should see "You do not have the right privileges to complete action."

  @javascript @selenium
  Scenario: The Mercury Editor save button works
    Given the document "Guides" has a child document with title "Howto"
    And I am logged in
    And I am using the Mercury Editor to edit document "Howto"
    When I fill in the editable field "Title" with "My new title"
    And I fill in the editable field "Body" with "This is my new body text"
    And I click "Save" within Mercury Editor toolbar
    Then I should see "The document has been successfully updated."
    And I should be on the "Show" page for document "My new title"
    And I should see "This is my new body text"
#  Then I no longer need the Mercury Editor

  Scenario: The Mercury Editor should only work for the documents
    Given I am logged in
    And I visit the site
    When I try to edit the page
    Then I should see "You do not have the right privileges to complete action."
    Given I am on the "Projects" page
    When I try to edit the page
    Then I should see "You do not have the right privileges to complete action."
    Given I am on the "Show" page for project "hello world"
    When I try to edit the page
    Then I should see "You do not have the right privileges to complete action."

  Scenario: Document should have a history of changes 
    Given I am on the "Show" page for document "Documentation"
    Then I should see "Revisions"
    And I should see 4 revisions for "Guides"
