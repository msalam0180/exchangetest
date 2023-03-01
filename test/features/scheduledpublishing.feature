Feature: Scheduled Publishing and Unpublishing
  As a Content Approver to the Insider
  I want to be able to create a content and then have it systematically published/unpublished at a future specified time
  So that I don't have to wait and do it manually

@api @javascript
Scenario: Scheduled Publishing and Unpublishing of Alerts
  Given I am logged in as a user with the "content_approver" role
    And I visit "/node/add/sec_alert"
    And I fill in the following:
      | Title | This is a scheduled BEHAT Test Alert 1 |
    And I type "Behat Test body" in the "Body" WYSIWYG editor
    And I select "info" from "Alert Type"
    And I select "Unpublish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I wait 2 seconds
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I publish it
    And I visit "/node/add/sec_alert"
    And I fill in the following:
      | Title | This is a scheduled BEHAT Test Alert 2 |
    And I type "Behat Test body" in the "Body" WYSIWYG editor
    And I select "info" from "Alert Type"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 11:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I press "Save and Create New Draft"
  When I am on the homepage
  Then I should see the text "This is a scheduled BEHAT Test Alert 1"
    And I should not see the text "This is a scheduled BEHAT Test Alert 2"
  When I run cron
    And I reload the page
  Then I should see the text "This is a scheduled BEHAT Test Alert 2"
    And I should not see the text "This is a scheduled BEHAT Test Alert 1"

@api @javascript
Scenario: Scheduled Publishing and Unpublishing of Announcements
  Given I am logged in as a user with the "content_approver" role
    And "topic" terms:
      | name  |
      | behat |
    And "top_level_group" terms:
      | name    |
      | sec.gov |
    And I visit "/node/add/announcement"
    And I fill in the following:
      | Title           | This is a BEHAT Test Announcement 1 |
      | Home Page Title | Behat Test short title              |
    And I type "Behat Test Body" in the "Body" WYSIWYG editor
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Memorandum" from "Announcement Type"
    And I fill in the following:
      | To   | SEC.gov Contractors |
      | From | Your Boss           |
    And I select "behat" from "Topic"
    And I select "sec.gov" from "Top Level Group"
    And I select "Unpublish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I publish it
    And I visit "/node/add/announcement"
    And I fill in the following:
      | Title           | This is a BEHAT Test Announcement 2 |
      | Home Page Title | Behat Test short title              |
    And I type "Behat Test Body" in the "Body" WYSIWYG editor
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Memorandum" from "Announcement Type"
    And I fill in the following:
      | To   | SEC.gov Contractors |
      | From | Your Boss           |
    And I select "behat" from "Topic"
    And I select "sec.gov" from "Top Level Group"
    And I select "Publish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 10:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I press "Save and Create New Draft"
  When I am on "/announcements"
  Then I should see the link "This is a BEHAT Test Announcement 1"
    And I should not see the link "This is a BEHAT Test Announcement 2"
  When I run cron
    And I reload the page
  Then I should see the link "This is a BEHAT Test Announcement 2"
    And I should not see the link "This is a BEHAT Test Announcement 1"

@api @javascript
Scenario: Scheduled Publishing and Unpublishing of Events
  Given I am logged in as a user with the "content_approver" role
    And "topic" terms:
      | name       |
      | technology |
      | hr         |
    And "top_level_group" terms:
      | name     |
      | toplevel |
      | sports   |
    And "timezone" terms:
      | name    | field_abbreviation |
      | Eastern | ET                 |
    And I visit "/node/add/event"
    And I fill in the following:
      | Title           | BEHAT Test Event 1 |
      | Home Page Title | Short Title        |
    And I fill in "+5 days 08:00:00 AM" in the "1" dynamic event start date
    And I fill in "+5 days 10:00:00 AM" in the "1" dynamic event end date
    And I select "General" from "Event Type"
    And I select "Eastern" from "Timezone"
    And I type "Test Location" in the "1" session "Location" WYSIWYG editor
    And I type "Test Source" in the "Source" WYSIWYG editor
    And I type "Test Body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I select "Unpublish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I publish it
    And I visit "/node/add/event"
    And I fill in the following:
      | Title           | BEHAT Test Event 2 |
      | Home Page Title | Short Title        |
    And I fill in "+6 days 08:00:00 AM" in the "1" dynamic event start date
    And I fill in "+6 days 10:00:00 AM" in the "1" dynamic event end date
    And I select "General" from "Event Type"
    And I select "Eastern" from "Timezone"
    And I type "Test Location" in the "1" session "Location" WYSIWYG editor
    And I type "Test Source" in the "Source" WYSIWYG editor
    And I type "Test Body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "hr" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I select "Publish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 10:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I press "Save and Create New Draft"
  When I am on "/events"
  Then I should see the link "BEHAT Test Event 1"
    And I should not see the link "BEHAT Test Event 2"
  When I run cron
    And I reload the page
  Then I should see the link "BEHAT Test Event 2"
    And I should not see the link "BEHAT Test Event 1"

