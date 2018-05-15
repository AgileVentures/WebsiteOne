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
      Then I should see projects looked up by title with the correct commit count:
      | title        | commit_count |
      | WebsiteTwo   | 95           |
      | WebsiteOne   | 4250         |
      | edx          | 1            |
      | Unity        | 1            |
      | LocalSupport | 3707         |
