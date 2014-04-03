Feature: Adding pivotal tracker stories to projects
    As a site owner
    So that I can provide a better overview over project activities to site users
    I would like to display projects current sprint activities as they are set in Pivotal Tracker 

    Background:
      Given Projet with pivitaltracker_id 982890 has some stories
      And I have access to project pivitaltracker_id 982890 and his labels
      And I have access to project pivitaltracker_id 982890 and his current
      And I have access to project pivitaltracker_id 982890 and his stories
      # And Projet with pivitaltracker_id 982890 has some stories in current
      # And I have access to project iteration with pivitaltracker_id 982890 in PivotalTracker
      And the following projects exist:
        | title        | description    | status | pivotaltracker_id |
        | WebsiteOne   | Agile Ventures | active |            982890 |
        | LocalSupport | Local Support  | active |            742821 |



    Scenario: Project Show Page Renders List of Pivotal Tracker Stories
      Given I am on the "Show" page for project "WebsiteOne"
      Then I click "Activity"
      Then I should see a "Current" table with:
        | column     |
        | Type       |
        | Points     |
        | Labels     |
        | State      |
      And I should see:
        | text                    |
        |                         |
        |                         |
        | Refactor cucumber steps |
        | accepted                |
      And I should see:
        | text                   |
        |                        |
        |                        |
        | Skills on user profile |
        | accepted               |
      And I should see:
        | text                   |
        |                        |
        |                        |
        | Pivotaltracker stories |
        | accepted               |
