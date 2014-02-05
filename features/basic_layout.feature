Feature: Setting up basic page layout for site
  As a user
  So that I can navigate the site
  I should see a basic navigation elements
  https://www.pivotaltracker.com/story/show/63523208


  Background:
    Given the app is in production mode
    Given I visit the site

  Scenario: Load basic design elements
    Then I should see a navigation header
    And I should see a main content area
    And I should see a footer area

  Scenario: Check for Analytics code in production
    And the page should include script for Google Analytics
    #And I should see the tracking code

  Scenario: Render navigation bar
    Then I should see a navigation bar
    And I should see link
      | Our projects |
      | Our members  |
      | Log in       |
      | Sign up      |

  Scenario: Render footer
    And I should see "AgileVentures" in footer
    And I should see "Crowdsourced Learning" in footer


