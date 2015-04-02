Feature: Advanced Site Search
  As a site user
  In order to find relevant information in Documents, Projects, Articles, etc
  I would like to access a fulltext search engine that can perform a Google site search and display the results on a separate web page.
  Pivotal Tracker:  https://www.pivotaltracker.com/story/show/77003304

  Background:
    Given I visit the site

  Scenario: Performing a Basic Site Search
    When I click the Search Toggle button
    Then a search form should appear
    And when I search for 'WebsiteOne'
    And I click 'Submit'
    Then I should see the search results overlay
