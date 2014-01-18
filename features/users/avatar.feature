Feature:  In order to make my personal avatar visible to other users
  As a registered user
  I want to link my avatar image to my account

  Background:
    Given I am logged in as user with email "current@email.com", with password "12345678"
    And I am on the "home" page

  Scenario: See my avatar on My account page
    When I click "My Account"
    Then I should see my avatar image:


