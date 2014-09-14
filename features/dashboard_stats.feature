Feature: Display Statistics
  As a project maintainer
  In order to attract more users to AgileVentures
  I would like to present some attractive statistics to new visitors of WSO

  Background:
    Given the following articles exist:
      | Title     | Content |
      | Article 1 | -       |
      | Article 2 | -       |
      | Article 2 | -       |

    And the following projects exist:
      | title     | description | status   |
      | Project 1 | -           | active   |
      | Project 2 | -           | active   |
      | Project 4 | -           | active   |
      | Project 5 | -           | active   |
      | Project 6 | -           | inactive |
      | Project 6 | -           | inactive |

    And the following users exist
      | first_name | last_name | email                  |
      | Alice      | Jones     | alice@btinternet.co.uk |
      | Bob        | Butcher   | bobb112@hotmail.com    |

    And the following documents exist:
      | title      | project   |
      | Document 1 | Project 1 |
      | Document 2 | Project 2 |

    And activities exists

  Scenario:
    Given I am on the "home" page
    Then I should see link "Dashboard"
    When I click "Dashboard"
    Then I should be on the "Dashboard" page
    And I click the "Site statistics" link
    Then I should see "statistics" tab is active
    And I should see "Statistics"
    And I should see "3 Articles Published"
    And I should see "4 Active Projects"
    And I should see "3 AgileVentures Members"
    And I should see "2 Documents Created"
