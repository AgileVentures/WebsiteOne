@vcr
Feature: Displaying GitHub contribution statistics for user
  "As a member of AV
  So that I can find out what projects others are contributing to
  I should see the number of commits they have made to projects listed on their profile page."

  Background:
    Given the following projects exist:
      | title      | description       | status | github_url                                  |
      | WebsiteOne | agileventures.org | active | https://github.com/AgileVentures/WebsiteOne |
    And the following users exist
      | first_name | last_name | email               | github_profile_url       |
      | Bryan      | Yap       | test@test.com       | https://github.com/yggie |
      | Thomas     | Ochman    | tochman@hotmail.com |                          |
    And I fetch the GitHub contribution statistics
    And "Bryan" is a member of project "WebsiteOne"
    And "Thomas" is a member of project "WebsiteOne"

  Scenario: Displays commit counts on user profile page
    Given I am on "profile" page for user "Bryan"
    Then I should see "Contributions"
    And I should see "WebsiteOne - 395 commits"

  Scenario: Does not display commit counts for user without github profile url
    Given I am on "profile" page for user "Thomas"
    Then I should not see "Contributions"
    And I should not see "WebsiteOne - 316"

  Scenario: Does not display commit counts for projects not followed by a user
    Given I am on "profile" page for user "Thomas"
    And "Thomas" is not a member of project "WebsiteOne"
    Then I should not see "Contributions"
    And I should not see "WebsiteOne - 316"