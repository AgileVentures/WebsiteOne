@vcr
Feature: Linking and unlinking of GitHub account
  "As a registered user
  So that i can use github as authorization
  I want ability to link and unlink github as authorization provider"

  @omniauth
  Scenario: Link my GitHub profile link to my profile: success
    Given I am logged in as user with name "Bob", email "current@email.com", with password "12345678"
    And I have a GitHub profile with username "tochman"
    And I am on my "Edit Profile" page
    When I click "GitHub"
    And my profile should be updated with my GH username
    When I am on "profile" page for user "me"
    Then I should see a link "tochman" to "https://github.com/tochman"


  @omniauth
  Scenario: Unlink my GitHub profile link from my profile: success
    Given I am logged in as user with name "Bob", email "current@email.com", with password "12345678"
    Given I have a GitHub profile with username "tochman"
    And I have authentication enabled with my github username
    And I am on my "Edit Profile" page
    When I click "Remove GitHub"
    Then I should not have any authentications by my github username
    And I should not have github_profile_url set in my profile
    When I am on "profile" page for user "me"
    Then I should not see a link "tochman" to "https://github.com/tochman"

  @omniauth
  Scenario: Unlink my GitHub profile link from my profile with no backup login strategy: failure
    Given I am on the "Sign in" page
    When I click "GitHub"
    Then I should see a success flash "Signed in successfully."
    And I am on my "Edit Profile" page
    When I click "Remove GitHub"
    Then I should see GitHub account unlinking failed message

