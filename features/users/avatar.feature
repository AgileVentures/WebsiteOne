@vcr
Feature:  In order to make my personal avatar visible to other users
  As a registered user
  I want to link my avatar image to my account

  Background:
    Given I am logged in as user with email "MyEmailAddress@example.com", with password "12345678"
    And I have an avatar image at "https://www.gravatar.com/avatar/0bc83cb571cd1c50ba6f3e8a78ef1346?s=80&d=retro"
    And I am on the "home" page

  Scenario: See my avatar on My account page
    When I click pulldown link "My account"
    Then I should see my avatar image
