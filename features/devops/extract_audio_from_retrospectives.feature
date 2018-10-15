@rake
Feature: Extract Audio from Retrospectives
  As the admin
  So that we can automate the process
  I want to extract audio from Retrospectives

  Background:
    Given the following projects exist:
      | title        | description         |  status   |
      | WebsiteOne   | AV site             |  active   |
    And the following event instances exist:
        | title          | hangout_url         | created_at       | updated_at          | uid | category | project    | user_id | yt_video_id | hoa_status  | url_set_directly | event            |
        | Retrospective1 | http://hangout.test | 2012 Feb 4th 7am | 2012 Feb 4th 7:04am | 100 | Scrum    | WebsiteOne | 1       | QWERT55     | finished    | true             | AV Retrospective |
        | Retrospective2 | http://hangout.test | 2014 Feb 4th 7am | 2014 Feb 4th 7:03am | 100 | Scrum    | WebsiteOne | 1       | QWERT55     | finished    | true             | AV Retrospective |

  Scenario: Extract latest video
      When I run the rake task for extracting audio from Retrospectives
      Then I have a new audio in my audio directory

