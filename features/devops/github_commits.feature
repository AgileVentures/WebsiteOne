@vcr @rake
Feature: Update github stats of all projects
   As a website admin, i should be able to update
   total commit counts of projects with valid github url

   Background: projects have been added to database
      Given the following projects exist:
      | title        | description         | github_url                                    | status   | commit_count |
      | WebsiteTwo   | awesome autograder  | https://github.com/AgileVentures/WebsiteTwo   | active   | 1            |
      | WebsiteOne   | website one project | https://github.com/AgileVentures/WebsiteOne   | inactive | 1            |
      | edx          | MOOC platform       | https://github.com/edx                        | active   | 1            |
      | Unity        | Unity project       |                                               | active   | 1            |
      | LocalSupport | Scheduler queue     | https://github.com/AgileVentures/LocalSupport | active   | 1            |

   Scenario: Update github commit count of all projects with valid github_url
      When I run the rake task for fetching github commits
      Then I should see projects with following details:
      | title        | status   | commit_count |
      | WebsiteTwo   | active   | 94           |
      | WebsiteOne   | inactive | 3572         |
      | edx          | active   | 1            |
      | Unity        | active   | 1            |
      | LocalSupport | active   | 3262         |
