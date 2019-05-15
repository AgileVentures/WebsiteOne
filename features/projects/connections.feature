Feature: Projects should show links to the connected APIs
  As a User
  So that I can easily navigate to Project apps
  I want to see all connected app links on the show page

  Background:
    Given the following users exist
      | first_name | last_name | email            | receive_mailings |
      | Bill       | Bob       | Bill@example.com | true             |

    Given the following projects exist:
      | title   | description | status | author | pivotaltracker_url                               | github_url               | slack_channel_name |
      | hello   | earthlings  | active | Bill   | https://www.pivotaltracker.com/n/projects/742821 | https://github.com/hello | hello_earthlings   |
      | Bat Man | All bat     | active | Bill   |                                                  |                          |                    |

    Given The project has no stories on Pivotal Tracker

  Scenario Outline: Status message for when a project does not have connections
    When I go to the "show" page for project "<project_name>"
    Then I should not see "<connection_message>"
    And I should see "<connection_link_status>"

    Examples:
      | project_name | connection_message      | connection_link_status     |
      | Bat Man      | Bat Man on GitHub       | not linked to GitHub       |
      | Bat Man      | Bat Man on IssueTracker | not linked to IssueTracker |
      | Bat Man      | Bat Man on Slack        | not linked to Slack        |

  Scenario Outline: Show links for when a project has connections
    When I go to the "show" page for project "hello"
    Then I should see "<text>"
    And I should see a link "hello" that connects to the issue tracker's url

    Examples:
      | text                  | url                |
      | hello on GitHub       | github_url         |
      | hello on IssueTracker | pivotaltracker_url |
      | hello on Slack        | slack_channel      |
