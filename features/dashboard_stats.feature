Feature: Display Statistics
  As a project maintainer
  In order to attract more users to AgileVentures
  I would like to present some attractive statistics to new visitors of WSO
  https://www.pivotaltracker.com/story/show/64726524

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
    | first_name | last_name | email                   |
    | Alice      | Jones     | alice@btinternet.co.uk  |
    | Bob        | Butcher   | bobb112@hotmail.com     |

  And the following documents exist:
    | title | project |
    | Document 1 | Project 1 |
    | Document 2 | Project 2 |

  Scenario: 
    Given I am on the "home" page
    Then I should see link "Dashboard"
    When I click "Dashboard"
    Then I should be on the "Dashboard" page
    #a step should be generic, i.e. can be used no matter what the setup is
    #this can be done by passing arguments into the step
    And I should see "AgileVentures Activity and Statistics"
    And I should see "3 Articles Published"
    And I should see "4 Active Projects"
    And I should see "3 AgileVentures Members"
    And I should see "2 Documents Created"
