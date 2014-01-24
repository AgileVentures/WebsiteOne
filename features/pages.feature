Feature: Static pages
  As the site administrator
  So that I can get information across to sites visitors
  I want there to be static pages

  Background:
    Given I am on the "home" page

  Scenario: Render of about page
    Then I should see a link "About us"
    When I click "About us"
    Then I should be on the "About us" page
    
