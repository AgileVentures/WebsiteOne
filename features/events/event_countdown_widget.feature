@javascript
Feature: Events page countdown widget
  As the site administrator
  In order to help my members plan their time
  And in order to increase the attendance in scrums (published on G+ api)
  I want to display a countdown to the next AV Scrum on the events page

  As a site user
  in order to be able to plan my time
  I want to see a countdown to the next AV scrum

  Pivotal Tracker: https://www.pivotaltracker.com/story/show/64299418


  Background:
    Given following events exist:
      | name       | description             | category        | start_datetime              | duration                | repeats | time_zone                  |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 07:00:00 UTC | 150 | never   | London                     |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/07 10:00:00 UTC | 15 | never   | Eastern Time (US & Canada) |
      | Scrum 2    | Another scrum           | Scrum           | 2014/02/05 10:00:00 UTC | 15 | never   | Eastern Time (US & Canada) |

  @time-travel-step
  Scenario: Render live Scrum info on events page
    Given the date is "2014/02/03 07:10:00 UTC"
    And I am logged in
    And I am on events index page
    And the window size is wide
    And I should see "Scrum is live"

  @time-travel-step
  Scenario: Render countdown Scrum info on events page
    Given the date is "2014/02/05 09:00:00 UTC"
    And I am logged in
    And I am on events index page
    And the window size is wide
    And I should see "1:00 to Scrum 2"
