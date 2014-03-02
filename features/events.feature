Feature: Events

  Background:
    Given following events exist:
      | name           | description             | category        | from_date  | to_date    | is_all_day | from_time               | to_time                 | repeats | time_zone                  |
      | EuroAsia Scrum | Daily scrum meeting     | Scrum           | 2014/02/03 | 2014/02/03 | false      | 2000-01-01 07:00:00 UTC | 2000-01-01 09:30:00 UTC | never   | London                     |
      | PP Session     | Pair programming on WSO | PairProgramming | 2014/02/11 | 2014/02/11 | false      | 2000-01-01 10:00:00 UTC | 2000-01-01 10:15:00 UTC | never   | Eastern Time (US & Canada) |

  Scenario: Show index of events
    Given I am on Events index page
    Then I should see "AgileVentures Events"
    And I should see buttons:
      | All              |
      | Scrum            |
      | Pair Programming |


  Scenario: Render Next Scrum info on landing page
    Given I am logged in
    And I am on the home page
    Then I should see "Scrum"
    And the next event should be in:
      | period | interval |
      | 1      | days     |
      | 21     | hours    |
      | 45     | minutes  |

  Scenario: Create a new event
    Given I am logged in
    And I am on Events index page
    When I click "New Event"
    And I fill in "Name" with "Whatever" within the main content
    And I fill in "Description" with "something else"
    And I click the "Save" button
    Then I should see "Event Created"
    Then I should be on the Events index page

  @javascript
  Scenario: Creating a repeating event
    Given I am logged in
    And I am on Events index page
    When I click "New Event"
    And I fill in "Name" with "Scrum" within the main content
    And I fill in "Description" with "scrum description"
    And I select "Repeats" to "weekly"
    And I check "Monday"
    And I check "Thursday"
    And I click the "Save" button
    Then I should see "Event Created"
    Then I should be on the Events index page
    Then I should see multiple "Scrum" events
