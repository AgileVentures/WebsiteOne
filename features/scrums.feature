@vcr
Feature: Scrums Index
  As a developer
  So that I can get up to speed on Agile Ventures
  I would like to be able to see a list of previous scrums

  Background:
    Given that there are 25 past scrums

  Scenario: Scrums index page renders a timeline of scrums for users to view in descending order
    Given I visit "/scrums"
    Then I should see 20 scrums in descending order by published date:

  @javascript
  Scenario: Clicking on the video should bring up a modal YouTube player window
    Given I visit "/scrums"
    Then I should not see a modal window
    And I click the first scrum in the timeline
    Then I should see a modal window with the first scrum

  @javascript @intermittent-ci-js-fail
  Scenario: Closing an existing video and opening a new one should update the player
    Given I visit "/scrums"
    And I click the first scrum in the timeline
    Then I should see a modal window with the first scrum
    When I close the modal
    And I click the second scrum in the timeline
    Then I should see a modal window with the second scrum