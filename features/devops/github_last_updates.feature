@vcr @rake
Feature: Update github last update field of all projects
  As a website admin
  So that users can see which are the recently active projects
  I would like to ensure all projects with valid github URLs know when the last commit happened

  Background: projects have been added to database
    Given the following projects exist:
      | title        | description         | github_url                                    | status   | last_github_update      |
      | WebsiteTwo   | awesome autograder  | https://github.com/AgileVentures/WebsiteTwo   | active   | 2000-01-01 01:01:01 UTC |
      | WebsiteOne   | website one project | https://github.com/AgileVentures/WebsiteOne   | inactive | 2000-01-01 01:01:01 UTC |
      | edx          | MOOC platform       | https://github.com/edx                        | active   | 2000-01-01 01:01:01 UTC |
      | Unity        | Unity project       |                                               | active   | 2000-01-01 01:01:01 UTC |
      | LocalSupport | Scheduler queue     | https://github.com/AgileVentures/LocalSupport | active   | 2000-01-01 01:01:01 UTC |

  Scenario: Update last update field of all projects with valid github_url
    When I run the rake task for fetching github last_pushed_at information
    Then I should see projects with following updates:
      | title        | status   | last_github_update                  |
      | WebsiteTwo   | active   | 2016-05-05 14:09:50.000000000 +0000 |
      | WebsiteOne   | inactive | Tue, 16 Oct 2018 20:17:42 UTC +00:00|
      | edx          | active   | 2000-01-01 01:01:01.000000000 +0000 |
      | Unity        | active   | 2000-01-01 01:01:01.000000000 +0000 |
      | LocalSupport | active   | Tue, 16 Oct 2018 08:16:50 UTC +00:00|
