@scrum_query
Feature: Scrums Index
  As a developer
  So that I can get up to speed on Agile Ventures
  I would like to be able to see a list of previous scrums

  Scenario: Scrums index page renders a timeline of scrums for users to view in descending order
    Given I visit "/scrums/index" page
    Then I should see 20 scrums in descending order by published date:

  Scenario: Play button should bring up a modal YouTube player window
    Given I visit "/scrums/index" page
    And I play a video


#  Scenario: Video should stop when window is closed
#    Given I visit "/scrums/index" page
#    And I play a video
#    Then I should see a modal window with the video
#    When I close the video window
#    Then the video should stop playing
