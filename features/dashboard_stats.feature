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

  Given the following projects exist:
    | title     | description | status |
    | Project 1 | -           | -      |
    | Project 2 | -           | -      |
    | Project 4 | -           | -      |
    | Project 5 | -           | -      |
    | Project 6 | -           | -      |
    | Project 6 | -           | -      |

  Given the following users exist
    | first_name | last_name | email                   |
    | Alice      | Jones     | alice@btinternet.co.uk  |
    | Bob        | Butcher   | bobb112@hotmail.com     |
    #
    # keep test setup to minimum, i.e. only instantiate the necessary properties

  Scenario: 
    Given I am on the "home" page
    Then I should see link "Dashboard"
    When I click "Dashboard"
    Then I should be on the "Dashboard" page
    #a step should be generic, i.e. can be used no matter what the setup is
    #this can be done by passing arguments into the step
    And I should see "AgileVentures Activity and Statistics"
    And I should see informative statistics about AgileVentures "articles"
    And I should see informative statistics about AgileVentures "projects"
    And I should see informative statistics about AgileVentures "users"
