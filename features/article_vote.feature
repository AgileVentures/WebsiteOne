Feature:
  As a developer
  So that I may see the ranking of articles
  I would like to see the vote count on an article 
  And vote up or down an article

  Background:
    Given the following articles exist:
      | Title                    | Content                          | VoteValue          |
      | Ruby is on Fire          | Fire is fire and sunny           | 0	   		 |
      | Rails is not for trains  | Train `tracks` do not work       | 5                  |
      | JQuery cannot be queried | JQuery moves **towards** the ... | 0                  |

  Scenario: I should see the vote value of an article on the article show page
    Given I am on the "Show" page for article "Ruby is on Fire"
    Then I should see a "vote value" of zero

  Scenario: I should see the link to Up Vote an article on the article show page
    Given I am logged in
    Given I am on the "Show" page for article "Ruby is on Fire"
    Then I should see a link to "Up Vote"

  Scenario: I should see the link to Down Vote an article on the article show page
    Given I am logged in
    Given I am on the "Show" page for article "Ruby is on Fire"
    Then I should see a link to "Down Vote"

  Scenario: I should be able to vote up an article
    Given I am logged in
    And I am on the "Show" page for article "Ruby is on Fire"
    When I click the "Up Vote" link
    Then I should be on the "Ruby is on Fire" page
    And I should see a "Vote value" of "1"

  Scenario: I should be able to vote down an article
    Given I am logged in
    And I am on the "Show" page for article "JQuery cannot be queried"
    And I click the "Down Vote" link
    Then I should be on the "JQuery cannot be queried" page
    And I should see a "Vote value" of -1
