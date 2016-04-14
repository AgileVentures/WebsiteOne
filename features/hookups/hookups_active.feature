@vcr
Feature: Show Active Hookups
  In order to let other members know which hookups are active and available
  As a user
  I would like to view and manage active events

  Background:
    Given I am logged in
    Given the time now is "2014-02-03 09:15:00 UTC"
    Given the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 |
    And following events exist for project "hello world" with active hangouts:
      | name     | description    | category        | start_datetime          | duration | repeats | time_zone |
      | Hookup 0 | hookup meeting | PairProgramming | 2014/02/03 09:00:00 UTC | 90       | never   | UTC       |
      | Hookup 1 | hookup meeting | PairProgramming | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |
      | Scrum 0  | hookup meeting | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |
    When I go to the "Hookups" page

  Scenario: displaying existing active events, but not scrums
    Then I should see "Hookup 0" in table "active_hookups"
    And I should see "Hookup 1" in table "active_hookups"
    And I should not see "Scrum 0"