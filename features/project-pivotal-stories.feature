Feature: Adding pivotal tracker stories to projects
    As a site owner
    So that I can provide a better overview over project activities to site users
    I would like to display projects current sprint activities as they are set in Pivotal Tracker 

    Background:
	Given I am connected with Pivotal Tracker
	And the following projects exist:
	    | title        | description    | status | pivotal-tracker-id |                                
	    | LocalSupport | Local Support  | active | 742821             |
	    | WebsiteOne   | Agile Ventures | active | 982890             |

    Scenario: Project Show Page Renders List of Pivotal Tracker Stories
	Given I am on the "Show" page for project "LocalSupport"
	Then I should see "PivotalTracker (5)"
	And I click "PivotalTracker"
	Then I should see a "List Of Pivotal Stories" table with:
	    | column     |
	    | Story ID   |	  
	    | Name       |
	    | Story Type |
	    | Points     |
	    | Requester  |
	    | Owner      |
	    | State      |

	And I should see:
	    | text           |
	    | 64723776       |
	    | Test Story     |
	    | Feature        |
	    | 3              |
	    | Dima Sukhikh   |
	    | Sampriti Panda |
	    | Accepted       |
