@vcr
@rake
Feature: Github Static Pages
  As the admin
  So that we have static page content that is easily editable via Github
  I want the to import our static page content from Github

  Scenario: Pull static pages from github
    When I run the rake task for fetching static pages from github
    Then I should see all the pages on github in the site as static pages with the content from github
