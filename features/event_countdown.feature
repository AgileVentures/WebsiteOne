Feature: Events
  As the site administrator
  In order to help my members plan their time
  And in order to increase the attendance in scrums (published on G+ api)
  I want to display a countdown to the next AV Scrum on the home page

  As a site user
  in order to be able to plan my time
  I want to see a countdown to the next AV scrum

  Pivotal Tracker: https://www.pivotaltracker.com/story/show/64299418


  Background:
    Given following events exist:
      | name       | description             | category        | event_date | start_time              | end_time                | repeats | time_zone                  |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 | 2000-01-01 07:00:00 UTC | 2000-01-01 09:30:00 UTC | never   | London                     |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/07 | 2000-01-01 10:00:00 UTC | 2000-01-01 10:15:00 UTC | never   | Eastern Time (US & Canada) |

  @time-travel-step
  Scenario: Render Next Scrum info on landing page
    Given the date is "2014/02/01 09:15:00 UTC"
    And I am on the home page
    Then I should see "Scrum"
    And the next event should be in:
      | period | interval |
      | 1      | days     |
      | 21     | hours    |
      | 45     | minutes  |

  @time-travel-step
  Scenario: Do not render '0 days'
    Given the date is "2014/02/02 09:15:00 UTC"
    And I am on the home page
    Then I should see "Scrum"
    And the next event should be in:
      | period | interval |
      | 21     | hours    |
      | 45     | minutes  |
    And I should not see "0 days"

  @time-travel-step
  Scenario: Do not render '-1 hour'
    Given the date is "2014/02/02 07:50:00 UTC"
    And I am on the home page
    Then I should see "Scrum"
    And the next event should be in:
      | period | interval |
      | 23     | hours    |
      | 10     | minutes  |
    And I should not see "0 days"