@api @javascript
Scenario: Scheduled Publishing and Unpublishing of Articles
  Given I am logged in as a user with the "content_approver" role
    And "topic" terms:
      | name       |
      | technology |
      | hr         |
    And "top_level_group" terms:
      | name     |
      | toplevel |
      | sports   |
    And I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | BEHAT Test Article 1 |
    And I type "This is a test body" in the "Body" WYSIWYG editor
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I select "Unpublish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I wait 1 seconds
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I publish it
    And I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | BEHAT Test Article 2 |
    And I type "This is a test body" in the "Body" WYSIWYG editor
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "hr" from "Topic"
    And I select "sports" from "Top Level Group"
    And I select "Publish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I press "Save and Create New Draft"
    And I visit "/admin/content"
    And I select "Any" from "Published status"
    And I select "Article" from "Content type"
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Test Article 1" row
    And I should see "Unpublished" in the "BEHAT Test Article 2" row
    And I run cron
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Test Article 2" row
    And I should see "Unpublished" in the "BEHAT Test Article 1" row

@api @javascript
Scenario: Scheduled Publishing and Unpublishing of Forms
  Given I am logged in as a user with the "content_approver" role
    And "top_level_group" terms:
      | name     |
      | toplevel |
      | sports   |
    And "topic" terms:
      | name       |
      | technology |
      | hr         |
  When I visit "/node/add/form"
    And I fill in the following:
      | Title       | BEHAT Testing Form 1 |
      | Form Number | AK501                |
    And I select "sports" from "Top Level Group"
    And I select "technology" from "Topic"
    And I select "Unpublish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I publish it
  When I visit "/node/add/form"
    And I fill in the following:
      | Title       | BEHAT Testing Form 2 |
      | Form Number | AK502                |
    And I select "sports" from "Top Level Group"
    And I select "technology" from "Topic"
    And I select "Publish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I press "Save and Create New Draft"
    And I visit "/admin/content"
    And I select "Any" from "Published status"
    And I select "Form" from "Content type"
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Testing Form 1" row
    And I should see "Unpublished" in the "BEHAT Testing Form 2" row
    And I run cron
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Testing Form 2" row
    And I should see "Unpublished" in the "BEHAT Testing Form 1" row

@api @javascript
Scenario: Scheduled Publishing and Unpublishing of Landing Pages
  Given I am logged in as a user with the "administrator" role
    And "top_level_group" terms:
      | name     |
      | toplevel |
      | sports   |
    And "topic" terms:
      | name       |
      | technology |
      | hr         |
  When I visit "/node/add/landing_page"
    And I fill in the following:
      | Title                | BEHAT Landing Page 1     |
      | Description/Abstract | This is the description. |
    And I click "Exchange Details"
    And I select "sports" from "Top Level Group"
    And I select "Unpublish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I publish it
  When I visit "/node/add/landing_page"
    And I fill in the following:
      | Title                | BEHAT Landing Page 2     |
      | Description/Abstract | This is the description. |
    And I click "Exchange Details"
    And I select "toplevel" from "Top Level Group"
    And I select "Publish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I press "Save and Create New Draft"
    And I visit "/admin/content"
    And I select "Any" from "Published status"
    And I select "Landing Page" from "Content type"
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Landing Page 1" row
    And I should see "Unpublished" in the "BEHAT Landing Page 2" row
    And I run cron
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Landing Page 2" row
    And I should see "Unpublished" in the "BEHAT Landing Page 1" row

@api @javascript
Scenario: Scheduled Publishing and Unpublishing of OPs
  Given I am logged in as a user with the "content_approver" role
    And "topic" terms:
      | name       |
      | technology |
      | hr         |
    And "top_level_group" terms:
      | name   |
      | sports |
      | news   |
    And I create "media" of type "file":
      | name                | field_media_file | field_media_description_abstract  | field_media_topic | field_media_top_level_group | mid    | status |
      | Behat OP Media File | behat-form1.pdf  | This is a Description or Abstract | technology        | sports                      | 999999 | 1      |
  When I visit "/node/add/operating_procedure"
    And I fill in the following:
      | Title                              | BEHAT Test OP1 |
      | OP Number                          | OP123456       |
      | Series                             | 1              |
      | field_publish_date[0][value][date] | 11/22/2017     |
      | field_publish_date[0][value][time] | 10:30:00AM     |
    And I type "This is description" in the "Description" WYSIWYG editor
    And I select "Media" from "Link/Media Type"
    And I fill in "Use existing media" with "Behat OP Media File"
    And I type "This is source" in the "Source" WYSIWYG editor
    And I select "hr" from "Topic"
    And I select "sports" from "Top Level Group"
    And I select "Unpublish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I publish it
  When I visit "/node/add/operating_procedure"
    And I fill in the following:
      | Title                              | BEHAT Test OP2 |
      | field_publish_date[0][value][date] | 11/22/2017     |
      | field_publish_date[0][value][time] | 10:30:00AM     |
      | OP Number                          | OP543210       |
      | Series                             | 2              |
    And I type "This is source" in the "Source" WYSIWYG editor
    And I select "Media" from "Link/Media Type"
    And I fill in "Use existing media" with "Behat OP Media File"
    And I select "sports" from "Top Level Group"
    And I select "hr" from "Topic"
    And I select "Publish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I press "Save and Create New Draft"
    And I visit "/admin/content"
    And I select "Any" from "Published status"
    And I select "Operating Procedure" from "Content type"
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Test OP1" row
    And I should see "Unpublished" in the "BEHAT Test OP2" row
    And I run cron
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Test OP2" row
    And I should see "Unpublished" in the "BEHAT Test OP1" row

