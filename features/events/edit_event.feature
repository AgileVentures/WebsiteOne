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


Scenario: Updating an event defaults to correct project
  Given I visit the edit page for the event named "Scrum"
  Then no project is selected in the event project dropdown
  When I click the "Save" button
  Then I should be on the event "Show" page for "Daily Standup"
  And the event named "Scrum" is not associated with any project
