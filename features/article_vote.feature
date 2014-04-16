Feature:
  As a developer
  So that I may see the ranking of articles
  I would like to see the vote count of articles 
  And vote on articles

  Background:
    Given the following articles exist:
      | Title |
      | qui facere quasi |
      | aliquam quis sint |
      | cum libero exercitation |

  Scenario: I should see the votes
    Given I am on the "qui facere quasi" page
    Then I should see "number of votes"
