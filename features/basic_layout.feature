@vcr
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
    And I should see link
      | About Us        |
      | Projects        |
      | Members         |
      | Premium         |
      | Events          |
      | Getting started |

  Scenario: Events is a dropdown with links
    When I dropdown the "Events" menu
    Then I should see a link to upcoming events
    And I should see a link to past scrums
    And I should see a link to past events
    And I should see a link to create a new event

  Scenario: Render footer
    And I should see "AgileVentures" in footer
    And I should see "Crowdsourced Learning" in footer
    And I should see "Learn More" in footer
    And I should see "Social" in footer
    And I should see "Our Sponsors" in footer
    And I should see "Contact us" in footer
    And I should see a link "drie" to "https://drie.co/"
    And I should see a link "Craft Academy" to "http://craftacademy.se/english"
    And I should see a link "Mentive" to "http://www.mentive.co/"
    And I should see a link "RubyMine" to "https://www.jetbrains.com/ruby/"

  @javascript @desktop
  Scenario: Show Sponsors on desktop computer
    Given I am on a desktop
    And I am on Events index page
    Then I should see the supporter content
    And I am on Projects index page
    Then I should see the supporter content

  @javascript @tablet
  Scenario: Hide Sponsors from Tablets
    Given I am on a tablet
    And I am on Events index page
    Then I should not see the supporter content
    And I am on Projects index page
    Then I should not see the supporter content

  @javascript @smartphone
  Scenario: Hide Sponsors from Smartphones
    Given I am on a smartphone
    And I am on Events index page
    Then I should not see the supporter content
    And I am on Projects index page
    Then I should not see the supporter content

  @javascript @desktop
  Scenario: Show Round banners on desktop computer
    Given I am on a tablet
    And I visit the site
    Then I should see the round banners

  @javascript @tablet
  Scenario: Hide Round banners from Tablets
    Given I am on a tablet
    And I visit the site
    Then I should not see the round banners

  @javascript @smartphone
  Scenario: Hide Round banners from Smartphones
    Given I am on a smartphone
    And I visit the site
    Then I should not see the round banners
