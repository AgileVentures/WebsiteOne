@vcr
Feature: Adding pivotal tracker stories to projects
    As a site owner
    So that I can provide a better overview over project activities to site users
    I would like to display projects current sprint activities as they are set in Pivotal Tracker 

    Background:
      # And I have access to project iteration with pivitaltracker_id 982890 in PivotalTracker
      Given the following projects exist:
        | title      | description    | status | pivotaltracker_url                               |
        | WebsiteOne | Agile Ventures | active | https://www.pivotaltracker.com/s/projects/982890 |
      And there are no videos

    Scenario: When a project has no stories
      Given The project has no stories on Pivotal Tracker
      And I am on the "Show" page for project "WebsiteOne"
      Then I click "Activity"
      Then I should see "No IssueTracker Stories can be found for project WebsiteOne"

    Scenario: Project Show Page Renders List of Pivotal Tracker Stories
      Given The project has some stories on Pivotal Tracker
      And I am on the "Show" page for project "WebsiteOne"
      Then I click "Activity"
      Then I should see a "Current" table with:
        | column     |
        | Type       |
        | Points     |
        | Labels     |
        | State      |
      And I should see:
        | text                    |
        | Refactor cucumber steps |
        | accepted                |
      And I should see:
        | text                   |
        | Skills on user profile |
        | accepted               |
      And I should see:
        | text                   |
        | Pivotaltracker stories |
        | accepted               |
