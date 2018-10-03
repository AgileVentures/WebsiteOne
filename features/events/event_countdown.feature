@vcr
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
      | name       | description             | category        | start_datetime          | duration | repeats | time_zone                  |
      | Scrum      | Daily scrum meeting     | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | London                     |
      | PP Session | Pair programming on WSO | PairProgramming | 2014/02/07 10:00:00 UTC | 15       | never   | Eastern Time (US & Canada) |

  @time-travel-step
  Scenario: Render Next Scrum info on landing page
    Given the date is "2014/02/01 09:15:00 UTC"
    And I am on the home page
    Then I should see "Want to learn more? Listen in. Next projects' review meeting in"
    And the next event should be in:
      | period | interval |
      | 1      | day      |
      | 21     | hours    |
      | 45     | minutes  |

  @time-travel-step
  Scenario: Do not render '0 days'
    Given the date is "2014/02/02 09:15:00 UTC"
    And I am on the home page
    Then I should see "Want to learn more? Listen in. Next projects' review meeting in"
    And the next event should be in:
      | period | interval |
      | 21     | hours    |
      | 45     | minutes  |
    And I should not see "0 days"

  @time-travel-step
  Scenario: Do not render '0 hours'
    Given the date is "2014/02/03 06:15:00 UTC"
    And I am on the home page
    Then I should see "Want to learn more? Listen in. Next projects' review meeting in"
    And the next event should be in:
      | period | interval |
      | 45     | minutes  |
    And I should not see "0 days"
    And I should not see "0 hours"

  @time-travel-step
  Scenario: Do not render '-1 hour'
    Given the date is "2014/02/02 07:50:00 UTC"
    And I am on the home page
    Then I should see "Want to learn more? Listen in. Next projects' review meeting in"
    And the next event should be in:
      | period | interval |
      | 23     | hours    |
      | 10     | minutes  |
    And I should not see "0 days"

  @time-travel-step
  Scenario: Proper Event Countdown Pluralization (Singular)
    Given the date is "2014/02/02 06:00:00 UTC"
    And I am on the home page
    Then I should see "1 day"
    And I should not see "1 days"

    Given the date is "2014/02/03 06:00:00 UTC"
    And I am on the home page
    Then I should see "1 hour"
    And I should not see "1 hours"

    Given the date is "2014/02/03 06:58:30 UTC"
    And I am on the home page
    Then I should see "1 minute"
    And I should not see "1 minutes"

  @time-travel-step
  Scenario: Proper Event Countdown Pluralization (Plural)
    Given the date is "2014/02/01 06:00:00 UTC"
    And I am on the home page
    Then I should see "2 days"

    Given the date is "2014/02/03 05:00:00 UTC"
    And I am on the home page
    Then I should see "2 hours"

    Given the date is "2014/02/03 06:57:30 UTC"
    And I am on the home page
    Then I should see "2 minutes"
