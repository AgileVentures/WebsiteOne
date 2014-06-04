@scrum_query
Feature: Scrums Index
  As a developer
  So that I can get up to speed on Agile Ventures
  I would like to be able to see a list of previous scrums

  Scenario: Scrums index page renders a timeline of scrums for users to view in descending order
    Given I visit "/scrums/index" page
    Then I should see 20 scrums in descending order by published date:

  @javascript
  Scenario: Clicking on the video should bring up a modal YouTube player window
    Given I visit "/scrums/index" page
    Then I should not see a modal window
    And I click a scrum in timeline
    Then I should see a modal window with title "AgileVenture EuroScrum and Pair Hookup and Open Pairing Session"
    #And I click play to watch video

  @javascript
  Scenario: Closing an existing video and opening a new one should update the player
   Given I am playing a video
   When I stop the video
   And I click a new video in timeline
   Then the modal window should update to the selected video



