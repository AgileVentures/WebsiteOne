@focus
Feature: Manage Document
  As a project member
  So that I can share my work related to a project
  I would like to be able to create and edit new documents

Background:
  Given the following projects exist:
    | title       | description          | status   | id |
    | hello world | greetings earthlings | active   | 1  |
    | hello mars  | greetings aliens     | inactive | 2  |

  And the following documents exist:
    | title         | body             | project_id |
    | Howto         | How to start     |          1 |
    | Documentation | My documentation |          1 |
    | Another doc   | My content       |          2 |
    | Howto 2       | My documentation |          2 |


Scenario: Render of list documents
  Given I am on the "projects" page
  When I click the "Documents" button for project "hello world"
  Then I should be on the "Documents" page for project "hello world"
  And I should see "Howto"
  And I should see "Documentation"
  And I should not see "Another doc"

Scenario: Create a new document
  Given I am logged in
  And I am on the "Documents" page for project "hello world"
  When I click the "New Document" button
  And I fill in "Title" with "New doc title"
  And I fill in "Body" with "Document content"
  And I click the "Create Document" button
  Then I should see "Document was successfully created."

Scenario: Edit a document
  Given I am logged in
  And I am on the "Documents" page for project "hello world"
  When I click the "Edit" button for document "Howto"
  Then I should be on the "Edit" page for document "Howto"
  When I fill in "Title" with "My new title"
  And I fill in "Body" with "New document body"
  And I click the "Update Document" button
  Then I should see "Document was successfully updated."

Scenario: Show a document
  Given I am on the "Documents" page for project "hello world"
  When I click the "Show" button for document "Howto"
  Then I should be on the "Show" page for document "Howto"
  And I should see "Howto"
  And I should see "How to start"
  And I should see a link to "Edit" page for document "Howto"

Scenario: Destroy a document
  Given I am logged in
  And I am on the "Documents" page for project "hello world"
  When I click the "Destroy" button for document "Howto"
  Then I should be on the "Documents" page for project "hello world"
  And I should see "Document was successfully deleted."

Scenario: Has a link to edit a document using the Mercury Editor
  Given I am logged in
  And I am on the "Show" page for document "Howto"
  When I click the "Edit" button
  Then I should be in the Mercury Editor

@javascript
Scenario: Mercury Editor is working
  Given I am on the Mercury Editor for "Show" page for document "Howto"
  Then I should see the editable field "Title" for document "Howto"
  And I should see the editable field "Body" for document "Howto"
