Feature: As a developer
  In order to be able to use the sites features
  I want to register as a user

Scenario: Let a visitor register as a site user
  Given I visit the site
  And I click the "Register" link
  Then I should be on "register" page
  And I should see a register form

#Scenario: Allow registration
