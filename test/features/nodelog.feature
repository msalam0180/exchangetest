Feature: Node Log
  As an administrative user
  I want to be able to view node logs for authenticated users
  So that I can view user activities to decern the most useful content

  Background:
    Given users:
      | name          | mail           | roles            |
      | creator       | test1@test.com | content_creator  |
      | approver      | test2@test.com | content_approver |
      | sitebuilder   | test3@test.com | sitebuilder      |
      | authen_user1  | test4@test.com |                  |
      | authen_user2  | test5@test.com |                  |
      | admin         | test6@test.com | administrator    |

@api @javascript
Scenario Outline: Role Access to Authenticated User Node Log
  Given I am logged in as a user with the "<role>" role
  When I visit "/admin/node/log"
  Then I should see the heading "<Result1>"

  Examples:
      | role             |  Result1              |
      | content_creator  |  Error 403: Forbidden |
      | content_approver |  Error 403: Forbidden |
      | sitebuilder      |  Error 403: Forbidden |
      | administrator    |  Node Log             |

@api @javascript
Scenario Outline: Authenticated User Access
  Given I am logged in as "authen_user1"
  When I visit "<page>"
  Then I should see the text "<result>"

  Examples:
      | page                        | result               |
      | /admin/node/log             | Error 403: Forbidden |
      | /admin/content              | Error 403: Forbidden |
      | /admin/workbench/content/all| Error 403: Forbidden |
      | /admin/content/files        | Error 403: Forbidden |
      | /admin/content/entity-usage | Error 403: Forbidden |

@api @javascript
Scenario: Authenticated User Node Logs
  Given I create "paragraph" of type "paragraph_session":
    | KEY | field_location | field_start_date | field_end_date  |
    | 100 | Vancouver, BC  | +1 hour          | +5 day          |
    | 101 | Seattle, WA    | +2 hour          | +1 day          |
    | 102 | Portland, OR   | +1 day           | +1 day +1 hour  |
    | 103 | Phoenix, AZ    | +1 week          | +1 week +1 hour |
    And I create "node" of type "event":
      | title              | field_short_title | body                | status | field_session | field_event_type | nid      |
      | BEHAT Event Test 0 | Home Page Title 0 | This is an Event 0. | 1      | 100           | General          | 99999999 |
      | BEHAT Event Test 1 | Home Page Title 1 | This is an Event 1. | 1      | 101           | Training         | 99999998 |
      | BEHAT Event Test 2 | Home Page Title 2 | This is an Event 2. | 1      | 102           | Deadlines        | 99999997 |
      | BEHAT Event Test 3 | Home Page Title 3 | This is an Event 3. | 1      | 103           |                  | 99999996 |
    And "announcement" content:
      | title                          | field_short_title | body   | changed | status | field_announcement_type | nid      |
      | Free Ice Cream Today           | Free today        | Test 1 | now     | 1      | Obituary                | 99999995 |
      | Sign Up For Benefits By Friday |                   | Test 2 | -5 day  | 1      | Memorandum              | 99999994 |
      | Early Dismissal                |                   | Test 3 | -2 day  | 1      |                         | 99999993 |
  When I am logged in as "authen_user1"
    And I am on the homepage
    And I click "Full Calendar"
    And I wait 1 seconds
    And I click "BEHAT Event Test 0"
    And I wait 1 seconds
    And I visit "/node/99999998"
    And I wait 1 seconds
    And I visit "/node/99999997"
    And I wait 1 seconds
    And I visit "/node/99999996"
  Then I am logged in as "authen_user2"
    And I visit "/announcements"
    And I wait 1 seconds
    And I visit "/node/99999995"
    And I wait 1 seconds
    And I visit "/node/99999994"
    And I wait 1 seconds
    And I visit "/node/99999993"
  Then I am logged in as a user with the "administrator" role
    And I visit "/admin/node/log"
  Then I should see the link "Calendar"
    And I should see "Announcements"
  Then I select the first autocomplete option for "authen_user2" on the "User Name" field
    And I wait for AJAX to finish
    And I press the "Apply" button
  Then I should see "Early Dismissal" in the "99999993" row
    And I should see "Sign Up For Benefits By Friday" in the "99999994" row
    And I should see "Free Ice Cream Today" in the "99999995" row
    And "Early Dismissal" should precede "Sign Up For Benefits By Friday" for the query "//td[contains(@class, 'views-field views-field-entity-id')]"
    And "Sign Up For Benefits By Friday" should precede "Free Ice Cream Today" for the query "//td[contains(@class, 'views-field views-field-entity-id')]"
    And "Free Ice Cream Today" should precede "Announcements" for the query "//td[contains(@class, 'views-field views-field-entity-id')]"
    But I should not see the link "Calendar"
  Then I select the first autocomplete option for "authen_user1" on the "User Name" field
    And I wait for AJAX to finish
    And I press the "Apply" button
    And I should see "BEHAT Event Test 3" in the "99999996" row
    And I should see "BEHAT Event Test 2" in the "99999997" row
    And I should see "BEHAT Event Test 1" in the "99999998" row
    And I should see "BEHAT Event Test 0" in the "99999999" row
    And "BEHAT Event Test 3" should precede "BEHAT Event Test 2" for the query "//td[contains(@class, 'views-field views-field-entity-id')]"
    And "BEHAT Event Test 2" should precede "BEHAT Event Test 1" for the query "//td[contains(@class, 'views-field views-field-entity-id')]"
    And "BEHAT Event Test 1" should precede "BEHAT Event Test 0" for the query "//td[contains(@class, 'views-field views-field-entity-id')]"
    And "BEHAT Event Test 0" should precede "Calendar" for the query "//td[contains(@class, 'views-field views-field-entity-id')]"
    But I should not see "Announcements"

@api @javascript
Scenario: Non-authenticated User Node Log
  Given I create "paragraph" of type "paragraph_session":
    | KEY | field_location | field_start_date | field_end_date  |  type             |
    | 10  | Vancouver, BC  | +1 hour          | +5 day          | paragraph_session |
    | 11  | Seattle, WA    | +2 hour          | +1 day          | paragraph_session |
    | 12  | Portland, OR   | +1 day           | +1 day +1 hour  | paragraph_session |
    | 13  | Phoenix, AZ    | +1 week          | +1 week +1 hour | paragraph_session |
    And I create "node" of type "event":
      | title               | field_short_title | body                | status | field_session | field_event_type | nid        |
      | BEHAT Event Test 0  | Home Page Title 0 | This is an Event 0. | 1      | 10            | General          | 99999999   |
      | BEHAT Event Test 1  | Home Page Title 1 | This is an Event 1. | 1      | 11            | Training         | 99999998   |
      | BEHAT Event Test 2  | Home Page Title 2 | This is an Event 2. | 1      | 12            | Deadlines        | 99999997   |
      | BEHAT Event Test 3  | Home Page Title 3 | This is an Event 3. | 1      | 13            |                  | 99999996   |
  When I am logged in as "creator"
    And I visit "/node/99999999"
  Then I am logged in as "approver"
    And I visit "/node/99999998"
  Then I am logged in as "sitebuilder"
    And I visit "/node/99999997"
  Then I am logged in as "admin"
    And I visit "/news/calendar"
    And I click "BEHAT Event Test 0"
    And I visit "/admin/node/log"
    And I press the "Apply" button
  Then I should not see the link "BEHAT Event Test 3"
    And I should not see the link "BEHAT Event Test 2"
    And I should not see the link "BEHAT Event Test 1"
    And I should not see the link "BEHAT Event Test 0"
    And I should not see the link "Calendar"
