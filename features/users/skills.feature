Feature: As a site user
    In order to find a user with a relevant skill
    I would like to see a users self assessed skills set

	Background:
      Given I am on the "home" page
      And I am logged in as user with email "brett@example.com", with password "12345678"

	@javascript
    Scenario: Can add skills to my profile
      Given I am on my "edit profile" page
      And I add skills "c++,java,php"
      And I click "Update" button
      Given I go to my "profile" page
      Then I should be on the "user profile" page for "brett@example.com"
      And I should see skills "c++,java,php" on my profile