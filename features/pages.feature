Feature: Static pages
  As the site administrator
  So that I can get information across to sites visitors
  I want there to be static pages

  Background:
    Given the following pages exist
      | title         | body             |
      | About Us      | Agile Ventures   |
    And I am on the "home" page

  Scenario: Render about page
    Then I should see link "About us"
    When I click "About us"
    Then I should be on the static "About Us" page
    And I should see "About Us"

  Scenario: Has a link to edit a page using the Mercury Editor
    Given I am logged in
    And I am on the static "About Us" page
    When I click the very stylish "Edit" button
    Then I should be in the Mercury Editor

  @javascript
  Scenario: Mercury editor shows Save and Cancel buttons
    Given I am logged in
    And I am using the Mercury Editor to edit static "About Us" page
    Then I should see button "Save" in Mercury Editor
    And I should see button "Cancel" in Mercury Editor

  @javascript
  Scenario: Mercury editor Save button works
    Given I am logged in
    And I am using the Mercury Editor to edit static "About Us" page
    When I fill in the editable field "Title" for "static_page" with "My new title"
    And I fill in the editable field "Body" for "static_page" with "This is my new body text"
    And I click "Save" in Mercury Editor
    Then I should see "The page has been successfully updated."
    Then I should be on the static "About Us" page
    And I should see "My new title"
    And I should see "This is my new body text"

  @javascript
  Scenario: Mercury editor Cancel button works
    Given I am logged in
    And I am using the Mercury Editor to edit static "About Us" page
    When I fill in the editable field "Title" for "static_page" with "My new title"
    And I click "Cancel" in Mercury Editor
    Then I should be on the static "About Us" page
    And I should see "About Us"

  Scenario: The Mercury Editor should only work for the static pages
    Given I am logged in
    And I visit the site
    When I try to edit the page
    Then I should see "You do not have the right privileges to complete action."
    Given I am on the "Projects" page
    When I try to edit the page
    Then I should see "You do not have the right privileges to complete action."

  Scenario: The Mercury Editor cannot be accessed by non-logged in users
    Given I am on the static "About Us" page
    Then I should not see "Edit"
    And I try to use the Mercury Editor to edit static "About Us" page
    Then I should see "You do not have the right privileges to complete action."