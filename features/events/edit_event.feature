@javascript @vcr
Feature: Editing any event
  As a site user
  So that I can Update any events
  I would like to update the events correctly

Background:
  Given I have logged in
  And the following projects exist:
    | title            | description          | pitch | status   | commit_count |
    | WSO              | greetings earthlings |       | active   | 2795         |
    | EdX              | greetings earthlings |       | active   | 2795         |
    | AAA              | for roadists         |       | active   |              |
    | Inactive Project | Has inactive project |       | inactive |              |
    | Closed Project   | Has closed project   |       | closed   |              |
  And following events exist:
    | name       | description             | category        |  project_id  | start_datetime          | duration     | repeats | time_zone                  |
    | Scrum      | Daily scrum meeting     | Scrum           |              | 2014/02/03 07:00:00 UTC | 150          | never   | London                     |
    | PP Session | Pair programming on WSO | PairProgramming |       2      | 2014/02/07 10:00:00 UTC | 15           | never   | Eastern Time (US & Canada) |
    | Scrum 2    | Another scrum           | Scrum           |       1      | 2014/02/05 10:00:00 UTC | 15           | never   | Eastern Time (US & Canada) |


Scenario: Updating an event not associated with project defaults to correct project
  Given I update an event with no project association without adding a project association
  Then the event should have no project association

Scenario: Updating an event associated with project defaults to correct project
  Given I update an event associated to a given project without changing its project association
  Then the project association for the given event should not change
