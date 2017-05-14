Feature: User Progress
  As a junior developer
  So that I can level up to mid and senior
  I would like a clear pathway that shows me what to do in what order
  Unlike now where I have to remember how far I have got and what to do next

  https://github.com/AgileVentures/WebsiteOne/issues/1581

  Background:
    Given the following users exist
      | first_name | last_name | email                      | latitude | longitude | updated_at   |
      | Alice      | Jones     | MyEmailAddress@example.com | 59.33    | 18.06     | 1 minute ago |
    Given the following progress tasks exist
      | title            | description                                    | order_num |
      | Connect to Slack | Go to slack.com and create a user if you       | 1         |
      | Join a Channel   | Go to interface and join a channel by clicking | 2         |

  Scenario Outline: User sees all possible unstarted tasks
    Given I am logged in
    And I am on the "getting started" page
    Then I should see "<title>"
    Examples:
      | title            |
      | Connect to Slack |
      | Join a Channel   |

  Scenario: User has completed some tasks then completes and checks off another task

  Scenario: User unchecks a completed task

  Scenario: User wants to see the details of a task


