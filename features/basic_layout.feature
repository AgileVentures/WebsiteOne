Feature:
  As a user,
  when I visit the site
  I should see a basic design elements


Background:
  Given I visit the site

Scenario: Load basic design elements
  Then I should see a navigation header
  And I should see a main content area
  And I should see a footer area


Scenario: Render navigation bar
  Then I should see a navigation bar
  Then show me the page
  And I should see a "Our projects" link
  And I should see a "Check in" link
  And I should see a "Sign up" link


