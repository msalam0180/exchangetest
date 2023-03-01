Feature: Create and View OP Content
  As a Visitor to the Insider
  I want to be able to view OPs
  So that I can learn information about Operating Procedures

  Background:
    Given "topic" terms:
      | name       |
      | technology |
      | hr         |
      And "office_division" terms:
        | name    |
        | dera    |
        | corpfin |
      And "top_level_group" terms:
        | name   |
        | sports |
        | news   |
      And "link" content:
        | title           | field_description_abstract | field_url                          | status | moderation_state |
        | Behat Test Link | Site Link Description      | Click Here - http://www.google.com | 1      | published        |

@api @javascript
Scenario: Create an OP With Link
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/operating_procedure"
    And I fill in the following:
      | Title                              | BEHAT Test OP |
      | field_publish_date[0][value][date] | 11/22/2017    |
      | field_publish_date[0][value][time] | 10:30:00AM    |
      | OP Number                          | OP 12345      |
      | Series                             | 1             |
    And I select "Link" from "Link/Media Type"
    And I fill in "Link Reference" with "BEHAT Test Link"
    And I type "This is description" in the "Description" WYSIWYG editor
    And I type "This is source" in the "Source" WYSIWYG editor
    And I select "corpfin" from "Division / Office"
    And I select "hr" from "Topic"
    And I select "sports" from "Top Level Group"
  When I publish it
  Then I should see the heading "OP 12345 - BEHAT Test OP"
    And I should see the text "Operating Procedure BEHAT Test OP has been created."
    And I should see the link "Click Here"

@api @javascript
Scenario: Create an OP With Media
  Given I am logged in as a user with the "content_approver" role
    And I visit "/media/add/file"
    And I fill in the following:
      | Name                 | BEHAT1 Media   |
      | Description/Abstract | This is a test |
    And I attach the file "behat-file.pdf" to "File Upload"
    And I wait for ajax to finish
    And I select "Benefits" from "Topic"
    And I select "News" from "Top Level Group"
    And I press "Save"
  When I visit "/node/add/operating_procedure"
    And I fill in the following:
      | Title                              | BEHAT Test OP |
      | field_publish_date[0][value][date] | 11/22/2017    |
      | field_publish_date[0][value][time] | 10:30:00AM    |
      | OP Number                          | OP 12345      |
      | Series                             | 1             |
    And I select "Media" from "Link/Media Type"
    And I fill in "Use existing media" with "BEHAT1 Media"
    And I type "This is description" in the "Description" WYSIWYG editor
    And I type "This is source" in the "Source" WYSIWYG editor
    And I select "corpfin" from "Division / Office"
    And I select "hr" from "Topic"
    And I select "sports" from "Top Level Group"
  When I publish it
  Then I should see the heading "OP 12345 - BEHAT Test OP"
    And I should see "Operating Procedure BEHAT Test OP has been created."
    And I should see the link "BEHAT1 Media (PDF)"

@api @javascript
Scenario: OP Should Not Allow Static Files
  Given I am logged in as a user with the "content_approver" role
    And "file" content:
      | title      | field_description_abstract                          | field_retain_disposal_date |
      | BEHAT File | This is a description and abstract about this file. | +1 day                     |
  When I visit "/node/add/operating_procedure"
    And I fill in the following:
      | Title                              | BEHAT Test OP |
      | field_publish_date[0][value][date] | 11/22/2017    |
      | field_publish_date[0][value][time] | 10:30:00AM    |
      | OP Number                          | OP 12345      |
      | Series                             | 1             |
    And I select "Media" from "Link/Media Type"
    And I fill in "Use existing media" with "BEHAT1 File"
    And I type "This is description" in the "Description" WYSIWYG editor
    And I type "This is source" in the "Source" WYSIWYG editor
    And I select "corpfin" from "Division / Office"
    And I select "hr" from "Topic"
    And I select "sports" from "Top Level Group"
  When I publish it
  Then I should see the text "There are no media items matching"
    And I should not see the heading "OP 12345 - BEHAT Test OP"

@api @javascript
Scenario: Test OP View When It Is Related to an SECR
#You need to create the OP first, then an SECR that contains the related OP, then visit the OP, probably by clicking a link.
  Given I am logged in as a user with the "content_approver" role
    And "operating_procedure" content:
      | title          | field_release_number | field_publish_date | field_series | status | field_link_reference |
      | BEHAT Test OP2 | OP 12345             | now                | 1            | 1      | Behat Test Link      |
  When I visit "/node/add/secr"
    And I fill in the following:
      | Title                              | BEHAT Test SECR |
      | field_publish_date[0][value][date] | 12/01/2017      |
      | field_publish_date[0][value][time] | 14:20:16pm      |
      | SECR Number                        | R1-2            |
      | Series                             | 1               |
      | Related OP                         | BEHAT Test OP2  |
    And I type "This is the Description" in the "Description" WYSIWYG editor
    And I select "Link" from "Link/Media Type"
    And I wait 1 seconds
    And I should see the text "Link Reference"
    And I select the autocomplete option for "Behat Test Link" on the "field_link_reference[0][target_id]" field
    And I type "This is the Source" in the "Source" WYSIWYG editor
    And I select "corpfin" from "Division / Office"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the link "OP 12345 - BEHAT Test OP2"
    And I click "OP 12345 - BEHAT Test OP2"
  Then I should see the heading "OP 12345 - BEHAT Test OP2"
    And I should see the link "R1-2 - BEHAT Test SECR"
