Feature: Create and View Event Content
  As a Visitor to the Insider
  I want to be able to view events
  So that I can see what events are happening at the SEC

  Background:

    Given "audiences" terms:
      | name    |
      | insider |
      | lawyer  |
      And "topic" terms:
        | name             |
        | technology       |
        | hr               |
        | award programs   |
        | acquisitions     |
        | library services |
      And "office_division" terms:
        | name                |
        | dera                |
        | corporation finance |
        | ogc                 |
      And "group_club" terms:
        | name      |
        | running   |
        | cooking   |
        | ski club  |
        | bike club |
      And "top_level_group" terms:
        | name     |
        | toplevel |
        | sports   |
        | carlo    |
        | hr       |
        | sec org  |
        | news     |
      And "tags" terms:
        | name |
        | Toto |
      And "timezone" terms:
        | name     | field_abbreviation |
        | Eastern  | ET                 |
        | Central  | CT                 |
        | Mountain | MT                 |
        | Pacific  | PT                 |
        | Alaska   | AT                 |
        | Hawaii   | HT                 |
      And I create "paragraph" of type "paragraph_session":
        | KEY | field_location | field_start_date | field_end_date   | type              |
        | 101 | Texas          | +1 hour          | +2 hour          | paragraph_session |
        | 102 | SEC DC         | +2 hour          | +3 hour          | paragraph_session |
        | 103 | MA             | +3 hour          | +3 hour          | paragraph_session |
        | 104 | CA             | +1 day           | +1 day +1 hour   | paragraph_session |
        | 105 | VA             | +1 day +2 hour   | +1 day +2 hour   | paragraph_session |
        | 106 | CO             | +2 day           | +2 day +1 hour   | paragraph_session |
        | 107 | WA             | +3 day           | +3 day +1 hour   | paragraph_session |
        | 108 | Florida        | +4 day           | +4 day +1 hour   | paragraph_session |
        | 109 | Chicago        | +1 week          | +1 week +1 hour  | paragraph_session |
        | 110 | Ohio           | +1 week +1 hour  | +1 week +1 hour  | paragraph_session |
        | 111 | NH             | +1 week +2 hour  | +1 week +2 hour  | paragraph_session |
        | 112 | SEC HQ         | +1 week +3 hour  | +1 week +3 hour  | paragraph_session |
        | 113 | DC             | +2 week          | +2 week +1 hour  | paragraph_session |
        | 114 | PA             | +1 month         | +1 month +1 hour | paragraph_session |
        | 115 | NV             | +1 month +2 hour | +1 month +2 hour | paragraph_session |
        | 116 | RI             | +1 month +3 hour | +1 month +3 hour | paragraph_session |
        | 117 | XA             | +2 month         | +2 month +1 hour | paragraph_session |
        | 118 | Miami          | +3 month         | +3 month +1 hour | paragraph_session |
        | 119 | IL             | +3 month +2 hour | +3 month +2 hour | paragraph_session |
        | 120 | OH             | +4 month         | +4 month +1 hour | paragraph_session |
        | 121 | Tampa          | +5 month         | +5 month +1 hour | paragraph_session |
        | 122 | FL             | +6 month         | +6 month +1 hour | paragraph_session |
        | 123 | LA             | +7 month         | +7 month +1 hour | paragraph_session |
        | 124 | AZ             | +8 month         | +8 month +1 hour | paragraph_session |
        | 125 | SEC            | +9 month         | +9 month +1 hour | paragraph_session |
        | 126 | NY             | +1 day           | +1 day +1 hour   | paragraph_session |
        | 127 | MN             | +1 week          | +1 week +1 hour  | paragraph_session |
        | 128 | AK             | -1 day           | -1 day +1 hour   | paragraph_session |
        | 129 | HI             | -1 week          | -1 week +1 hour  | paragraph_session |

@api @javascript
Scenario: Create an Event Content
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/event"
    And I fill in the following:
      | Title           | BEHAT Test Event |
      | Home Page Title | Short Title      |
    And I select "Eastern" from "Timezone"
    And I fill in "2020-05-15 10:00:00 AM" in the "1" event start date
    And I fill in "2020-05-16 10:00:00 AM" in the "1" event end date
    And I type "Test Location" in the "1" session "Location" WYSIWYG editor
    And I type "Test Source" in the "Source" WYSIWYG editor
    And I type "Test Body" in the "Body" WYSIWYG editor
    And I select "General" from "Event Type"
    And I scroll to the top
    And I click "Exchange Details"
    And I check the box "Show add to calendar widget"
    And I select "lawyer" from "Audience"
    And I additionally select "insider" from "Audience"
    And I select "technology" from "Topic"
    And I additionally select "hr" from "Topic"
    And I select "running" from "Group/Club"
    And I additionally select "cooking" from "Group/Club"
    And I select "corporation finance" from "Division / Office"
    And I additionally select "dera" from "Division / Office"
    And I select "toplevel" from "Top Level Group"
    And I publish it
  Then I should see the heading "BEHAT Test Event"
    And I should see the text "May 15, 2020 – May 16, 2020"
    And I should see the text "10:00 am – 10:00 am ET"
    And I should see "Add to Calendar"
    But I should not see the text "Short Title"

@api @javascript
Scenario: Create an Event with an ending date occuring before the start date
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/event"
    And I fill in the following:
      | Title           | BEHAT Test Event |
      | Home Page Title | Short Title      |
    And I fill in "2020-05-15 11:00:00 AM" in the "1" event start date
    And I fill in "2020-05-15 10:00:00 AM" in the "1" event end date
    And I select "Eastern" from "Timezone"
    And I type "Test Location" in the "1" session "Location" WYSIWYG editor
    And I type "Test Source" in the "Source" WYSIWYG editor
    And I type "Test Body" in the "Body" WYSIWYG editor
    And I select "General" from "Event Type"
    And I scroll to the top
    And I click "Exchange Details"
    And I select "lawyer" from "Audience"
    And I additionally select "insider" from "Audience"
    And I select "technology" from "Topic"
    And I additionally select "hr" from "Topic"
    And I select "running" from "Group/Club"
    And I additionally select "cooking" from "Group/Club"
    And I select "corporation finance" from "Division / Office"
    And I additionally select "dera" from "Division / Office"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the text "Start date cannot occur after the end date."

@api @javascript
Scenario: Create an Event With Multiple Sessions
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/event"
    And I fill in the following:
      | Title           | BEHAT Test Multiple Sessions Event |
      | Home Page Title | Short Title                        |
    And I fill in "+5 days 08:00:00 AM" in the "1" dynamic event start date
    And I fill in "+5 days 09:00:00 AM" in the "1" dynamic event end date
    And I type "CONF RM SP1 3000" in the "1" session "Location" WYSIWYG editor
    And I press "Add Session"
    And I wait for ajax to finish
    And I fill in "+5 days 11:00:00 AM" in the "2" dynamic event start date
    And I fill in "+5 days 12:00:00 PM" in the "2" dynamic event end date
    And I press "Add Session"
    And I wait for ajax to finish
    And I fill in "+5 days 02:00:00 PM" in the "3" dynamic event start date
    And I fill in "+5 days 03:00:00 PM" in the "3" dynamic event end date
    And I press "Add Session"
    And I wait for ajax to finish
    And I fill in "+6 days 01:00:00 PM" in the "4" dynamic event start date
    And I fill in "+6 days 02:00:00 PM" in the "4" dynamic event end date
    And I press "Add Session"
    And I wait for ajax to finish
    And I fill in "+6 days 03:00:00 PM" in the "5" dynamic event start date
    And I fill in "+6 days 04:00:00 PM" in the "5" dynamic event end date
    And I press "Add Session"
    And I wait for ajax to finish
    And I fill in "+7 days 10:00:00 AM" in the "6" dynamic event start date
    And I fill in "+7 days 11:00:00 AM" in the "6" dynamic event end date
    And I type "Test Source" in the "Source" WYSIWYG editor
    And I type "Test Body" in the "Body" WYSIWYG editor
    And I select "General" from "Event Type"
    And I select "Eastern" from "Timezone"
    And I scroll to the top
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
  When I publish it
    And I visit "/events"
  Then I should see the text "8:00 AM ET"
    And I should see the text "11:00 AM ET"
    And I should see the text "2:00 PM ET"
    And I should see the text "1:00 PM ET"
    And I should see the text "3:00 PM ET"
    And I should see the text "10:00 AM ET"

@api @javascript
Scenario Outline: Mandatory Fields Populated When Creating Event
  Given I am logged in as a user with the "content_approver" role
  When I am on "/node/add/event"
    And I select "General" from "Event Type"
    And I fill in the following:
      | Title           | <Title>   |
      | Home Page Title | <H_Title> |
    And I select "<EventType>" from "Event Type"
    And I fill in "<Start>" in the "1" event start date
    And I type "<Locale>" in the "1" session "Location" WYSIWYG editor
    And I type "<Src>" in the "Source" WYSIWYG editor
    And I type "<Body>" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
  Then I should see the text 'Check this box to to allow staff to add this event to their Outlook calendar. Before checking this box, please confirm that you have set an End Date for this event in the "General" tab to the left.'
  When I select "<Top>" from "<fieldName>"
    And I select "<Level>" from "Top Level Group"
    And I publish it
  Then I should not see the text "Event <Title> has been created."

    Examples:
      | Title  | EventType | Top        | fieldName  | Level  | H_Title | Start                  | Locale | Src   | Body            |
      | Event1 | General   | technology | Topic      | sports | EV1     | 2018-11-19 02:33:00 PM | DC     | Behat |                 |
      | Event2 | Training  | technology | Topic      | sports | EV1     | 2018-11-19 02:33:00 PM | DC     |       | This is my body |
      | Event3 | Training  | technology | Topic      | sports | EV1     | 2018-11-19 02:33:00 PM |        | Behat | This is my body |
      | Event4 | Training  | technology | Topic      | sports | EV1     |                        | DC     | Behat | This is my body |
      | Event5 | Training  | technology | Topic      | sports |         | 2018-11-19 02:33:00 PM | DC     | Behat | This is my body |
      | Event6 | General   | technology | Topic      |        | EV1     | 2018-11-19 02:33:00 PM | DC     | Behat | This is my body |
      | Event7 | General   |            | Group/Club | sports | EV1     | 2018-11-19 02:33:00 PM | DC     | Behat | This is my body |
      | Event8 |           | technology | Topic      | sports | EV1     | 2018-11-19 02:33:00 PM | DC     | Behat | This is my body |
      |        | General   | technology | Topic      | sports | EV1     | 2018-11-19 02:33:00 PM | DC     | Behat | This is my body |

@api @javascript
Scenario Outline: Mandatory Fields Populated When Creating Deadlines Events
  Given I am logged in as a user with the "content_approver" role
  When I am on "/node/add/event"
    And I select "Deadlines" from "Event Type"
    And I fill in "Title" with "<Title>"
    And I fill in "Home Page Title" with "<H_Title>"
    And I fill in "<End>" in the "1" event end date
    And I type "<Src>" in the "Source" WYSIWYG editor
    And I type "<Bod>" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
  Then I should see the text 'Check this box to to allow staff to add this event to their Outlook calendar. Before checking this box, please confirm that you have set an End Date for this event in the "General" tab to the left.'
  When I select "<Top>" from "Topic"
    And I select "<Level>" from "Top Level Group"
    And I publish it
  Then I should not see the text "Event <Title> has been created."

    Examples:
      | Title  | Top        | Level  | H_Title | End                    | Src   | Bod             |
      | Event1 | technology | sports | EV1     | 2018-11-23 05:30:47 PM |       | This is my body |
      | Event2 | technology | sports | EV1     | 2018-11-23 05:30:47 PM | Behat |                 |
      | Event3 | technology | sports | EV1     |                        | Behat | This is my body |
      | Event4 | technology | sports |         | 2018-11-19 02:33:00 PM | Behat | This is my body |
      | Event5 | technology |        | EV1     | 2018-11-19 02:33:00 PM | Behat | This is my body |
      |        | technology | sports | EV1     | 2018-11-19 02:33:00 PM | Behat | This is my body |

@api
Scenario Outline: Test Event Modified Date
  Given I am logged in as a user with the "Authenticated user" role
    And I am viewing an "event" content:
      | body         | This is the body    |
      | title        | My test article     |
      | changed      | <Last_Updated_Date> |
      | published_at | <Published_Date>    |
      | status       | 1                   |
  Then I should see the text "<Date_Text>"

  Examples:
    | Last_Updated_Date   | Published_Date      | Date_Text               |
    | 2017-07-11 12:00:00 | 2017-08-11 12:00:00 | Modified: July 11, 2017 |
    | 2017-08-11 12:00:00 | 2017-08-11 12:00:00 | Created: Aug. 11, 2017  |

@api @javascript
Scenario: Edit existing event
  Given I am logged in as a user with the "content_creator" role
    And "top_level_group" terms:
      | name       | field_abbreviation |
      | group      | grp                |
      | sports     | spt                |
      | procedures |                    |
    And I create "paragraph" of type "paragraph_session":
      | KEY | field_location | field_start_date | field_end_date | type              |
      | 30  | Texas          | +2 hour          | +1 day         | paragraph_session |
      | 31  | Michigan       | +1 day           | +1 day +1 hour | paragraph_session |
    And I create "node" of type "event":
      | title                       | field_short_title | body                | field_source | field_topic | field_top_level_group | status | field_session | field_timezone_select |
      | BEHAT Test Event - Training | Home Page Title 0 | This is an Event 0. | Minnie Mouse | hr          | sports                | 1      | 30            | Central               |
      | BEHAT Test Event - General  | Home Page Title 1 | This is an Event 1. | Eeyore       | technology  | group                 | 1      | 31            | Central               |
  When I visit "/admin/content"
    And I click "Edit" in the "BEHAT Test Event - Training" row
    And I select "Training" from "Event Type"
    And I type "Mickey and " in the "Source" WYSIWYG editor
    And I press the "Save and Create New Draft" button
  Then I should see the text "Mickey and Minnie Mouse"

@api @javascript
Scenario Outline: Create all Types of Events
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/event"
    And I fill in the following:
      | Title           | BEHAT Test Event |
      | Home Page Title | Home Page Title  |
    And I fill in "edit-field-session-0-subform-field-start-date-0-value" field with "2020-05-15 10:00:00 AM"
    And I fill in "edit-field-session-0-subform-field-end-date-0-value" field with "2020-05-16 10:00:00 AM"
    And I type "Test Location" in the "1" session "Location" WYSIWYG editor
    And I select "<Type>" from "Event Type"
    And I select "<Timezone>" from "Timezone"
    And I type "Test Body" in the "Body" WYSIWYG editor
    And I type "Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I publish it
  Then I should see the heading "BEHAT Test Event"
    But I should not see the text "Home Page Title"

  Examples:
    | Type      | Timezone |
    | General   | Pacific  |
    | Deadlines | Alaska   |
    | Training  | Hawaii   |

@api
Scenario: View an Event
  Given I am logged in as a user with the "Authenticated user" role
    And I create "paragraph" of type "paragraph_session":
      | KEY  | field_location | field_start_date    | field_end_date      | type              |
      | 1234 | Texas          | 2017-11-15T17:00:00 | 2017-11-15T18:00:00 | paragraph_session |
    And I create "node" of type "event":
      | title            | field_short_title | body                    | field_source                 | status | field_session | field_timezone_select | field_contact                 | field_add_to_calendar |
      | BEHAT test event | Home Page Title   | This is the description | Source Name<br>(098)765-4321 | 1      | 1234          | Central               | Contact Name<br>(123)456-7890 | 1                     |

    # And I am viewing an "event" content:
    #   | title                 | BEHAT test event               |
    #   | field_short_title     | Home Page Title                |
    #   | body                  | This is the description        |
    #   | field_timezone_select | Central                        |
    #   | field_contact         | Contact Name<br>(123)456-7890  |
    #   | field_source          | Source Name<br>(098)765-4321   |
    #   | field_session         | 1234                           |
    #   | status                | 1                              |
  When I am on "/events/2017-11/behat-test-event"
  Then I should see the heading "BEHAT test event"
    But I should not see the text "Home Page Title"
    And I should see the text "This is the description"
    And I should see the text "Nov. 15, 2017"
    And I should see the text "5:00 pm – 6:00 pm CT"
    And I should see the text "Texas"
    And I should see "Add to Calendar"
    And I should see the heading "Details"
    And I should see the text "Contact Name"
    And I should see the text "(123)456-7890"
    And I should see the text "Source Name"
    And I should see the text "(098)765-4321"
    And I should see the text "Created:"

@api @javascript
Scenario: Delete an Event
  Given I am logged in as a user with the "administrator" role
    And "event" content:
      | title            |
      | BEHAT Event Test |
  When I visit "/admin/content"
    And I click "Edit" in the "BEHAT Event Test" row
    And I click "edit-delete"
    And I press the "Delete" button
  Then I should not see the link "BEHAT Event Test"

@api @javascript
Scenario: View Event List Page
  Given I am logged in as a user with the "Authenticated user" role
    And I create "node" of type "event":
      | title               | field_short_title | body                | field_timezone_select | status | field_session |
      | BEHAT Timezone Test | Timezone Test     | Timezone test.      | Alaska                | 1      | 110           |
      | BEHAT Event Test 0  | Home Page Title 0 | This is an Event 0. | Central               | 1      | 101           |
      | BEHAT Event Test 1  | Home Page Title 1 | This is an Event 1. | Central               | 1      | 102           |
      | BEHAT Event Test 2  | Home Page Title 2 | This is an Event 2. | Mountain              | 1      | 103           |
      | BEHAT Event Test 3  | Home Page Title 3 | This is an Event 3. | Eastern               | 1      | 104           |
      | BEHAT Event Test 4  | Home Page Title 4 | This is an Event 4. | Eastern               | 1      | 105           |
      | BEHAT Event Test 5  | Home Page Title 5 | This is an Event 5. | Pacific               | 1      | 106           |
      | BEHAT Event Test 6  | Home Page Title 6 | This is an Event 6. | Hawaii                | 1      | 107           |
      | BEHAT Event Test 7  | Home Page Title 7 | This is an Event 7. | Pacific               | 1      | 108           |
      | BEHAT Event Test 8  | Home Page Title 8 | This is an Event 8. | Eastern               | 1      | 109           |
      | BEHAT Event Test 9  | Home Page Title 8 | This is an Event 8. | Eastern               | 1      | 128           |
      | BEHAT Event Test 10 | Home Page Title 8 | This is an Event 8. | Eastern               | 1      | 129           |
  When I visit "/events"
  Then I should see the time "+1 hour" in the "BEHAT Event Test 0" row
    And I should see the time "+2 hour" in the "BEHAT Event Test 1" row
    And I should see the time "+3 hour" in the "BEHAT Event Test 2" row
    And I should see the time "+1 day" in the "BEHAT Event Test 3" row
    And I should see the time "+1 day +2 hour" in the "BEHAT Event Test 4" row
    And I should see the time "+2 day" in the "BEHAT Event Test 5" row
    And I should see the time "+3 day" in the "BEHAT Event Test 6" row
    And I should see the time "+4 day" in the "BEHAT Event Test 7" row
    And I should see the time "+1 week" in the "BEHAT Event Test 8" row
    And I should see the time "+1 week +1 hour" in the "BEHAT Timezone Test" row
    And I should see "AT" in the "BEHAT Timezone Test" row
    And I should see "CT" in the "BEHAT Event Test 0" row
    And I should see "CT" in the "BEHAT Event Test 1" row
    And I should see "MT" in the "BEHAT Event Test 2" row
    And I should see "ET" in the "BEHAT Event Test 3" row
    And I should see "ET" in the "BEHAT Event Test 4" row
    And I should see "PT" in the "BEHAT Event Test 5" row
    And I should see "HT" in the "BEHAT Event Test 6" row
    And I should see "BEHAT Event Test 0" under the "+1 hour" event date banner
    And I should see "BEHAT Event Test 1" under the "+1 hour" event date banner
    And I should see "BEHAT Event Test 4" under the "+1 day +2 hour" event date banner
    And I should see "BEHAT Event Test 8" under the "+1 week" event date banner
    And I should see "BEHAT Event Test 7" under the "+4 day" event date banner
    But I should not see the link "BEHAT Event Test 9"
    And I should not see the link "BEHAT Event Test 10"
    And "BEHAT Event Test 5" should precede "BEHAT Event Test 6" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "BEHAT Event Test 6" should precede "BEHAT Event Test 7" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "BEHAT Event Test 7" should precede "BEHAT Event Test 8" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "BEHAT Event Test 4" should precede "BEHAT Event Test 5" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "BEHAT Event Test 8" should precede "BEHAT Timezone Test" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "BEHAT Event Test 0" should precede "BEHAT Event Test 1" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "BEHAT Event Test 1" should precede "BEHAT Event Test 2" for the query "//td[contains(@class, 'views-field views-field-title')]"

@api @javascript
Scenario: Event List Filter Search
  Given I am logged in as a user with the "Authenticated user" role
    And I create "paragraph" of type "paragraph_session":
      | KEY | field_location  | field_start_date | field_end_date  | type              |
      | 33  | Vancouver, BC   | +1 hour          | +5 day          | paragraph_session |
      | 34  | Seattle, WA     | +2 hour          | +1 day          | paragraph_session |
      | 35  | Portland, OR    | +1 day           | +1 day +1 hour  | paragraph_session |
      | 36  | Phoenix, AZ     | +1 week          | +1 week +1 hour | paragraph_session |
      | 37  | Las Vegas, NV   | -1 week -1 day   | +1 week +1 hour | paragraph_session |
      | 38  | Denver, CO      | -1 hour          | +1 week +1 hour | paragraph_session |
      | 39  | Los Angeles, CA | -1 week          | +5 hour         | paragraph_session |
    And I create "node" of type "event":
      | title              | field_short_title | body                | status | field_session | field_event_type |
      | BEHAT Event Test 0 | Home Page Title 0 | This is an Event 0. | 1      | 33            | General          |
      | BEHAT Event Test 1 | Home Page Title 1 | This is an Event 1. | 1      | 34            | Training         |
      | BEHAT Event Test 2 | Home Page Title 2 | This is an Event 2. | 1      | 35            | Deadlines        |
      | BEHAT Event Test 3 | Home Page Title 3 | This is an Event 3. | 1      | 36            | General          |
      | BEHAT Event Test 4 | Home Page Title 4 | This is an Event 4. | 1      | 37            | Training         |
      | BEHAT Event Test 5 | Home Page Title 5 | This is an Event 5. | 1      | 38            | Deadlines        |
      | BEHAT Event Test 6 | Home Page Title 6 | This is an Event 6. | 1      | 39            |                  |
  When I visit "/events"
    #The following steps will test the Event Type filter (General, Deadlines, Training, Any)
    And I select "General" from "edit-field-event-type-value"
    And I press the "edit-submit-events-list" button
  Then I should see "BEHAT Event Test 0" under the "+1 hour" event date banner
    And I should see the link "BEHAT Event Test 3"
    But I should not see the link "BEHAT Event Test 1"
    And I should not see the link "BEHAT Event Test 2"
    And I should not see the link "BEHAT Event Test 4"
    And I should not see the link "BEHAT Event Test 5"
    And I should not see the link "BEHAT Event Test 6"
  When I select "Deadlines" from "edit-field-event-type-value"
    And I press the "edit-submit-events-list" button
    And I should see "BEHAT Event Test 5" under the "-1 hour" event date banner
    And I should see the link "BEHAT Event Test 2"
    But I should not see the link "BEHAT Event Test 0"
    And I should not see the link "BEHAT Event Test 6"
    And I press the "edit-reset" button
    And I select "Training" from "edit-field-event-type-value"
    And I press the "edit-submit-events-list" button
    # And I should see "BEHAT Event Test 4" under the "-1 week -1 day" event date banner
  Then I should see the link "BEHAT Event Test 1"
    And I should not see the link "BEHAT Event Test 2"
    And I should not see the link "BEHAT Event Test 6"
  When I press the "edit-reset" button
    And I select "All" from "edit-field-event-type-value"
    #The following steps will test the Start and End Date filter in combination with the Event Type filter
    And I fill in "edit-field-start-date-value" with date "-3 day"
    And I fill in "edit-field-end-date-value" with date "+6 day"
    And I press the "edit-submit-events-list" button
  Then I should see "BEHAT Event Test 0" under the "+1 hour" event date banner
    And I should see "BEHAT Event Test 1" under the "+2 hour" event date banner
    And I should see the link "BEHAT Event Test 2"
    And I should not see the link "BEHAT Event Test 3"
    And I should not see the link "BEHAT Event Test 4"
    And I should not see the link "BEHAT Event Test 5"
    And I should not see the link "BEHAT Event Test 6"
  When I select "General" from "edit-field-event-type-value"
    And I press the "edit-submit-events-list" button
  Then I should see the link "BEHAT Event Test 0"
    And I should not see the link "BEHAT Event Test 1"
    And I should not see the link "BEHAT Event Test 2"
  When I select "Deadlines" from "edit-field-event-type-value"
    And I press the "edit-submit-events-list" button
  Then I should see the link "BEHAT Event Test 2"
    And I should not see the link "BEHAT Event Test 1"
    And I should not see the link "BEHAT Event Test 0"
  When I select "Training" from "edit-field-event-type-value"
    And I press the "edit-submit-events-list" button
  Then I should see the link "BEHAT Event Test 1"
    And I should not see the link "BEHAT Event Test 2"
    And I should not see the link "BEHAT Event Test 0"

@api
Scenario: Event List Page Non Pagination
  Given I am logged in as a user with the "Authenticated user" role
    And I create "paragraph" of type "paragraph_session":
      | KEY | field_location | field_start_date | field_end_date | type              |
      | 40  | Texas          | +2 hour          | +1 day         | paragraph_session |
    And I create "node" of type "event":
      | title                                                                         | body    | field_session | status |
      | Free Ice Cream Today                                                          | Test 1  | 40            | 1      |
      | Sign Up For Benefits By Friday                                                | Test 2  | 40            | 1      |
      | Early Dismissal                                                               | Test 3  | 40            | 1      |
      | New Director of Enforcement Joins                                             | Test 4  | 40            | 1      |
      | Impacts from the Hurricane                                                    | Test 5  | 40            | 1      |
      | All Hands Meeting                                                             | Test 7  | 40            | 1      |
      | Lorem ipsum dolor sit amet, consectetur adipiscing elit.                      | Test 8  | 40            | 1      |
      | Aliquam sagittis turpis in malesuada mollis.                                  | Test 9  | 40            | 1      |
      | Pellentesque in ex non velit convallis varius.                                | Test 10 | 40            | 1      |
      | Praesent maximus felis in quam pulvinar pharetra.                             | Test 11 | 40            | 1      |
      | Cras laoreet metus et lectus mollis sollicitudin.                             | Test 12 | 40            | 1      |
      | Phasellus imperdiet libero ac metus dapibus efficitur id vitae justo.         | Test 13 | 40            | 1      |
      | Etiam eu nunc porta, elementum sem a, interdum odio.                          | Test 14 | 40            | 1      |
      | Donec viverra nibh ac tincidunt pharetra.                                     | Test 15 | 40            | 1      |
      | Nulla sit amet tellus at urna sodales vulputate.                              | Test 16 | 40            | 1      |
      | Aliquam iaculis metus non ullamcorper pulvinar.                               | Test 17 | 40            | 1      |
      | Quisque maximus elit id velit scelerisque lobortis.                           | Test 18 | 40            | 1      |
      | Praesent ultrices ipsum sit amet rutrum iaculis.                              | Test 19 | 40            | 1      |
      | Pellentesque ut erat vel sem auctor finibus.                                  | Test 20 | 40            | 1      |
      | Aliquam dictum tellus vel ornare dignissim.                                   | Test 21 | 40            | 1      |
      | Ut eget nunc ac nunc mollis aliquet quis eget mi.                             | Test 22 | 40            | 1      |
      | Fusce dapibus tortor eget ipsum ultricies lacinia.                            | Test 23 | 40            | 1      |
      | Vestibulum nec dui facilisis, condimentum turpis ut, congue sem.              | Test 24 | 40            | 1      |
      | In pharetra justo ac turpis bibendum, quis suscipit elit ullamcorper.         | Test 25 | 40            | 1      |
      | Curabitur molestie metus ut mauris venenatis, quis tincidunt lectus volutpat. | Test 26 | 40            | 1      |
      | Curabitur maximus tellus ac feugiat gravida.                                  | Test 27 | 40            | 1      |
      | Integer venenatis leo quis ante blandit, sit amet porttitor nunc dapibus.     | Test 28 | 40            | 1      |
      | Suspendisse id justo ornare, euismod odio eget, mattis quam.                  | Test 29 | 40            | 1      |
      | Vivamus finibus purus id maximus elementum.                                   | Test 30 | 40            | 1      |
      | Praesent ornare erat id metus gravida, sed efficitur eros commodo.            | Test 31 | 40            | 1      |
      | Nullam sit amet lorem vel arcu condimentum posuere in ut dui.                 | Test 32 | 40            | 1      |
      | Nulla efficitur leo vitae velit aliquet, nec consectetur ex tempor.           | Test 33 | 40            | 1      |
      | Etiam aliquet est vel tempor efficitur.                                       | Test 34 | 40            | 1      |
      | Fusce tincidunt ligula in leo pharetra, id mollis felis egestas.              | Test 35 | 40            | 1      |
      | Pellentesque porttitor dui ut vehicula consectetur.                           | Test 36 | 40            | 1      |
      | Suspendisse luctus nunc at nisl dictum, vel dignissim diam vehicula.          | Test 37 | 40            | 1      |
      | Aenean mollis turpis a risus facilisis, at feugiat dolor vehicula.            | Test 38 | 40            | 1      |
      | Sed et ipsum bibendum, malesuada neque at, fermentum nibh.                    | Test 39 | 40            | 1      |
      | Vivamus dapibus dui nec neque gravida, a vulputate libero vulputate.          | Test 40 | 40            | 1      |
      | Suspendisse egestas ex a quam dapibus, sed venenatis purus consequat.         | Test 41 | 40            | 1      |
      | Suspendisse eget massa sit amet magna vulputate semper.                       | Test 42 | 40            | 1      |
      | In non urna non odio molestie facilisis.                                      | Test 43 | 40            | 1      |
      | Mauris aliquet elit auctor ante tincidunt cursus.                             | Test 44 | 40            | 1      |
      | Aliquam fringilla mi id nibh vestibulum cursus.                               | Test 45 | 40            | 1      |
      | Vivamus sit amet purus vel urna hendrerit gravida.                            | Test 46 | 40            | 1      |
      | Nulla ac elit ac augue bibendum consequat pellentesque id est.                | Test 47 | 40            | 1      |
      | Nulla malesuada mi vel suscipit auctor.                                       | Test 48 | 40            | 1      |
      | Morbi vel libero eget nunc mollis hendrerit.                                  | Test 49 | 40            | 1      |
  When I visit "/events"
  Then I should not see the link "Next"

