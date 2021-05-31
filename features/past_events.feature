@vcr
Feature: Past Events Index
  "As a developer
  So that I can get up to speed on Agile Ventures
  I would like to be able to see a list of previous scrums"

  Background:
    Given that there are 25 past events

  Scenario: Scrums index page renders a timeline of scrums for users to view in descending order
    Given I visit "/scrums"
    Then I should see "Previous events"
    And I should see 20 scrums in descending order by published date

  Scenario: Videos with nil youtube id do not display youtube embed link
    Given there is one past scrum with invalid youtube id
    And I visit "/scrums"
    Then wait 1 second
    Then video with youtube id nil shouldn't be clickable