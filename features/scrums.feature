@scrum_query
Feature: Scrums Index
  As a developer
  So that I can get up to speed on Agile Ventures
  I would like to be able to see a list of previous scrums







  Scenario: Scrums index page renders a timeline of scrums for users to view in descending order
    Given I visit "/scrums/index" page
    Then I should see 20 scrums in descending order by published date:


