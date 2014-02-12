Feature: Guides
	As a site administrator
	So that I can communicate important topics to the site members
	I want to be have a guide section

	As a AV user 
	So that I can stay up to date with important topics
	I want to access a guide section

	Scenario: There should be a guide directory in the nav bar
		Given I am on the home page
		When I click "Guides"
		Then I should be on the static "Guides" page
		And I should see "Guides"
		And I should see a list of guides