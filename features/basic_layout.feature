Feature: Setting up basic page layout for site
  As a user
  So that I can navigate the site
  I should see a basic navigation elements
  https://www.pivotaltracker.com/story/show/63523208 with further changes


  Background:
    Given I visit the site

  Scenario: Load basic design elements
    Then I should see a navigation header
    And I should see a main content area
    And I should see a footer area

  Scenario: Render navigation bar
    Then I should see a navigation bar
    And I should see link
      | About Us        |
      | Projects        |
      | Members         |
      | Articles        |
      | Events          |
      | Getting started |

  Scenario: Events is a dropdown with links
    When I dropdown the "Events" menu
    Then I should see a link "Upcoming events" to "/events"
    And I should see a link "Past scrums" to "/scrums"

  Scenario: Render footer
    And I should see "AgileVentures" in footer
    And I should see "Crowdsourced Learning" in footer
    And I should see "Learn More" in footer
    And I should see "Social" in footer
    And I should see "Our Sponsors" in footer
    And I should see "Contact us" in footer

