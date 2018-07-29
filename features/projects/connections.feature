Feature: Projects should show links to the connected APIs
  As a User
  So that I can easily navigate to Project apps
  I want see a link on the show page

  Background:
    Given the following users exist
      | first_name | last_name | email            | receive_mailings  |
      | Bill       | Bob       | Bill@example.com | true              |

    Given the following projects exist:
      | title | description | status   | author | pivotaltracker_url                               | github_url               | slack_channel_name |
      | hello | earthlings  | active   | Bill   | https://www.pivotaltracker.com/n/projects/742821 | https://github.com/hello | hello_earthlings   |

  Scenario: I can click a link to the GitHub project page
    When I go to the "hello" project "show" page
    Then I should see "hello on GitHub"
    And I should see a link to "hello" on github

  Scenario: I can click a link to the projects issue tracker
    When I go to the "hello" project "show" page
    Then I should see "hello on IssueTracker"
    And I should see a link to "hello" on Pivotal Tracker

  Scenario: I can click a link to the projects slack channel
    When I go to the "hello" project "show" page
    Then I should see "hello on Slack"
    And I should see a link to the slack channel for "hello"
