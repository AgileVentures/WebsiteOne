Feature: Update github stats of all projects
   As a website admin, i should be able to update
   total commit counts of projects with valid github url

   Background: projects have been added to database
      Given the following projects exist:
      | title        | description         | github_url                                    | status   | commit_count |
      | Auotgrader   | awesome autograder  | https://github.com/AgileVentures/saasbook     | active   | 1            |
      | WebsiteOne   | website one project | https://github.com/AgileVentures/WebsiteOne   | inactive | 1            |
      | PP Scheduler | Scheduler queue     | https://github.com/AgileVentures/Localsupport | active   | 1            |
      | Unity        | Unity project       |                                               | active   | 1            |
 
   Scenario: Update github commit count of all projects with valid github_url
      When I run rake task "fetch_github_commits"	
