Feature: URL pattern for content type
  As a content creator to the Insider
  I want content types to follow a particular URL pattern
  So it easier to distinguish and track content by URL

  Background:
    Given I am logged in as a user with the "sitebuilder" role
      And "top_level_group" terms:
      | name       | field_abbreviation |
      | group      | grp                |
      | sports     | spt                |
      | procedures |                    |
      And "timezone" terms:
      | name     | field_abbreviation |
      | Eastern  | ET                 |
      | Central  | CT                 |
      | Mountain | MT                 |
      | Pacific  | PT                 |
      | Alaska   | AT                 |
      | Hawaii   | HT                 |

  @api
  Scenario: URL pattern validation for announcements with abbreviation field set
    Given "announcement" content:
      | title             | field_announcement_type | body   | published_at | field_top_level_group | status |
      | BEHAT URL pattern | Memorandum              | Test 1 | 09/10/2017   | group                 | 1      |
    When I am on "/grp/announcements/memos/2017-09/behat-url-pattern"
    Then the response status code should be 200

  @api
  Scenario: URL pattern validation for announcements without abbreviation field set
    Given "announcement" content:
      | title             | field_announcement_type | body   | published_at | field_top_level_group | status |
      | BEHAT URL pattern | Memorandum              | Test 1 | 11/10/2017   | procedures            | 1      |
    When I am on "/announcements/memos/2017-11/behat-url-pattern"
    Then the response status code should be 200

  @api
  Scenario: URL pattern validation without top level group selected
    Given "announcement" content:
      | title             | field_announcement_type | body   | published_at | field_top_level_group | status |
      | BEHAT URL pattern | Memorandum              | Test 1 | 11/10/2017   |                       | 1      |
    When I am on "/announcements/memos/2017-11/behat-url-pattern"
    Then the response status code should be 200

  @api
  Scenario: URL pattern validation for article
    Given "sec_article" content:
      | title             | body   | published_at | field_top_level_group | status |
      | BEHAT URL pattern | Test 1 | 11/10/2017   | procedures            | 1      |
    When I am on "/behat-url-pattern"
    Then the response status code should be 200

  @api
  Scenario: URL pattern validation for OP
    Given "operating_procedure" content:
      | title       | field_release_number | field_publish_date | field_series | Description         | field_top_level_group | status |
      | OP1 content | OP1-2                | now                | 1            | this is description | group                 | 1      |
    When I am on "/grp/op1-2-op1-content"
    Then the response status code should be 200

  @api
  Scenario: URL pattern validation for SECR
    Given "secr" content:
      | title                | field_secr_number | field_publish_date | field_series | field_top_level_group | status |
      | Free Ice Cream Today | R1-2              | now                | 1            | sports                | 1      |
    When I am on "/spt/r1-2-free-ice-cream-today"
    Then the response status code should be 200

  @api
  Scenario: URL pattern validation for event
    Given I create "paragraph" of type "paragraph_session":
      | KEY   | field_location | field_start_date    | field_end_date      | type              |
      | 12345 | Texas          | 2017-11-15T17:00:00 | 2017-11-15T18:00:00 | paragraph_session |
      And I create "node" of type "event":
        | title             | field_event_type | body      | field_top_level_group | status | field_session | field_timezone_select |
        | BEHAT URL Pattern | general          | body text | group                 | 1      | 12345         | Central               |
      # And I am viewing an "event" content:
      # | field_event_type      | general           |
      # | title                 | BEHAT URL Pattern |
      # | body                  | body text         |
      # | field_session         | 12345             |
      # | field_timezone_select | Central           |
      # | field_top_level_group | group             |
      # | status                | 1                 |
    When I am on "/grp/events/general/2017-11/behat-url-pattern"
    Then the response status code should be 200

  @api
  Scenario: URL pattern validation for landing page
    Given "landing_page" content:
      | field_landing_page_subtype | title             | field_description_abstract[0][value] | field_top_level_group | status |
      | Audience                   | BEHAT URL Pattern | this is description                  | sports                | 1      |
    When I am on "/spt/audience/behat-url-pattern"
    Then the response status code should be 200

  @api
  Scenario: URL pattern validation for static file
    Given "file" content:
      | title             | field_description_abstract        | field_file_upload    | field_topic  | field_top_level_group | status | nid   |
      | BEHAT url pattern | This is a Description or Abstract | file;behat-form1.pdf | Acquisitions | group                 | 1      | 77777 |
    When I am on "/node/77777"
      And I should see the link "behat-url-pattern.pdf"
    Then the link "behat-url-pattern.pdf" should match the Drupal url "/files/exchange/behat-url-pattern.pdf"
