@vcr
@rake
Feature: Update from github urls to source repository model
  As a website admin,
  I want to move existing github urls to source repositories
  So that the system supports multiple repositories per project

  Background: projects have been added to database
    Given the following legacy projects exist:
      | title        | description         | github_url                                    | status   | commit_count |
      | WebsiteTwo   | awesome autograder  | https://github.com/AgileVentures/WebsiteTwo   | active   | 1            |
      | WebsiteOne   | website one project | https://github.com/AgileVentures/WebsiteOne   | inactive | 1            |
      | edx          | MOOC platform       | https://github.com/edx                        | active   | 1            |
      | Unity        | Unity project       |                                               | active   | 1            |
      | LocalSupport | Scheduler queue     | https://github.com/AgileVentures/LocalSupport | active   | 1            |

  Scenario: Run the data migration to copy github urls to source repositories
    When I run the rake task for migrating github urls
    Then I should see projects looked up by title with first source repository same as github_url:
      | title        | status   | github_url                                    |
      | WebsiteTwo   | active   | https://github.com/AgileVentures/WebsiteTwo   |
      | WebsiteOne   | inactive | https://github.com/AgileVentures/WebsiteOne   |
      | edx          | active   | https://github.com/edx                        |
      | Unity        | active   |                                               |
      | LocalSupport | active   | https://github.com/AgileVentures/LocalSupport |