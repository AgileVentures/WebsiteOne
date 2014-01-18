Feature: Setting up basic page layout for site
  As a user
  So that I can navigate the site
  I should see a basic navigation elements
  https://www.pivotaltracker.com/story/show/63523208


Background:
  Given I visit the site

Scenario: Load basic design elements
  Then I should see a navigation header
  And I should see a main content area
  And I should see a footer area


Scenario: Render navigation bar
  Then I should see a navigation bar
#  Then show me the page
  And I should see link "Our projects"
  And I should see link "Check in"
  And I should see link "Sign up"

  Scenario: Render footer
#    And I should see "AgileVentures" in footer
#    And I should see "Crowdsourced Learning" in footer