#sorting is disabled now
@api @javascript
Scenario: Pagination On Events List Page
  Given I create "node" of type "event":
      | title       | field_short_title | field_event_type | field_timezone_select | body             | field_source | field_topic | field_top_level_group | status | field_session |
      | Event1      | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 101           |
      | Event2      | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 102           |
      | Event3      | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 103           |
      | Event4      | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 104           |
      | Event5      | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 105           |
      | Event6      | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 106           |
      | Event7      | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 107           |
      | Event8      | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 108           |
      | Event9      | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 109           |
      | Event10     | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 110           |
      | Event11     | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 111           |
      | Event12     | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 112           |
      | Event13     | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 113           |
      | Event14     | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 114           |
      | Event15     | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 115           |
      | Event16     | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 116           |
      | Event17     | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 117           |
      | Event18     | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 118           |
      | Event19     | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 119           |
      | Event20     | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 120           |
      | Event21     | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 121           |
      | Event22     | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 122           |
      | Event23     | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 123           |
      | Event24     | events            | Training         | Eastern               | This is the body | Source       | technology  | sports                | 1      | 124           |
      | Event25     | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 125           |
      | An Event26  | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 126           |
      | The Event27 | events            | General          | Eastern               | This is the body | Source       | technology  | sports                | 1      | 127           |
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/events"
    And I select "10" from "Show"
  Then I should see the link "Page 2"
    And I should see the link "Last"
  When I click "Page 2"
    And I wait 3 seconds
  Then I should see the link "Event12"
    And I should see the link "Event17"
  When I click "Last"
    And I wait 3 seconds
  Then I should see the link "Event21"
    And I should see the link "Event25"
  When I select "All" from "Show"
  Then I should not see the text "Next"
    And I should not see the text "Last"
    And I should see the link "Event25"
# this will be enabled when sorting option is in place
    #   And I click "Title"
    #   And I wait 1 seconds
    # Then "Event1" should precede "Event2" for the query "//td[contains(@class, 'views-field views-field-title')]"
    #   And "Event5" should precede "Event6" for the query "//td[contains(@class, 'views-field views-field-title')]"
    #   And "Event9" should precede "Event10" for the query "//td[contains(@class, 'views-field views-field-title')]"
    # When I click "Page 2"
    #   And I wait 1 seconds
    # Then "Event12" should precede "Event13" for the query "//td[contains(@class, 'views-field views-field-title')]"
    #   And "Event16" should precede "Event17" for the query "//td[contains(@class, 'views-field views-field-title')]"
    #   And "Event18" should precede "Event19" for the query "//td[contains(@class, 'views-field views-field-title')]"
    #   And "Event19" should precede "Event20" for the query "//td[contains(@class, 'views-field views-field-title')]"
    # When I click "Last"
    #   And I wait 1 seconds
    # Then "Event21" should precede "Event22" for the query "//td[contains(@class, 'views-field views-field-title')]"
    #   And "Event22" should precede "Event23" for the query "//td[contains(@class, 'views-field views-field-title')]"
    #   And "Event23" should precede "Event24" for the query "//td[contains(@class, 'views-field views-field-title')]"
    #   And "Event25" should precede "An Event26" for the query "//td[contains(@class, 'views-field views-field-title')]"
    #   And "An Event26" should precede "The Event27" for the query "//td[contains(@class, 'views-field views-field-title')]"
    # When I click "Location"
    #   And I wait 1 seconds
    # Then "Tampa" should precede "Texas" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "VA" should precede "WA" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "WA" should precede "XA" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "SEC DC" should precede "SEC HQ" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    # When I click "Previous"
    #   And I wait 1 seconds
    # Then "Miami" should precede "NH" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "NV" should precede "NY" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "OH" should precede "Ohio" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "PA" should precede "RI" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "RI" should precede "SEC" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    # When I click "Page 1"
    #   And I wait 1 seconds
    # Then "AZ" should precede "CA" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "CA" should precede "Chicago" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "CO" should precede "DC" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "FL" should precede "Florida" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "IL" should precede "LA" for the query "//td[contains(@class, 'views-field views-field-field-location')]"
    #   And "LA" should precede "MA" for the query "//td[contains(@class, 'views-field views-field-field-location')]"

  #Scenario: Test for correct CK Editor in Events

@api @javascript
Scenario: Create an Event with Timezone
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/event"
    And I fill in the following:
      | Title           | BEHAT Test Event with Timezone |
      | Home Page Title | Timezone Matters               |
    And I fill in "2029-06-15 10:00:00 AM" in the "1" event start date
    And I fill in "2029-06-15 11:00:00 AM" in the "1" event end date
    And I select "Mountain" from "Timezone"
    And I select "General" from "Event Type"
    And I type "Test Location" in the "1" session "Location" WYSIWYG editor
    And I type "Test Source" in the "Source" WYSIWYG editor
    And I type "Test Body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "lawyer" from "Audience"
    And I additionally select "insider" from "Audience"
    And I select "technology" from "Topic"
    And I additionally select "hr" from "Topic"
    And I select "running" from "Group/Club"
    And I additionally select "cooking" from "Group/Club"
    And I select "corporation finance" from "Division / Office"
    And I additionally select "dera" from "Division / Office"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the heading "BEHAT Test Event with Timezone"
    And I should see "10:00 am – 11:00 am MT"
  When I visit "/"
    And I wait 1 seconds
  Then I should see "Timezone Matters"
    And I should see "10:00 AM MT"

@api @javascript
Scenario: Create content with ampersand in Title
  Given I am logged in as a user with the "Authenticated user" role
    And "event" content:
      | title                              | field_short_title | body                    | status |
      | BEHAT Event & Ampersand Test 1     | BEHAT Test 1      | This is a Behat test 1. | 1      |
      | BEHAT Event & & Ampersand Test 2   | BEHAT Test 2      | This is a Behat test 2. | 1      |
      | BEHAT Event - & - Ampersand Test 3 | BEHAT Test 3      | This is a Behat test 3. | 1      |
  When I visit "/events/behat-event-ampersand-test-1"
  Then I should see "This is a Behat test 1"
  When I visit "/events/behat-event-ampersand-test-2"
  Then I should see "This is a Behat test 2"
  When I visit "/events/behat-event-ampersand-test-3"
  Then I should see "This is a Behat test 3"
  When I visit "events/behat-event-%26-ampersand-test-1"
  Then I should see "We can't find this page or file"
  When I visit "events/behat-event-%26-%26-ampersand-test-2"
  Then I should see "We can't find this page or file"
  When I visit "events/behat-event-%26-ampersand-test-2"
  Then I should see "We can't find this page or file"
  When I am logged in as a user with the "administrator" role
    And I visit "/admin/content"
  Then I click on the element with css selector "a[href*='/events/behat-event-ampersand-test-1/edit']"
  When I visit "/admin/content"
  Then I click on the element with css selector "a[href*='/events/behat-event-ampersand-test-2/edit']"
  When I visit "/admin/content"
  Then I click on the element with css selector "a[href*='/events/behat-event-ampersand-test-3/edit']"

@api @javascript
Scenario Outline: Search an Event Using Search Text
  Given I am logged in as a user with the "content_creator" role
    And I create "paragraph" of type "paragraph_session":
      | KEY | field_location    | field_start_date | field_end_date   |
      | 41  | Not Kansas        | +7 day           | +7 day +3 hour   |
      | 42  | Senior Center     | +21 day          | +21 day +8 hour  |
      | 43  | Winterfell        | +2 day           | +2 day +2 hour   |
      | 44  | Hagrid's House    | +11 day          | +11 day +5 hour  |
      | 45  | Strawberry Fields | +14 day          | +14 day +12 hour |
    And I create "node" of type "event":
      | field_event_type | title                              | field_short_title          | body                           | field_source    | field_contact  | field_topic      | field_group_club | field_division_office | field_top_level_group | field_tags | status | field_session |
      | General          | Lions, Tigers, and Bears...Oh My!  | Somewhere Over the Rainbow | Follow the Yellow Brick Road.  | Wizard of OZ    | Dorothy        | Groups and Clubs | ski club         | ogc                   | carlo                 | Toto       | 1      | 41            |
      | General          | Community Service at Senior Center | Community Outreach         | Arts and Crafts with Seniors.  | Outreach        | Jane Doe       | hr               |                  |                       | hr                    |            | 1      | 42            |
      | General          | Winter is Coming.                  | Ominous                    | A Song of Ice and Fire.        | Game of Thrones | John Snow      | award programs   |                  |                       | sec org               |            | 1      | 43            |
      | General          | Hagrid's New Pet!                  | What is it?!               | Is it a dragon? Come find out. | Harry Potter    | Dumbledore     | acquisitions     |                  |                       | news                  |            | 1      | 44            |
      | General          | Beatles Music Appreciation Night   | No FOMO - Don't Miss Out   | Come Together.                 | The Beatles     | Paul and Ringo | library services | bike club        |                       | news                  |            | 1      | 45            |
  When I visit "/events"
    And I fill in "edit-combine" with "<input>"
    And I press the "edit-submit-events-list" button
  Then I should see the link "<result>"

  Examples:
    | input                  | definition        | result                             |
    | Community Service      | Title             | Community Service at Senior Center |
    | Toto                   | Tag               | Lions, Tigers, and Bears...Oh My!  |
    | Strawberry Fields      | Location          | Beatles Music Appreciation Night   |
    | A Song of Ice and Fire | Body              | Winter is Coming.                  |
    | Dumbledore             | Contact           | Hagrid's New Pet!                  |
    | The Beatles            | Source            | Beatles Music Appreciation Night   |
    | Acquisitions           | Topic             | Hagrid's New Pet!                  |
    | OGC                    | Division / Office | Lions, Tigers, and Bears...Oh My!  |
    | Bike Club              | Group / Club      | Beatles Music Appreciation Night   |

@api @javascript
Scenario: Multi-Session General Event
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/event"
    And I select "General" from "Event Type"
    And I fill in the following:
      | Title           | BEHAT Test Multiple Sessions Event |
      | Home Page Title | Short Title                        |
    And I fill in "2031-12-17 08:00:00 AM" in the "1" event start date
    And I fill in "2031-12-17 09:00:00 AM" in the "1" event end date
    And I type "SEC HQ SP1 Room 7000" in the "1" session "Location" WYSIWYG editor
    And I press "Add Session"
    And I wait for ajax to finish
    And I press "Add Session"
    And I wait for ajax to finish
    And I press "Add Session"
    And I wait for ajax to finish
    And I type "Source" in the "Source" WYSIWYG editor
    And I type "Body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I additionally select "hr" from "Topic"
    And I select "corporation finance" from "Division / Office"
    And I additionally select "dera" from "Division / Office"
    And I select "running" from "Group/Club"
    And I additionally select "cooking" from "Group/Club"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the heading "BEHAT Test Multiple Sessions Event"
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/news/calendar"
    And I fill in "edit-combine" with "multiple sessions"
    And I press the "edit-submit-events-list" button
    And I wait for ajax to finish
  Then I should see the text "Wednesday, December 17, 2031"
    And I should see the text "Thursday, December 18, 2031"
    And I should see the text "Friday, December 19, 2031"
    And I should see the text "Saturday, December 20, 2031"
    And I should see "8:00 AM ET" in the "SEC HQ SP1 Room 7000" row
    And I should see the text "BEHAT Test Multiple Sessions Event" in the "SEC HQ SP1 Room 7000" row
    And I should see "BEHAT Test Multiple Sessions Event" under the "2031-12-17 12:00:00" event date banner
    And I should see "BEHAT Test Multiple Sessions Event" under the "2031-12-18 12:00:00" event date banner
    And I should see "BEHAT Test Multiple Sessions Event" under the "2031-12-19 12:00:00" event date banner
    And I should see "BEHAT Test Multiple Sessions Event" under the "2031-12-20 00:00:00" event date banner

@api @javascript
Scenario: Multi-Session Training Event
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/event"
    And I select "Training" from "Event Type"
    And I fill in the following:
      | Title           | BEHAT Test Multiple Sessions Event |
      | Home Page Title | Short Title                        |
    And I fill in "+5 days 06:00:00 PM" in the "1" dynamic event start date
    And I type "SEC HQ SP1 Room 7000" in the "1" session "Location" WYSIWYG editor
    # By not entering the End Date/Time here, this is a negative test to test that the end date is not required
    And I press "Add Session"
    And I wait for ajax to finish
    And I type "Source" in the "Source" WYSIWYG editor
    And I type "Body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I additionally select "hr" from "Topic"
    And I select "corporation finance" from "Division / Office"
    And I additionally select "dera" from "Division / Office"
    And I select "running" from "Group/Club"
    And I additionally select "cooking" from "Group/Club"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the heading "BEHAT Test Multiple Sessions Event"
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/news/calendar"
    And I fill in "edit-combine" with "multiple sessions"
    And I press the "edit-submit-events-list" button
    And I wait for ajax to finish
  Then I should see "6:00 PM ET" in the "SEC HQ SP1 Room 7000" row
    And I should see the text "BEHAT Test Multiple Sessions Event" in the "SEC HQ SP1 Room 7000" row

@api @javascript
Scenario: Multi-Session Deadlines Event
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/event"
    And I select "Deadlines" from "Event Type"
    And I fill in the following:
      | Title           | BEHAT Multiple Sessions Deadline Event |
      | Home Page Title | Short Title                            |
    And I fill in "2031-12-16 09:00:00 AM" in the "1" event end date
    And I scroll "#edit-body-wrapper" into view
    And I type "Body" in the "Body" WYSIWYG editor
    And I type "Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I check the box "Show add to calendar widget"
    And I select "technology" from "Topic"
    And I additionally select "hr" from "Topic"
    And I select "corporation finance" from "Division / Office"
    And I additionally select "dera" from "Division / Office"
    And I select "running" from "Group/Club"
    And I additionally select "cooking" from "Group/Club"
    And I select "sports" from "Top Level Group"
    And I scroll to the top
    And I click "General"
    And I press "Add Session"
    And I wait for ajax to finish
    And I scroll ".field--name-field-session" into view
    And I press "Add Session"
    And I wait for ajax to finish
    And I publish it
  Then I should see the heading "BEHAT Multiple Sessions Deadline Event"
    And I should see the "a" element with the "id" attribute set to "ics_invite-1" in the "insider_content" region
    And I should see the "a" element with the "id" attribute set to "ics_invite-2" in the "insider_content" region
    And I should see the "a" element with the "id" attribute set to "ics_invite-3" in the "insider_content" region
    And I should see "Add to Calendar"
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/news/calendar"
    And I fill in "edit-combine" with "multiple sessions"
    And I press the "edit-submit-events-list" button
    And I wait for ajax to finish
  Then I should see the text "Tuesday, December 16, 2031"
    And I should see the text "Wednesday, December 17, 2031"
    And I should see the text "Thursday, December 18, 2031"
    And I should see "9:00 AM ET" in the "BEHAT Multiple Sessions Deadline Event" row
    And I should see "BEHAT Multiple Sessions Deadline Event" under the "2031-12-16 12:00:00" event date banner
    And I should see "BEHAT Multiple Sessions Deadline Event" under the "2031-12-17 12:00:00" event date banner
    And I should see "BEHAT Multiple Sessions Deadline Event" under the "2031-12-18 00:00:00" event date banner

# Groups and Clubs scenarios are part of work for DI-4447 for 2.5, however PO requested to not have it deployed for now so will comment these out until Groups and Clubs block is deployed
#@api @javascript
#Scenario: Create Groups and Clubs Event
#  Given I am logged in as a user with the "content_approver" role
#  When I visit "/node/add/event"
#    And I fill in the following:
#      | Title           | BEHAT GC Test Event      |
#      | Home Page Title | Basketball Club Practice |
#    And I fill in "2029-06-15 10:00:00 AM" in the "1" event start date
#    And I fill in "2029-06-15 11:00:00 AM" in the "1" event end date
#    And I select "Mountain" from "Timezone"
#    And I select "General" from "Event Type"
#    And I type "YMCA" in the "1" session "Location" WYSIWYG editor
#    And I type "Test Source" in the "Source" WYSIWYG editor
#    And I type "Bring your own water" in the "Body" WYSIWYG editor
#    And I scroll to the top
#    And I click "Exchange Details"
#    And I select "lawyer" from "Audience"
#    And I additionally select "insider" from "Audience"
#    And I select "Groups and Clubs" from "Topic"
#    And I additionally select "hr" from "Topic"
#    And I select "running" from "Group/Club"
#    And I additionally select "cooking" from "Group/Club"
#    And I select "corporation finance" from "Division / Office"
#    And I additionally select "dera" from "Division / Office"
#    And I select "sports" from "Top Level Group"
#    And I publish it
#  Then I should see the heading "BEHAT GC Test Event"
#  When I visit "/sec-organization/groups-and-clubs"
#  Then I should see the heading "Upcoming Events"
#    And I should see "15 JUN" in the "gc_events" region
#    And I should see "Basketball Club Practice" in the "gc_events" region
#    And I should see "10:00 AM MT" in the "gc_events" region
#    And I should see "YMCA" in the "gc_events" region
#  When I visit "/"
#  Then I should see the heading "Calendar"
#    And I should see "15 JUN" in the "hp_genevents" region
#    And I should see "Basketball Club Practice" in the "hp_genevents" region
#    And I should see "10:00 AM MT" in the "hp_genevents" region
#    And I should see "YMCA" in the "hp_genevents" region
#  When I click on the element with css selector "#quicktabs-events > ul > li:nth-child(2)"
#  Then I should not see "Basketball Club Practice" in the "hp_trainevents" region
#  When I click on the element with css selector "#quicktabs-events > ul > li:nth-child(3)"
#  Then I should not see the text "Basketball Club Practice" in the "hp_deadevents" region

#@api @javascript
#Scenario: View Groups and Clubs Events
#  Given I am logged in as a user with the "Authenticated user" role
#    And I create "paragraph" of type "paragraph_session":
#    	  | uuid | field_location		| field_start_date	| field_end_date		| type 					      |
#    	  | 46	 | Silverton  			| +7 day 				    | +7 day +3 hour		| paragraph_session 	|
#    	  | 47	 | Durango       		| +21 day 				  | +21 day +8 hour		| paragraph_session 	|
#    	  | 48	 | Alberta   			  | +2 day 				    | +2 day +2 hour		| paragraph_session 	|
#    	  | 49	 |              		| +11 day 				  | +11 day +5 hour		| paragraph_session 	|
#    	  | 50	 | Moab             | +14 day 				  | +14 day +12 hour	| paragraph_session	  |
#    And "event" content:
#    	  |	field_event_type | title											        |	field_short_title				                     | body 										      |	field_source	 | field_contact | field_topic 		  | field_group_club |	field_division_office |	field_top_level_group	|	field_tags	|	status | field_session	|
#    	  |	General				   | Lions, Tigers, and Bears...Oh My!	| Free Veggies Day                             | Follow the Yellow Brick Road.	|	Wizard of OZ	 | Dorothy			 | Groups and Clubs | ski club				 |	ogc                  	|	carlo							    |	Toto			  |	1			 | 46					    |
#    	  |	Training				 | Community Service at Senior Center | Agile Methodology  			                     | Arts and Crafts with Seniors.	|	Outreach			 | Jane Doe			 | Groups and Clubs |							     |												|	hr             			  |					    |	1			 | 47					    |
#    	  |	Training				 | Winter is Coming.							    | How to Train Your Squirrel                   | A Song of Ice and Fire.				|	Game of Thrones| John Snow		 | Groups and Clubs	|							     |												|	sec org         			|					    |	1			 | 48					    |
#    	  |	Deadlines				 | Hagrid's New Pet!							    | Complete LEAP Training on Telework           | Is it a dragon? Come find out. |	Harry Potter	 | Dumbledore		 | Groups and Clubs	|							     |												|	news							    |					    |	1			 | 49					    |
#    	  |	General				   | Beatles Music Appreciation Night	  | Bring Your Emotional Support Pet to Work Day | Come Together.							    |	The Beatles		 | Paul and Ringo| Groups and Clubs | bike club			   |												|	news							    |					    |	1			 | 50					    |
#  When I visit "/sec-organization/groups-and-clubs"
#  Then I should see the heading "Groups and Clubs"
#    And I should see "Free Veggies Day" in the "gc_events" region
#    And I should see "Agile Methodology" in the "gc_events" region
#    And I should see "How to Train Your Squirrel" in the "gc_events" region
#    And I should see "Complete LEAP Training on Telework" in the "gc_events" region
#    And I should see "Bring Your Emotional Support Pet to Work Day" in the "gc_events" region
#  When I click "How to Train Your Squirrel"
#  Then I should see the text "Winter is Coming."
#    And I should see the text "John Snow"
#    And I should see the text "A Song of Ice and Fire"
#    And I should see the text "Game of Thrones"
#  When I visit "/"
#  Then I should see "Free Veggies Day" in the "hp_genevents" region
#    And I should see "Bring Your Emotional Support Pet to Work Day" in the "hp_genevents" region
#    And I should not see "How to Train Your Squirrel" in the "hp_genevents" region
#  When I click on the element with css selector "#quicktabs-events > ul > li:nth-child(2)"
#  Then I should see "Agile Methodology" in the "hp_trainevents" region
#    And I should see "How to Train Your Squirrel" in the "hp_trainevents" region
#    And I should not see "Complete LEAP Training on Telework" in the "hp_trainevents" region
#  When I click on the element with css selector "#quicktabs-events > ul > li:nth-child(3)"
#  Then I should see "Complete LEAP Training on Telework" in the "hp_deadevents" region
#    And I should not see "Agile Methodology" in the "hp_deadevents" region
#    And I should not see "Bring Your Emotional Support Pet to Work Day" in the "hp_deadevents" region

@api @javascript
Scenario: Save Previously Published General Events As Draft Then Republish
  Given I create "paragraph" of type "paragraph_session":
    | KEY | field_location | field_start_date    | field_end_date      |
    | 51  | Waterfront     | 2025-07-04T17:00:00 | 2025-07-04T21:00:00 |
    And I create "node" of type "event":
      | title                      | field_short_title   | field_event_type | body               | field_source | field_topic | field_top_level_group | status | field_session | field_timezone_select | field_override_modified_date | moderation_state |
      | BEHAT Test Event - General | Crab Eating Contest | General          | This is an Event 1 | Eeyore       | technology  | sports                | 1      | 51            | Central               | 0000-00-00T00:00:00          | published        |
  When I am logged in as a user with the "content_approver" role
    And I go to the homepage
  Then I should see "Crab Eating Contest" in the "hp_genevents" region
    And I should see "Waterfront" in the "hp_genevents" region
    And I should see "4 JUL" in the "hp_genevents" region
    And I should see "5:00 PM CT" in the "hp_genevents" region
  When I visit "/events/general/2025-07/behat-test-event-general/edit"
    And I fill in the following:
      | Title           | New Title   |
      | Home Page Title | Short Title |
    And I fill in "2025-06-16 10:00:00 AM" in the "1" event start date
    And I fill in "2025-06-16 11:00:00 AM" in the "1" event end date
    And I select "Eastern" from "Timezone"
    And I type "Virtually from " in the "1" session "Location" WYSIWYG editor
    And I press the "Save and Create New Draft" button
  Then I should see the heading "New Title"
    And I should see the text "June 16, 2025"
    And I should see the text "10:00 am – 11:00 am ET"
    And I should see the text "Virtually from Waterfront"
  When I go to the homepage
  Then I should not see "Short Title" in the "hp_genevents" region
    But I should see "Crab Eating Contest" in the "hp_genevents" region
    And I should not see "Virtually from" in the "hp_genevents" region
    But I should see "Waterfront" in the "hp_genevents" region
    And I should not see "16 JUN" in the "hp_genevents" region
    But I should see "4 JUL" in the "hp_genevents" region
    And I should not see "10:00 AM ET" in the "hp_genevents" region
    But I should see "5:00 PM CT" in the "hp_genevents" region
  When I click on the element with css selector "#qt-events-ui-tabs1 > div > div.views-element-container > div > footer > div > a"
  Then I should see the heading "Calendar"
    And I should see the text "Friday, July 4, 2025"
    And I should not see the text "New Title"
    And I should not see the text "Monday, June 16, 2025"
    And I should see "5:00 PM CT" in the "BEHAT Test Event - General" row
    And I should see "Waterfront" in the "BEHAT Test Event - General" row
    And I should see "BEHAT Test Event - General" under the "2025-07-04 12:00:00" event date banner
    And I click "BEHAT Test Event - General"
    And I should not see the text "New Title"
    And I should not see the text "June 16, 2025"
    And I should not see the text "10:00 am – 11:00 am ET"
    And I should not see the text "Virtually from"
  When I visit "/events/general/2025-07/behat-test-event-general/edit"
    And I scroll to the bottom
    And I publish it
    And I go to the homepage
  Then I should see "Short Title" in the "hp_genevents" region
    But I should not see "Crab Eating Contest" in the "hp_genevents" region
    And I should see "Virtually from Waterfront" in the "hp_genevents" region
    And I should see "16 JUN" in the "hp_genevents" region
    But I should not see "4 JUL" in the "hp_genevents" region
    And I should see "10:00 AM ET" in the "hp_genevents" region
    But I should not see "5:00 PM CT" in the "hp_genevents" region
  When I click on the element with css selector "#qt-events-ui-tabs1 > div > div.views-element-container > div > footer > div > a"
  Then I should not see the text "Friday, July 4, 2025"
    And I should not see the text "Crab Eating Contest"
    And I should not see the text "5:00 PM CT"
    And I should see "New Title"
    And I should see the text "Monday, June 16, 2025"
    And I should see "Virtually from Waterfront" in the "New Title" row
    And I should see "New Title" under the "2025-06-16 12:00:00" event date banner
    And I should see "10:00 AM ET" in the "New Title" row
  When I click "New Title"
  Then I should not see the text "Crab Eating Contest"
    And I should not see the text "July 4, 2025"
    And I should see the heading "New Title"
    And I should see the text "June 16, 2025"
    And I should see the text "10:00 am – 11:00 am ET"
    And I should see the text "Virtually from Waterfront"

