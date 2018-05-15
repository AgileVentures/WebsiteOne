@vcr
Feature: Edit Project
  As a member of AgileVentures
  So that I can show our project in the best light
  I would like to update a project

  Background:
    Given the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               | commit_count |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 | 2795         |
      | hello mars    | greetings aliens        |             | inactive |                                             |                                                  | 2000         |
      | hello jupiter | greetings jupiter folks |             | active   |                                             | https://jira.atlassian.com/projects/CONFEXT      | 2000         |
      | hello mercury | greetings mercury folks |             | inactive |                                             |                                                  | 1900         |
      | hello saturn  | greetings saturn folks  | My pitch... | active   |                                             |                                                  | 1900         |
      | hello sun     | greetings sun folks     |             | active   |                                             |                                                  |              |
      | hello venus   | greetings venus folks   |             | active   |                                             |                                                  |              |
      | hello terra   | greetings terra folks   |             | active   |                                             |                                                  |              |
      | hello pluto   | greetings pluto folks   |             | inactive |                                             |                                                  | 2000         |

    And there are no videos

  @javascript
  Scenario: Existing project with multiple repos shows them correctly in edit form
    Given I am logged in
    And that project "hello world" has an extra repository "https://github.com/AgileVentures/WebsiteOne"
    When I am on the "Edit" page for projects "hello world"
    Then I should see "GitHub url (primary)"
    And I should see "GitHub url (2)"

  Scenario: Edit page has a return link
    Given I am logged in
    And I am on the "Edit" page for projects "hello mars"
    When I click "Back"
    Then I should be on the "Show" page for project "hello mars"

  Scenario: Updating a project: success
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    And I fill in "Description" with "Hello, Uranus!"
    And I fill in "GitHub url (primary)" with "https://github.com/google/instant-hangouts"
    And I fill in "Issue Tracker link" with "https://www.pivotaltracker.com/s/projects/853345"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "hello mars"
    And I should see a success flash "Project was successfully updated."
    And I should see "Hello, Uranus!"
    And I should see a link to "hello mars" on github
    And I should see a link to "hello mars" on Pivotal Tracker

  Scenario: Saving a project: failure
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    When I fill in "Title" with ""
    And I click the "Submit" button
    Then I should see "Project was not updated."

  Scenario: Update GitHub url if valid
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    And I fill in "GitHub url (primary)" with "https://github.com/google/instant-hangouts"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "hello mars"
    And I should see a link to "hello mars" on github

  Scenario: Update Issue Tracker url if valid pivotal tracker link
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    And I fill in "Issue Tracker link" with "https://www.pivotaltracker.com/s/projects/853345"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "hello mars"
    And I should see a link to "hello mars" on Pivotal Tracker

  Scenario: Reject GitHub url update if invalid
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    And I fill in "GitHub url (primary)" with "https:/github.com/google/instant-hangouts"
    And I click the "Submit" button
    Then I should see "Project was not updated."
