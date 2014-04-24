Feature:
  As a developer
  So that I may see the ranking of articles
  I would like to see the vote count on an article 
  And vote up or down an article

  Background:
    Given the following articles with votes exist:
      | Title                    | Content                          | VoteValue          |
      | Ruby is on Fire          | Fire is fire and sunny           | 0	   		 |
      | Rails is not for trains  | Train `tracks` do not work       | 5                  |
      | JQuery cannot be queried | JQuery moves **towards** the ... | 0                  |

  Scenario: I should see the vote value of an article on the article show page
    Given I am on the "Show" page for article "Ruby is on Fire"
    Then I should see a Vote value of "0"

  Scenario: I should see the link to Up Vote an article on the article show page
    Given I am logged in
    And I am on the "Show" page for article "Ruby is on Fire"
    And I have not voted "up" article "Ruby is on Fire"
    Then I should see link "Up Vote"

  Scenario: I should see the link to Down Vote an article on the article show page
    Given I am logged in
    And I am on the "Show" page for article "Ruby is on Fire"
    And I have not voted "down" article "Ruby is on Fire"
    Then I should see link "Down Vote"

  Scenario: I should not see the link to Up Vote an article on the article show page
    Given I am not logged in
    And I am on the "Show" page for article "Ruby is on Fire"
    Then I should not see link "Up Vote"

  Scenario: I should not see the link to Down Vote an article on the article show page
    Given I am not logged in
    And I am on the "Show" page for article "Ruby is on Fire"
    Then I should not see link "Down Vote"

  Scenario: I should see the link to Cancel Up Vote an article on the article show page
    Given I am logged in
    And I am on the "Show" page for article "Ruby is on Fire"
    And I have voted "up" article "Ruby is on Fire"
    Then I should see link "Cancel Up Vote"

  Scenario: I should see the link to Cancel Down Vote an article on the article show page
    Given I am logged in
    And I am on the "Show" page for article "Ruby is on Fire"
    And I have voted "down" article "Ruby is on Fire"
    Then I should see link "Cancel Down Vote"


#voting

  Scenario: I should be able to vote up an article
    Given I am logged in
    And I am on the "Show" page for article "Ruby is on Fire"
    And I have not voted "up" article "Ruby is on Fire"
    When I click the "Up Vote" link
    Then I should be on the "Ruby is on Fire" page
    And I should see a Vote value of "1"

  Scenario: I should be able to vote down an article
    Given I am logged in
    And I am on the "Show" page for article "JQuery cannot be queried"
    And I have not voted "down" article "Ruby is on Fire"
    And I click the "Down Vote" link
    Then I should be on the "JQuery cannot be queried" page
    And I should see a Vote value of "-1"

#canceling

  Scenario: I should be able to cancel vote up an article
    Given I am logged in
    And I am on the "Show" page for article "Ruby is on Fire"
    And I have voted "up" article "Ruby is on Fire"
    When I click the "Cancel Up Vote" link
    Then I should be on the "Ruby is on Fire" page
    And I should see a Vote value of "0"

  Scenario: I should be able to cancel vote down an article
    Given I am logged in
    And I am on the "Show" page for article "JQuery cannot be queried"
    And I have voted "down" article "Ruby is on Fire"
    And I click the "Cancel Down Vote" link
    Then I should be on the "JQuery cannot be queried" page
    And I should see a Vote value of "0"