@api @javascript
Scenario: Save Previously Published Training Events As Draft Then Republish
  Given I create "paragraph" of type "paragraph_session":
    | KEY | field_location | field_start_date    | field_end_date      |
    | 52  | Miami          | 2025-08-12T17:00:00 | 2025-08-12T18:00:00 |
    And I create "node" of type "event":
      | title                       | field_short_title    | field_event_type | body               | field_source | field_topic | field_top_level_group | status | field_session | field_timezone_select | field_override_modified_date | moderation_state |
      | BEHAT Test Event - Training | Summer Training Camp | Training         | This is an Event 2 | Minnie Mouse | hr          | sports                | 1      | 52            | Eastern               | 0000-00-00T00:00:00          | published        |
  When I am logged in as a user with the "content_approver" role
    And I go to the homepage
    And I click on the element with css selector "#quicktabs-events > ul > li:nth-child(2)"
  Then I should see "Summer Training Camp" in the "hp_trainevents" region
    And I should see "Miami" in the "hp_trainevents" region
    And I should see "12 AUG" in the "hp_trainevents" region
    And I should see "5:00 PM ET" in the "hp_trainevents" region
  When I visit "/events/training/2025-08/behat-test-event-training/edit"
    And I fill in the following:
      | Title           | Full Title  |
      | Home Page Title | Short Title |
    And I select "Training" from "Event Type"
    And I fill in "2025-06-16 10:00:00 AM" in the "1" event start date
    And I fill in "2025-06-16 11:00:00 AM" in the "1" event end date
    And I select "Mountain" from "Timezone"
    And I type "Virtually from " in the "1" session "Location" WYSIWYG editor
    And I press the "Save and Create New Draft" button
  Then I should see the heading "Full Title"
    And I should see the text "June 16, 2025"
    And I should see the text "10:00 am – 11:00 am MT"
    And I should see the text "Virtually from Miami"
  When I go to the homepage
    And I click on the element with css selector "#quicktabs-events > ul > li:nth-child(2)"
  Then I should not see "Short Title" in the "hp_trainevents" region
    But I should see "Summer Training Camp" in the "hp_trainevents" region
    And I should not see "Virtually from" in the "hp_trainevents" region
    But I should see "Miami" in the "hp_trainevents" region
    And I should not see "16 JUN" in the "hp_trainevents" region
    But I should see "12 AUG" in the "hp_trainevents" region
    And I should not see "10:00 AM MT" in the "hp_trainevents" region
    But I should see "5:00 PM ET" in the "hp_trainevents" region
  When I click on the element with css selector "#qt-events-ui-tabs2 > div > div.views-element-container > div > footer > div > a"
  Then I should see the heading "Calendar"
    And I should see the text "Tuesday, August 12, 2025"
    And I should not see the text "Full Title"
    And I should not see the text "Monday, June 16, 2025"
    And I should see "5:00 PM ET" in the "BEHAT Test Event - Training" row
    And I should see "Miami" in the "BEHAT Test Event - Training" row
    And I should see "BEHAT Test Event - Training" under the "2025-08-12 12:00:00" event date banner
    And I click "BEHAT Test Event - Training"
    And I should not see the text "Full Title"
    And I should not see the text "June 16, 2025"
    And I should not see the text "10:00 am – 11:00 am MT"
    And I should not see the text "Virtually from"
  When I visit "/events/training/2025-08/behat-test-event-training/edit"
    And I scroll to the bottom
    And I publish it
    And I go to the homepage
    And I click on the element with css selector "#quicktabs-events > ul > li:nth-child(2)"
  Then I should see "Short Title" in the "hp_trainevents" region
    But I should not see "Summer Training Camp" in the "hp_trainevents" region
    And I should see "Virtually from Miami" in the "hp_trainevents" region
    And I should see "16 JUN" in the "hp_trainevents" region
    But I should not see "12 AUG" in the "hp_trainevents" region
    And I should see "10:00 AM MT" in the "hp_trainevents" region
    But I should not see "5:00 PM ET" in the "hp_trainevents" region
  When I click on the element with css selector "#qt-events-ui-tabs2 > div > div.views-element-container > div > footer > div > a"
  Then I should not see the text "Tuesday, August 12, 2025"
    And I should not see the text "Summer Training Camp"
    And I should not see the text "5:00 PM ET"
    And I should see "Full Title"
    And I should see the text "Monday, June 16, 2025"
    And I should see "Virtually from Miami" in the "Full Title" row
    And I should see "Full Title" under the "2025-06-16 12:00:00" event date banner
    And I should see "10:00 AM MT" in the "Full Title" row
  When I click "Full Title"
  Then I should not see the text "Summer Training Camp"
    And I should not see the text "August 12, 2025"
    And I should see the heading "Full Title"
    And I should see the text "June 16, 2025"
    And I should see the text "10:00 am – 11:00 am MT"
    And I should see the text "Virtually from Miami"

@api @javascript
Scenario: Save Previously Published Deadlines Event As Draft Then Republish
  Given I create "paragraph" of type "paragraph_session":
    | KEY | field_start_date    |
    | 53  | 2025-04-15T12:00:00 |
    And I create "node" of type "event":
      | title                        | field_short_title | field_event_type | body               | field_source | field_topic | field_top_level_group | status | field_session | field_timezone_select | field_override_modified_date | moderation_state |
      | BEHAT Test Event - Deadlines | File Your Taxes   | Deadlines        | This is an Event 3 | Pluto        | hr          | sports                | 1      | 53            | Pacific               | 0000-00-00T00:00:00          | published        |
  When I am logged in as a user with the "content_approver" role
    And I go to the homepage
    And I click on the element with css selector "#quicktabs-events > ul > li:nth-child(3)"
  Then I should see "File Your Taxes" in the "hp_deadevents" region
    And I should see "15 APR" in the "hp_deadevents" region
    And I should see "12:00 PM PT" in the "hp_deadevents" region
  When I visit "/events/deadlines/2025-04/behat-test-event-deadlines/edit"
    And I fill in the following:
      | Title           | Long Title  |
      | Home Page Title | Short Title |
    And I select "Deadlines" from "Event Type"
    And I fill in "2025-07-15 10:00:00 AM" in the "1" event end date
    And I select "Hawaii" from "Timezone"
    And I press the "Save and Create New Draft" button
  Then I should see the heading "Long Title"
    And I should see the text "July 15, 2025"
    And I should see the text "10:00 am HT"
  When I go to the homepage
    And I click on the element with css selector "#quicktabs-events > ul > li:nth-child(3)"
  Then I should not see "Short Title" in the "hp_deadevents" region
    But I should see "File Your Taxes" in the "hp_deadevents" region
    And I should not see "15 JUL" in the "hp_deadevents" region
    But I should see "15 APR" in the "hp_deadevents" region
    And I should not see "10:00 AM HT" in the "hp_deadevents" region
    But I should see "12:00 PM PT" in the "hp_deadevents" region
  When I click on the element with css selector "#qt-events-ui-tabs3 > div > div.views-element-container > div > footer > div > a"
  Then I should see the heading "Calendar"
    And I should see the text "Tuesday, April 15, 2025"
    And I should not see the text "Long Title"
    And I should not see the text "Tuesday, July 15, 2025"
    And I should see "12:00 PM PT" in the "BEHAT Test Event - Deadlines" row
    And I should see "BEHAT Test Event - Deadlines" under the "2025-04-15 12:00:00" event date banner
    And I click "BEHAT Test Event - Deadlines"
    And I should not see the text "Full Title"
    And I should not see the text "July 15, 2025"
    And I should not see the text "10:00 am HT"
  When I visit "/events/deadlines/2025-04/behat-test-event-deadlines/edit"
    And I scroll to the bottom
    And I publish it
    And I go to the homepage
    And I click on the element with css selector "#quicktabs-events > ul > li:nth-child(3)"
  Then I should see "Short Title" in the "hp_deadevents" region
    But I should not see "File Your Taxes" in the "hp_deadevents" region
    And I should see "15 JUL" in the "hp_deadevents" region
    But I should not see "15 APR" in the "hp_deadevents" region
    And I should see "10:00 AM HT" in the "hp_deadevents" region
    But I should not see "12:00 PM PT" in the "hp_deadevents" region
  When I click on the element with css selector "#qt-events-ui-tabs3 > div > div.views-element-container > div > footer > div > a"
  Then I should not see the text "Tuesday, April 15, 2025"
    And I should not see the text "File Your Taxes"
    And I should not see the text "12:00 PM PT"
    And I should see "Long Title"
    And I should see the text "Tuesday, July 15, 2025"
    And I should see "Long Title" under the "2025-07-15 12:00:00" event date banner
    And I should see "10:00 AM HT" in the "Long Title" row
  When I click "Long Title"
  Then I should not see the text "File Your Taxes"
    And I should not see the text "April 15, 2025"
    And I should see the heading "Long Title"
    And I should see the text "July 15, 2025"
    And I should see the text "10:00 am HT"

@api @javascript
Scenario: Events Override Modified Date Update
  Given I create "paragraph" of type "paragraph_session":
    | KEY | field_location | field_start_date    | field_end_date      |
    | 54  | Miami          | 2025-08-12T17:00:00 | 2025-08-12T18:00:00 |
    And I create "node" of type "event":
      | title            | field_short_title    | field_event_type | body               | field_source | field_topic | field_top_level_group | status | field_session | field_timezone_select | moderation_state | published_at        | changed |
      | BEHAT Test Event | Summer Training Camp | General          | This is an Event 1 | Minnie Mouse | hr          | sports                | 1      | 54            | Eastern               | published        | 2020-07-03T16:00:05 | -5 day  |
  When I am logged in as a user with the "Administrator" role
    And I am on "/events/general/2025-08/behat-test-event/edit"
    # Checking for usage of published date
  Then I should see the "input" element with the "value" attribute set to "2020-07-03" in the "published_on" region
  When I click secondary option "Override Modified Date"
    And I fill in the following:
      | edit-field-override-modified-date-0-value-date | 11/29/2021 |
      | edit-field-override-modified-date-0-value-time | 01:00:00AM |
    And I publish it
  Then I should see the text "Event BEHAT Test Event has been updated."
    And I should see the text "Modified: Nov. 29, 2021"
  When I visit "/events/general/2025-08/behat-test-event/edit"
  Then I should see the "input" element with the "value" attribute set to "2020-07-03" in the "published_on" region
  When I click secondary option "Override Modified Date"
    And I fill in the following:
      | edit-field-override-modified-date-0-value-date | 12/01/2021 |
      | edit-field-override-modified-date-0-value-time | 00:01:00AM |
    And I publish it
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/events/general/2025-08/behat-test-event"
  Then I should see the heading "BEHAT Test Event"
    And I should see the text "Aug. 12, 2025"
    And I should see the text "Miami"
    And I should see the text "This is an Event 1"
    And I should see the text "Minnie Mouse"
    And I should see the text "Modified: Dec. 1, 2021"

