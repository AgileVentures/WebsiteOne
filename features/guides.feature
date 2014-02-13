Feature: Guides
	As a site administrator
	So that I can communicate important topics to the site members
	I want to be have a guide section

	As a AV user 
	So that I can stay up to date with important topics
	I want to access a guide section

	Scenario: There should be a getting started link in the nav bar
		Given I am on the home page
		When I click "Getting Started"
		Then I should be on the static "Getting Started" page
		And I should see "Getting Started"
        And I should see "Remote Pair Programming"
        And I should see "Guides"
#		And I should see a list of guides