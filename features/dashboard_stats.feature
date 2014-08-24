Feature: Display Statistics
  As a project maintainer
  In order to attract more users to AgileVentures
  I would like to present some attractive statistics to new visitors of WSO
  https://www.pivotaltracker.com/story/show/64726524

  Background:
  Given the following articles exist:
    | Title                    | Content                   | Tag List           |
    | Ruby is on Fire          | Fire is fire and sunny    | Ruby, Rails        |
    | Rails is not for trains  | Train tracks do not work  | Rails              |
    | JQuery cannot be queried | JQuery is javascript      | Javascript, JQuery |

  Given the following projects exist:
    | title         | description             | status   | github_url                                  | pivotaltracker_url                               |
    | hello world   | greetings earthlings    | active   | https://github.com/agileventures/helloworld | https://www.pivotaltracker.com/s/projects/742821 |
    | hello mars    | greetings aliens        | inactive |                                             |                                                  |
    | hello jupiter | greetings jupiter folks | active   |                                             |                                                  |
    | hello mercury | greetings mercury folks | inactive |                                             |                                                  |
    | hello saturn  | greetings saturn folks  | active   |                                             |                                                  |
    | hello sun     | greetings sun folks     | active   |                                             |                                                  |
    And there are no videos

  Given the following users exist
    | first_name | last_name | email                   |
    | Alice      | Jones     | alice@btinternet.co.uk  |
    | Bob        | Butcher   | bobb112@hotmail.com     |

  Scenario: 
    Given I am on the "home" page
    Then I should see link "Statistics"
    When I click "Statistics"
    Then I should be on the "Dashboard" page
    And I should see "AgileVentures Activity and Statistics"
    And I should see informative statistics about AgileVentures "articles"
    And I should see informative statistics about AgileVentures "projects"
    And I should see informative statistics about AgileVentures "users"
