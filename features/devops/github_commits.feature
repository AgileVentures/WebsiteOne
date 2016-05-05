@vcr
Feature: Update github stats of all projects
   As a website admin, i should be able to update
   total commit counts of projects with valid github url

   Background: projects have been added to database
      Given the following projects exist:
      | title        | description         | github_url                                    | status   | commit_count |
      | WebsiteTwo   | awesome autograder  | https://github.com/AgileVentures/WebsiteTwo   | active   | 1            |
      | WebsiteOne   | website one project | https://github.com/AgileVentures/WebsiteOne   | inactive | 1            |
      | LocalSupport | Scheduler queue     | https://github.com/AgileVentures/LocalSupport | active   | 1            |
      | Unity        | Unity project       |                                               | active   | 1            |
 
   Scenario: Update github commit count of all projects with valid github_url
      When I run rake task "fetch_github_commits"
      Then I Should see projects with following details:
      | title        | description         | github_url                                    | status   | commit_count |
      | WebsiteTwo   | awesome autograder  | https://github.com/AgileVentures/WebsiteTwo   | active   | 94           |
      | WebsiteOne   | website one project | https://github.com/AgileVentures/WebsiteOne   | inactive | 3572         |
      | LocalSupport | Scheduler queue     | https://github.com/AgileVentures/LocalSupport | active   | 3262         |
      | Unity        | Unity project       |                                               | active   | 1            |