@api @javascript
Scenario: Scheduled Publishing and Unpublishing of SECRs
  Given I am logged in as a user with the "content_approver" role
    And "topic" terms:
      | name       |
      | technology |
      | hr         |
    And "top_level_group" terms:
      | name   |
      | group  |
      | sports |
    And I create "media" of type "file":
      | name                  | field_media_file | field_media_description_abstract  | field_media_topic | field_media_top_level_group | mid    | status |
      | Behat SECR Media File | behat-form1.pdf  | This is a Description or Abstract | technology        | sports                      | 999999 | 1      |
  When I visit "/node/add/secr"
    And I fill in the following:
      | Title                              | BEHAT Test SECR 1 |
      | field_publish_date[0][value][date] | 12/01/2017        |
      | field_publish_date[0][value][time] | 14:20:16pm        |
      | SECR Number                        | R1-2              |
      | Series                             | 1                 |
    And I type "This is the Source" in the "Source" WYSIWYG editor
    And I select "Media" from "Link/Media Type"
    And I fill in "Use existing media" with "Behat SECR Media File"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I select "Unpublish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I publish it
  When I visit "/node/add/secr"
    And I fill in the following:
      | Title                              | BEHAT Test SECR 2 |
      | field_publish_date[0][value][date] | 12/01/2017        |
      | field_publish_date[0][value][time] | 14:20:16pm        |
      | SECR Number                        | R1-2              |
      | Series                             | 2                 |
    And I type "This is the Source" in the "Source" WYSIWYG editor
    And I select "Media" from "Link/Media Type"
    And I fill in "Use existing media" with "Behat SECR Media File"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I select "Publish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I press "Save and Create New Draft"
    And I visit "/admin/content"
    And I select "Any" from "Published status"
    And I select "SECR" from "Content type"
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Test SECR 1" row
    And I should see "Unpublished" in the "BEHAT Test SECR 2" row
    And I run cron
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Test SECR 2" row
    And I should see "Unpublished" in the "BEHAT Test SECR 1" row

@api @javascript
Scenario: Scheduled Publishing and Unpublishing of Videos
  Given I am logged in as a user with the "content_approver" role
    And "topic" terms:
      | name       |
      | technology |
      | hr         |
    And "top_level_group" terms:
      | name     |
      | toplevel |
      | sports   |
    And I visit "/node/add/video"
  When I fill in the following:
    | Title | BEHAT Test Video 1 |
    And I select "YouTube or Vimeo" from "Video Origin"
    And I fill in "YouTube/Vimeo Link" with "http://www.youtube.com/watch?v=xf9BpXOtMcc"
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I select "Unpublish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I wait 1 seconds
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I publish it
    And I visit "/node/add/video"
  When I fill in the following:
    | Title | BEHAT Test Video 2 |
    And I select "YouTube or Vimeo" from "Video Origin"
    And I fill in "YouTube/Vimeo Link" with "http://www.youtube.com/watch?v=xf9BpXOtMcc"
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I select "Publish On" from "scheduling_options[actions][bundle]"
    And I press "Add new Scheduling Option"
    And I wait for AJAX to finish
    And I fill in the following:
      | scheduling_options[form][0][update_timestamp][0][value][date] | 11/06/2018 |
      | scheduling_options[form][0][update_timestamp][0][value][time] | 12:00:00AM |
    And I press "Create Scheduling Option"
    And I wait for AJAX to finish
    And I press "Save and Create New Draft"
    And I visit "/admin/content"
    And I select "Any" from "Published status"
    And I select "Video" from "Content type"
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Test Video 1" row
    And I should see "Unpublished" in the "BEHAT Test Video 2" row
    And I run cron
    And I press the "Filter" button
  Then I should see "Published" in the "BEHAT Test Video 2" row
    And I should see "Unpublished" in the "BEHAT Test Video 1" row
