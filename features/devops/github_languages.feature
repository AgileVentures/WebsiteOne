@vcr @rake
Feature: Update github languages field of all projects
  As a website admin
  So that users can see which languages projects use
  I would like to ensure that all languages are added to projects

  Background: projects have been added to database
    Given the following projects exist:
      | title                 | description             |      github_url                                     | status    | languages |
      | MetPlus               | Detroit job seekers site| https://github.com/AgileVentures/MetPlus_PETS       | active    | Java      |
      | WebsiteTwo            | awesome autograder      | https://github.com/AgileVentures/WebsiteTwo         | inactive  | Ruby      |
      | WebsiteOne            | website one project     | https://github.com/AgileVentures/WebsiteOne         | active    | Ruby      |
      | LocalSupport          | Scheduler queue         | https://github.com/AgileVentures/LocalSupport       | active    | Ruby      |
      | Rundfunk-Mitbestimmen | Democracy in journalism | https://github.com/roschaefer/rundfunk-mitbestimmen | active    | JavaScript |

  Scenario: Update language field of all projects with valid github_url
    When I run the rake task for fetching github languages information
    Then I should see projects with the following language updates:
      | title                 | status   | languages     |
      | MetPlus               | active   | Ruby          |
      | WebsiteTwo            | active   | CSS           |
      | WebsiteOne            | inactive | Shell         |
      | LocalSupport          | active   | CoffeeScript  |
      | Rundfunk-Mitbestimmen | active   | JavaScript    |
