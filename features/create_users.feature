Feature: As a developer
  In order to be able to use the sites features
  I want to register as a user
  https://www.pivotaltracker.com/story/show/63047058

Scenario: Let a visitor register as a site user
  Given I am on the "registration" page
  And I submit "user@example.com" as username
  And I submit "password" as password
  And I click "Sign up"
  Then I should be on the home page
  And I should see "Welcome! You have signed up successfully."