@api @javascript
Scenario: Events Published Date Doesn't Update When Republish
  Given I create "paragraph" of type "paragraph_session":
    | KEY | field_location | field_start_date    | field_end_date      |
    | 55  | Miami          | 2025-08-12T17:00:00 | 2025-08-12T18:00:00 |
    And I create "node" of type "event":
      | title            | field_short_title | field_event_type | body             | field_source | field_topic | field_top_level_group | status | field_session | field_timezone_select | moderation_state | published_at        | changed |
      | BEHAT Test Event | Summer Camp       | General          | This is an Event | Minnie Mouse | hr          | sports                | 1      | 55            | Eastern               | published        | 2020-07-03T16:00:05 | -5 day  |
  When I am logged in as a user with the "administrator" role
    And I am on "/events/general/2025-08/behat-test-event/edit"
  # Checking for usage of published date
  Then I should see the "input" element with the "value" attribute set to "2020-07-03" in the "published_on" region
  When I publish it
  Then I should see the text "Event BEHAT Test Event has been updated."
  When I am on "/events/general/2025-08/behat-test-event/edit"
  # Checking for no date updating when republish
  Then I should see the "input" element with the "value" attribute set to "2020-07-03" in the "published_on" region

@api @javascript
Scenario: Validate Persistence of Event Date Time Picker
  Given I am logged in as a user with the "content_creator" role
  When I visit "/node/add/event"
    And I fill in the following:
      | Title           | BEHAT Test Event |
      | Home Page Title | Short Title      |
    And I select "Eastern" from "Timezone"
    And I fill in "2021-05-15 10:00:00 AM" in the "1" event start date
    And I fill in "2021-05-16 11:00:00 AM" in the "1" event end date
    And I click on the element with css selector "#edit-field-session-0-subform-field-start-date-0-value"
    And I type "Test Location" in the "1" session "Location" WYSIWYG editor
    And the "edit-field-session-0-subform-field-start-date-0-value" field should contain "2021-05-15 10:00:00 AM"
    And I type "Test Source" in the "Source" WYSIWYG editor
    And I type "Test Body" in the "Body" WYSIWYG editor
    And I select "General" from "Event Type"
    And I scroll to the top
    And I click "Exchange Details"
    And I select "lawyer" from "Audience"
    And I select "technology" from "Topic"
    And I select "running" from "Group/Club"
    And I select "corporation finance" from "Division / Office"
    And I select "toplevel" from "Top Level Group"
    And I press the "Save and Create New Draft" button
  Then I should see the text "10:00 am –"
    And I should see the text "11:00 am ET"
  When I am on "/events/general/2021-05/behat-test-event/edit"
    And I click on the element with css selector "#edit-field-session-0-subform-field-start-date-0-value"
  Then the "edit-field-session-0-subform-field-start-date-0-value" field should contain "2021-05-15 10:00:00 AM"
  When I click on the element with css selector "#edit-field-session-0-subform-field-end-date-0-value"
  Then the "edit-field-session-0-subform-field-end-date-0-value" field should contain "2021-05-16 11:00:00 AM"

@api
Scenario: Viewing Upcoming Events For Communities of Practice
  Given I am logged in as a user with the "Authenticated user" role
    And I create "paragraph" of type "paragraph_session":
      | KEY  | field_location | field_start_date    | field_end_date      | type              |
      | 1231 | Texas          | 2031-01-15T07:00:00 | 2031-01-15T08:00:00 | paragraph_session |
      | 1232 | Alabama        | 2031-02-16T17:00:00 | 2031-02-16T18:00:00 | paragraph_session |
      | 1233 | Kentucky       | 2031-04-17T19:00:00 | 2031-04-17T20:00:00 | paragraph_session |
      | 1234 | Iowa           | 2031-06-18T19:30:00 | 2031-06-18T20:00:00 | paragraph_session |
      | 1235 | Indiana        | 2031-07-19T20:00:00 | 2031-07-19T21:00:00 | paragraph_session |
      | 1236 | Ohio           | 2031-08-20T20:45:00 | 2031-08-20T22:00:00 | paragraph_session |
      | 1247 | Illinois       | 2031-10-21T17:15:00 | 2031-10-21T18:00:00 | paragraph_session |
      | 1248 | Michigan       | now                 | +1 hour             | paragraph_session |
      | 1249 | Colorado       | -2 hour             | -1 hour             | paragraph_session |
      | 1240 | Idaho          | -26 hour            | -25 hour            | paragraph_session |
      | 1241 | Wisconsin      | 2031-11-22T08:15:00 | 2031-11-22T18:00:00 | paragraph_session |
    And I create "node" of type "event":
      | title               | field_short_title | body                    | field_source                 | status | field_session | field_timezone_select | field_contact         | field_topic             | field_event_type | field_top_level_group |
      | BEHAT test event 1  | Monday            | This is the description | Source Name<br>(098)765-4321 | 1      | 1231          | Eastern               | Contact (123)456-7890 | Communities of Practice | General          | sports                |
      | BEHAT test event 2  | Tuesday           | This is the description | Source Name<br>(098)765-4321 | 1      | 1232          | Hawaii                | Contact (123)456-7890 | Communities of Practice | Datelines        | sports                |
      | BEHAT test event 3  | Wednesday         | This is the description | Source Name<br>(098)765-4321 | 1      | 1233          | Pacific               | Contact (123)456-7890 | Communities of Practice | Training         | hr                    |
      | BEHAT test event 4  | Thursday          | This is the description | Source Name<br>(098)765-4321 | 1      | 1234          | Alaska                | Contact (123)456-7890 | Communities of Practice | General          | hr                    |
      | BEHAT test event 5  | Friday            | This is the description | Source Name<br>(098)765-4321 | 1      | 1235          | Mountain              | Contact (123)456-7890 | Communities of Practice | General          | hr                    |
      | BEHAT test event 6  | Saturday          | This is the description | Source Name<br>(098)765-4321 | 1      | 1236          | Central               | Contact (123)456-7890 |                         | General          | hr                    |
      | BEHAT test event 7  | Sunday            | This is the description | Source Name<br>(098)765-4321 | 1      | 1247          | Pacific               | Contact (123)456-7890 | award programs          | Training         | sports                |
      | BEHAT test event 8  | Someday           | This is the description | Source Name<br>(098)765-4321 | 1      | 1248          | Central               | Contact (123)456-7890 | Communities of Practice | Training         | hr                    |
      | BEHAT test event 9  | Humpday           | This is the description | Source Name<br>(098)765-4321 | 1      | 1249          | Central               | Contact (123)456-7890 | Communities of Practice | Training         | hr                    |
      | BEHAT test event 10 | Vacation Day      | This is the description | Source Name<br>(098)765-4321 | 1      | 1240          | Central               | Contact (123)456-7890 | Communities of Practice | Training         | hr                    |
      | BEHAT test event 11 | Sick Day          | This is the description | Source Name<br>(098)765-4321 | 1      | 1241          | Central               | Contact (123)456-7890 | Communities of Practice | Training         | hr                    |
  When I am on "/communities-practice-events"
  Then I should see the heading "Upcoming Events"
    And I should see the link "BEHAT test event 1"
    And I should see the link "BEHAT test event 2"
    And I should see the link "BEHAT test event 3"
    And I should see the link "BEHAT test event 4"
    And I should see the link "BEHAT test event 5"
    And I should not see the link "BEHAT test event 6"
    And I should see the link "BEHAT test event 8"
    And I should see the link "BEHAT test event 9"
    And I should see the link "BEHAT test event 11"
    And I should not see the link "BEHAT test event 7"
    And I should not see the link "BEHAT test event 10"
    And I should see the text "7:00 AM (ET) - Jan. 15"
    And I should see the text "5:00 PM (HT) - Feb. 16"
    And I should see the text "7:00 PM (PT) - Apr. 17"
    And I should see the text "7:30 PM (AT) - Jun. 18"
    And I should see the text "8:00 PM (MT) - Jul. 19"
    And I should see the text "8:15 AM (CT) - Nov. 22"
    And I should not see the text "8:45 PM (CT) - Aug. 20"
    And I should not see the text "Aug. 20"
    And I should not see the text "5:15 PM - Oct. 21"
    And I should not see the text "Oct. 21"
    And I should see the link "BEHAT test event 8" before I see the link "BEHAT test event 1" in the "comm_practice" region
    And I should see the link "BEHAT test event 1" before I see the link "BEHAT test event 2" in the "comm_practice" region
    And I should see the link "BEHAT test event 2" before I see the link "BEHAT test event 3" in the "comm_practice" region
    And I should see the link "BEHAT test event 3" before I see the link "BEHAT test event 4" in the "comm_practice" region
    And I should see the link "BEHAT test event 4" before I see the link "BEHAT test event 5" in the "comm_practice" region
    And I should see the link "BEHAT test event 9" before I see the link "BEHAT test event 8" in the "comm_practice" region

@api
Scenario: Viewing No Upcoming Events For Communities of Practice
  Given I am logged in as a user with the "Authenticated user" role
  When I am on "/communities-practice-events"
  Then I should see the text "There are no Communities of Practice meetings scheduled at this time."
