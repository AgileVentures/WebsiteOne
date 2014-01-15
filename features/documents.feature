@focus
Feature: Manage Document
  As a project member
  So that I can share my work related to a project
  I would like to be able to create and edit new documents

Background:
  Given the follow documents exist:
    | title         | body             | project_id |
    | Howto         | How to start     |          1 |
    | Documentation | My documentation |          2 |


Scenario: Render of list documents
  Given I am on the "projects" page
  When I click the "documents" button
  Then I should be on the documents page



