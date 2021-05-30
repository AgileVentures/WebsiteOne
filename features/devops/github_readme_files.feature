@vcr, @rake
Feature: Update github pitch of all projects
  As a website admin, I should be able to update
  about section of projects with valid github url

  Background: projects have been added to database
    Given the following projects exist:
      | title        | description            | status   | pitch        |
      | WebsiteOne   | website one project    | active   | WebsiteOne   |
      | edx          | MOOC platform          | active   | edx          |
      | LocalSupport | Scheduler queue        | active   | LocalSupport |
      | Unity        | Unity project          | pending  | Unity        |
      | closed       | closed project         | closed   | keepclosed   |
      | fakerepo     | fake repository        | active   | keepfake     |

    Given the following source repositories exist:
      | url                                           | project      |
      | https://github.com/AgileVentures/WebsiteOne   | WebsiteOne   |
      | https://github.com/edx                        | edx          |
      | https://github.com/AgileVentures/LocalSupport | LocalSupport |
      | https://github.com/AgileVentures/LocalSupport | closed       |
      | https://github.com/fake/repo                  | fakerepo     |

  Scenario: Update github pitch for all projects with valid github_url
    When I run the rake task for fetching github readme
    Then I should see projects with pitch updated:
      | title        | pitch                     |
      | WebsiteOne   | AgileVentures WebSiteOne  |
      | LocalSupport | LocalSupport              |
      | closed       | keepclosed                |
      | edx          | edx                       |
      | fakerepo     | keepfake                  |
