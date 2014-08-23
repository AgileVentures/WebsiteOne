Feature: Display Statistics
  As a project maintainer
  In order to attract more users to AgileVentures
  I would like to present some attractive statistics to new visitors of WSO
  https://www.pivotaltracker.com/story/show/64726524

  Scenario: 
    Given I am on the "home" page
    Then I should see link "Statistics"
    When I click "Statistics"
    Then I should be on the "Dashboard" page
    And I should see "AgileVentures Statistics"
