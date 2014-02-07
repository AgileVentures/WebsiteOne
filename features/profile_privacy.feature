Feature: As a site user
  To protect my privacy
  I want to decide if which part of my profile should be made public

  Background:
    Given I am logged in as user with email "brett@example.com", with password "12345678"

  @javascript
  Scenario: Email should be private by default
    Given I am on my profile page
    When I click "Preview"
    Then I should not see my email

  @javascript
  Scenario: Should be able to make my email public
    Given I am on my profile page
    When I set my email to be public
    And I click "Preview"
    Then I should see my email

  # Scenario: Should be able to make my email private again
  #   Given My email was set to public
  #   And I am on my profile page
  #   When I set my email to be private
  #   And I click "Preview"
  #   Then I should not see my email

  # Scenario: GitHub profiles should be private by default
  #   Given I am on my profile page
  #   When I click "Preview"
  #   Then I should not see a link to my GitHub profile

  # Scenario: Should be able to make my GitHub profiles public
  #   Given I am on my profile page
  #   When I set my GitHub profile to be public
  #   And I click "Preview"
  #   Then I should see a link to my GitHub profile

  # Scenario: Should be able to make my GitHub profile private again
  #   Given My GitHub profile was set to public
  #   And I am on my profile page
  #   When I set my GitHub profile to be private
  #   And I click "Preview"
  #   Then I should not see a link to my GitHub profile
