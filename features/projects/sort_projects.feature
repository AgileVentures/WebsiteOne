@vcr @javascript
Feature: Sort Projects
	As an agile ventures member
	So that I can find a project based on a technology stack
	I would like to sort the projects according to my stack

	Background:
    Given the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               | commit_count | last_github_update      | stacks        |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 | 2795         | 2000-01-13 09:37:14 UTC | Node          |
      | hello mars    | greetings aliens        |             | active   |                                             |                                                  | 2000         | 1999-01-11 09:37:14 UTC | Python        |
      | hello jupiter | greetings jupiter folks |             | active   |                                             | https://jira.atlassian.com/projects/CONFEXT      | 2000         | 1999-01-10 09:37:14 UTC | Ruby on Rails |
      | hello mercury | greetings mercury folks |             | active   |                                             |                                                  | 1900         | 1999-01-09 09:37:14 UTC | Ruby on Rails |
      | hello saturn  | greetings saturn folks  | My pitch... | active   |                                             |                                                  | 1900         | 1999-01-09 08:37:14 UTC | Ruby on Rails |
      | hello sun     | greetings sun folks     |             | active   |                                             |                                                  | 1800         | 1999-01-01 09:37:14 UTC | Ruby on Rails |
      | hello venus   | greetings venus folks   |             | active   |                                             |                                                  |              | 1999-01-01 09:37:14 UTC | Ruby on Rails |
      | hello terra   | greetings terra folks   |             | active   |                                             |                                                  |              | 1999-01-01 09:37:14 UTC | Elixir        |
      | hello pluto   | greetings pluto folks   |             | inactive |                                             |                                                  | 2000         | 1999-01-01 09:37:14 UTC | Ruby on Rails |
      | hello alpha   | greetings alpha folks   |             | active   |                                             |                                                  | 300          | 2000-01-12 09:37:14 UTC | Ruby on Rails |
		And there are no videos

	Scenario: Sort projects based on technology stack
	  Given I am on the "projects" page
	  When I select "Ruby on Rails" from "project_stacks"
		And I click "Filter" button
		Then show me the page
	  Then I should not see "hello world"
