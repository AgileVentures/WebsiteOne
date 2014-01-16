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
  Then I should be on documents page for "hello world"
  And I should see "Howto"
  And I should see "Documentation"
  And I should not see "Another doc"




