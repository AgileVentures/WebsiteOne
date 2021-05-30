Feature: Linking karma on users account page to activity tab
  "As a member of the community
  In order to see my status in the community
  I want to see karma on my profile page."

  Background:
    And the following users exist
      | first_name | last_name | email                  | skill_list         | hangouts_attended_with_more_than_one_participant |
      | Alice      | Jones     | alicejones@hotmail.com | ruby, rails, rspec | 1                                                |
      | John       | Doe       | john@doe.com           | ruby, rails, rspec | nil                                              |
    And the following projects exist:
      | title      | description        | github_url                                  | status | commit_count |
      | WebsiteTwo | awesome autograder | https://github.com/AgileVentures/WebsiteTwo | active | 1            |
    And the following commit_counts exist:
      | project    | user_email             | commit_count |
      | WebsiteTwo | alicejones@hotmail.com | 500          |

  Scenario: user with hangouts attended with more than one participant
    Given I am logged in as "Alice"
    And I am on my "Profile" page
    When I click on the karma link
    Then the Activity tab displays "Contributions (GitHub) - 500 total commits x 1 - 500"

  Scenario: user not attended hangouts with more than one participant
    Given I am logged in as "John"
    And I am on my "Profile" page
    When I click on the karma link
    Then the Activity tab does not display "Contributions"