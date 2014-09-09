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
      | Articles        |
      | Events          |

  Scenario: Render footer
    And I should see "AgileVentures" in footer
    And I should see "Crowdsourced Learning" in footer

  @poltergeist
  Scenario: Render Sponsors if visited on a desktop computer
    Given I am on a desktop
    And I am on Events index page
    Then I should see the supporter content

  @poltergeist @tablet
  Scenario: Hide Sponsors if visited on a Tablet
    Given I am on a tablet
    And I am on Events index page
    Then I should not see the supporter content

  @poltergeist @smartphone
  Scenario: Hide Sponsors if visited on a Smartphone
    Given I am on a smartphone
    And I am on Events index page
    Then I should not see the supporter content


