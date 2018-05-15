@vcr
Feature: Static pages
  As the site administrator
  So that I can get information across to sites visitors
  I want there to be static pages

  Background:
    Given the following pages exist
      | title         | body                      |
      | About Us      | Agile Ventures            |
      | Sponsors      | AV Sponsors               |
      | Getting Started | Remote Pair Programming |

    And the following page revisions exist
      | title         | revisions  |
      | About Us      | 1          |
    And I am on the "home" page

  Scenario: Render About Us page
    Then I should see link "About Us"
    When I click "About Us"
    Then I should be on the static "About Us" page
    And I should see "About Us"

  # Sponsors and Guides scenarios not really needed. To be removed later.
  Scenario: See Sponsor Banners
    When I am on the "projects" page
    Then I should see sponsor banner for "Standuply"
    And I should see sponsor banner for "Craft Academy"
    And I should see sponsor banner for "Mooqita"
    And I should see sponsor banner for "RubyMine"
    And I should see link "Become a supporter"

  Scenario: Render Sponsors page
    When I am on the "projects" page
    And I click "Become a supporter"
    Then I should be on the static "Sponsors" page

  Scenario: There should be a getting started link in the nav bar
    When I am on the home page
    And I click "Getting Started"
    Then I should be on the static "Getting Started" page
    And I should see "Getting Started"
    And I should see "Remote Pair Programming"

  Scenario: Page can have children and children should have a correct url
    Given the page "About Us" has a child page with title "SubPage1"
    And I am on the static "SubPage1" page
    Then the current page url should be "about-us/subpage1"

  Scenario: Page should show ancestry details
    Given the page "About Us" has a child page with title "SubPage1"
    And I am on the static "SubPage1" page
    Then I should see ancestry "Agile Ventures >> About Us >> SubPage1"

  Scenario: The browser tab text should reflect the page the user is on
    Given I am on the "Home" page
    Then the "Home" page title should read "Home | AgileVentures"
    When I click "About"
    Then I should be on the static "About Us" page
    And the "About" page title should read "About Us | AgileVentures"

  Scenario: The browser tab of the registration page should say AgileVentures
    Given I am on the "registration" page
    Then the "Sign up" page title should read "AgileVentures"