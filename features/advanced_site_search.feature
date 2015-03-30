Feature: Advanced Site Search
  As a site user
  In order to find relevant information in Documents, Projects, Articles, etc
  I would like to access a fulltext search engine that can perform a Google site search and display the results on a separate web page.
  Pivotal Tracker:  https://www.pivotaltracker.com/story/show/77003304

  Background:
    Given I visit the site

  Scenario: Load basic design elements
    Then I should see a navigation header with a search bar
    And I should see a 'Search' button
    
  Scenario: Show search results for 'Website One'
    Then I should see a results page
    And I should see a list of clickable links
