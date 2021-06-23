@vcr
Feature: Remind User complete profile
  "As site admin
  In order to increase the quality of our users database
  I would like to present users with incomplete user profiles with a popup
  reminding them about the benefits of adding skills, name, description(bio), etc."

  Scenario: User has incomplete profile from home page
    Given I exist as a user
    And I have an incomplete profile
    When I sign in with valid credentials
    Then I should see "We've noticed that your profile is incomplete."
    And I should see link "Take me to my profile page"
    And I should see button "Continue using the site"

  Scenario: User has incomplete profile from home page and choose 'edit registration'
    Given I exist as a user
    And I have an incomplete profile
    When I sign in with valid credentials
    And I click "Take me to my profile page"
    Then I should be on the "edit registration" page

  Scenario: User has incomplete profile from home page and choose 'continue'
    Given I exist as a user
    And I have an incomplete profile
    When I sign in with valid credentials
    And I click "Continue using the site"
    Then I should be on the "getting started" page

  Scenario: User has complete profile from home page
    Given I exist as a user
    When I sign in with valid credentials
    Then I should not see "We've noticed that your profile is incomplete."

  Scenario: User has incomplete profile not from home page
    Given I exist as a user
    And I have an incomplete profile
    And I visit "projects"
    When I sign in with valid credentials
    Then I should see "We've noticed that your profile is incomplete."
    And I should see link "Take me to my profile page"
    And I should see button "Continue using the site"

  Scenario: User has complete profile not from home page
    Given I exist as a user
    And I visit "projects"
    When I sign in with valid credentials
    Then I should not see "We've noticed that your profile is incomplete."
