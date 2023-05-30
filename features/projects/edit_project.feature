@vcr
Feature: Edit Project
  As a member of AgileVentures
  So that I can show our project in the best light
  I would like to update a project

  Background:

    Given the following users exist
      | first_name | last_name | email            | admin |
      | Thomas     | Admin     | thomas@admin.com | true  |
    Given the following projects exist:
      | title         | description             | author | pitch       | status   | github_url                                  | pivotaltracker_url                               | commit_count |
      | hello world   | greetings earthlings    | Thomas |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 | 2795         |
      | hello mars    | greetings aliens        | Thomas |             | inactive |                                             |                                                  | 2000         |
      | hello jupiter | greetings jupiter folks |        |             | active   |                                             | https://jira.atlassian.com/projects/CONFEXT      | 2000         |
      | hello mercury | greetings mercury folks |        |             | inactive |                                             |                                                  | 1900         |
      | hello saturn  | greetings saturn folks  |        | My pitch... | active   |                                             |                                                  | 1900         |
      | hello sun     | greetings sun folks     |        |             | active   |                                             |                                                  |              |
      | hello venus   | greetings venus folks   |        |             | active   |                                             |                                                  |              |
      | hello terra   | greetings terra folks   |        |             | active   |                                             |                                                  |              |
      | hello pluto   | greetings pluto folks   |        |             | inactive |                                             |                                                  | 2000         |

    And there are no videos
    And I am logged in as "Thomas"

  Scenario: Edit page has a link to upload an image
    And I am on the "Edit" page for projects "hello mars"
    Then I should see link "imgur.com/upload" with "https://imgur.com/upload"

  @javascript
  Scenario: Existing project with multiple repos shows them correctly in edit form
    And that project "hello world" has an extra repository "https://github.com/AgileVentures/WebsiteOne"
    When I am on the "Edit" page for projects "hello world"
    Then I should see "GitHub url"
    # And I should see "GitHub url (2)"

  Scenario: Edit page has a return link
    And I am on the "Edit" page for projects "hello mars"
    When I click "Back"
    Then I should be on the "Show" page for project "hello mars"

  @javascript
  Scenario: Updating a project: success
    And I am on the "Edit" page for project "hello mars"
    And I fill in "Description" with "Hello, Uranus!"
    And I click "Add more repos"
    And I fill in "GitHub url" with "https://github.com/google/instant-hangouts"
    And I click "Add more trackers"
    And I fill in "Issue Tracker" with "https://www.pivotaltracker.com/s/projects/853345"
    And The project has no stories on Pivotal Tracker
    And I fill in "Slack channel name" with "slackin"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "hello mars"
    And I should see a success flash "Project was successfully updated."
    And I should see "Hello, Uranus!"
    And I should see a link to "hello mars" on github
    And I should see a link "hello mars" that connects to the issue tracker's url
    And I should see a link "hello mars" that connects to the "slack_channel"

  Scenario: Saving a project: failure
    And I am on the "Edit" page for project "hello mars"
    When I fill in "Title" with ""
    And I click the "Submit" button
    Then I should see "Project was not updated."

  @javascript
  Scenario: Update GitHub url if valid
    And I am on the "Edit" page for project "hello mars"
    And I click "Add more repos"
    And I fill in "GitHub url" with "https://github.com/google/instant-hangouts"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "hello mars"
    And I should see a link to "hello mars" on github

  @javascript
  Scenario: Update Issue Tracker url if valid pivotal tracker link
    And I am on the "Edit" page for project "hello mars"
    And I click "Add more trackers"
    And I fill in "Issue Tracker" with "https://www.pivotaltracker.com/s/projects/853345"
    And The project has no stories on Pivotal Tracker
    And I click the "Submit" button
    Then I should be on the "Show" page for project "hello mars"
    And I should see a link "hello mars" that connects to the issue tracker's url

  # @javascript
  # Scenario: Reject GitHub url update if invalid
  #   And I am on the "Edit" page for project "hello mars"
  #   And I click "Add more repos"
  #   And I fill in "GitHub url" with "https:/github.com/google/instant-hangouts"
  #   And I click the "Submit" button
  #   Then I should see "Project was not updated."
