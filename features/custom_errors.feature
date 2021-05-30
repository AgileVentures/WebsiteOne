@vcr
Feature: Custom Errors
  "As a visitor
  In order to understand what happened when something goes wrong
  I would like to have a comprehensible error message"

  https://www.pivotaltracker.com/s/projects/982890/stories/64956494

  Background:
    Given Feature "Custom Errors" is enabled

  Scenario: 404 page when visiting an invalid URL
    When I visit "/foobar"
    And the page should be titled "404 - Page Not Found"
    And the response status should be "404"
    And I should see "We're sorry, but we couldn't find the page you requested"

  Scenario: 404 page when opening an invalid project
    When I visit "/projects/foo-bar-project"
    And the page should be titled "404 - Page Not Found"
    And the response status should be "404"
    And I should see "We're sorry, but we couldn't find the page you requested"

  Scenario: 404 page when opening an non existant static page
    When I visit "/about-ussssss"
    And the page should be titled "404 - Page Not Found"
    And the response status should be "404"
    And I should see "We're sorry, but we couldn't find the page you requested"

  Scenario: 404 page when opening an url with wrong format
    Given the following pages exist
      | title    | body           |
      | About Us | Agile Ventures |
    When I visit "/about-us.png"
    And the page should be titled "404 - Page Not Found"
    And the response status should be "404"
    And I should see "We're sorry, but we couldn't find the page you requested"

  Scenario: 500 page
    When I encounter an internal server error
    Then the page should be titled "500 Internal Error"
    And the response status should be "500"
    And I should see "We were unable to process your request at this time."
    And The admins should receive an error notification email