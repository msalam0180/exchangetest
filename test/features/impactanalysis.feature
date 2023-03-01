Feature: Impact Analysis
  As an administrator
  I want to be able to view content usage summary
  So that I can identify contents being used across the site

Background:
  Given "top_level_group" terms:
        | name       | field_abbreviation |
        | group      | group              |
        | sports     | sport              |
        | behat      | behat              |
    And "topic" terms:
        | name            |
        | technology      |
        | hr              |
        | foreign travel  |
    And "office_division" terms:
        | name     |
        | dera     |
        | corpfin  |

@api @javascript
Scenario: Impact Analysis Usage Counts
  Given I am logged in as a user with the "content_approver" role
    And link content:
      | title                 | field_description_abstract | field_url                          | status | moderation_state | nid   |
      | Behat Page Count Link | Site Link Description      | Click Here - http://www.google.com | 1      | published        | 88888 |
    And I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | BEHAT Test Article |
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
    And I fill in "URL" with "/node/88888"
    And I click "Save" on the modal "Add Link"
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I fill in "Display Text" with "Google Homepage"
    And I press the "OK" button
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I should see the heading "BEHAT Test Article"
    And I should see the link "Google Homepage"
    And I visit "/admin/content/entity-usage"
    And I fill in "Search" with "Behat Page Count Link"
    And I press the "Apply" button
  Then I should see "1 place" in the "Behat Page Count Link" row
    And I click "1 place" in the "Behat Page Count Link" row
    And I should see the link "BEHAT Test Article"
    And "form" content:
      | title           | body             | field_form_number | field_link_reference  | topic      | status |
      | BEHAT Test Form | This is the body | 1111              | BEHAT Page Count Link | Technology | 1      |
    And "operating_procedure" content:
      | title         | field_release_number | field_publish_date | field_series | status | field_link_reference  |
      | BEHAT Test OP | OP 12345             | now                | 1            | 1      | BEHAT Page Count Link |
    And "secr" content:
      | title           | field_secr_number | field_publish_date | field_series | field_related_op | status | field_link_reference  |
      | BEHAT Test SECR | R1-2              | now                | 1            | BEHAT Test OP    | 1      | BEHAT Page Count Link |
    And I visit "/admin/content/entity-usage"
    And I fill in "Search" with "Behat Page Count"
    And I press the "Apply" button
    And I should see "4 places" in the "Behat Page Count Link" row
    And I click "4 places" in the "Behat Page Count Link" row
    And I should see the link "BEHAT Test SECR"
    And I should see the link "BEHAT Test Article"
    And I should see the link "BEHAT Test Form"
    And I should see the link "BEHAT Test OP"
    And I should see the text "Link Reference" in the "BEHAT Test SECR" row
    And I should see the text "Link Reference" in the "BEHAT Test OP" row
    And I should see the text "Link Reference" in the "BEHAT Test Form" row
    And I should see the text "Body" in the "BEHAT Test Article" row

@api @javascript
Scenario: Revision Counts on Impact Analysis
  Given I am logged in as a user with the "content_approver" role
    And link content:
      | title                 | field_description_abstract | field_url                          | status | moderation_state | nid   |
      | Behat Page Count Link | Site Link Description      | Click Here - http://www.google.com | 1      | published        | 88888 |
  When I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | BEHAT Test Article |
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
    And I fill in "URL" with "/node/88888"
    And I click "Save" on the modal "Add Link"
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I fill in "Display Text" with "Google Homepage"
    And I press the "OK" button
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
    And I should see the heading "BEHAT Test Article"
    And I visit "/admin/content"
    And I click "Edit" in the "BEHAT Test Article" row
    And I wait 2 seconds
    And I type "Source Revision 1" in the "Source" WYSIWYG editor
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "group" from "Top Level Group"
    And I press "Save and Create New Draft"
    And I visit "/admin/content"
    And I click "Edit" in the "BEHAT Test Article" row
    And I wait 2 seconds
    And I type "Source Revision 2" in the "Source" WYSIWYG editor
    And I click "Exchange Details"
    And I select "foreign travel" from "Topic"
    And I select "behat" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I visit "/admin/content/entity-usage"
    And I fill in "Search" with "Behat Page Count Link"
    And I press the "Apply" button
    And I should see "1 place" in the "Behat Page Count Link" row
    And I click "1 place" in the "Behat Page Count Link" row
    And I should see the link "BEHAT Test Article"

@api @javascript
Scenario: Media Impact Analysis Usage Counts
  Given I am logged in as a user with the "content_approver" role
  When I am on "/media/add/file"
    And I fill in "Name" with "Test Org Diagram"
    And I fill in "Description/Abstract" with "This is 'PDF Format'"
    And I attach the file "behat-file.pdf" to "File Upload"
    And I wait for ajax to finish
    And I wait 5 seconds
    And I select "hr" from "Topic"
    And I select "sports" from "Top Level Group"
    And I click "URL alias"
    And I fill in "URL alias" with "/media/node/77777"
    And I press "Save"
  When I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | BEHAT Test Usage Count Article 1 |
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
    And I fill in "URL" with "/media/node/77777"
    And I click "Save" on the modal "Add Link"
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I fill in "Display Text" with "My Org Chart"
    And I press the "OK" button
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  When I visit "/admin/content"
    And I fill in "BEHAT Test Usage Count Article 1" for "Title"
    And I press "Filter"
    And I wait for AJAX to finish
    And I click "Edit" in the "BEHAT Test Usage Count Article 1" row
    And I click "Replicate"
    And I fill in "edit-new-label-en" with "BEHAT Test Usage Count Article 2"
    And I press "Replicate"
    And I should see the "Save and Create New Draft" button
    And I publish it
  When I visit "/node/add/operating_procedure"
    And I fill in the following:
      | Title                              | BEHAT Test OP |
      | field_publish_date[0][value][date] | 11/22/2017    |
      | field_publish_date[0][value][time] | 10:30:00AM    |
      | OP Number                          | OP 12345      |
      | Series                             | 1             |
    And I select "Media" from "Link/Media Type"
    And I fill in "Use existing media" with "Test Org Diagram"
    And I type "This is description" in the "Description" WYSIWYG editor
    And I type "This is source" in the "Source" WYSIWYG editor
    And I select "corpfin" from "Division / Office"
    And I select "hr" from "Topic"
    And I select "sports" from "Top Level Group"
    And I publish it
    And I visit "/admin/content/entity-usage-media"
    And I fill in "Search" with "diagram"
    And I press the "Apply" button
  Then I should see "3 places" in the "Test Org Diagram" row
  When I click "3 places" in the "Test Org Diagram" row
  Then I should see the link "BEHAT Test Usage Count Article 1"
    And I should see the link "BEHAT Test Usage Count Article 2"
    And I should see the link "BEHAT Test OP"
  When I click "BEHAT Test Usage Count Article 1"
  Then the hyperlink "My Org Chart" should match the Drupal url "/media/node/77777"
  When I move backward one page
    And I click "BEHAT Test Usage Count Article 2"
  Then the hyperlink "My Org Chart" should match the Drupal url "/media/node/77777"
  When I move backward one page
    And I click "BEHAT Test OP"
  Then the hyperlink "Test Org Diagram (PDF)" should match the Drupal url "/media/node/77777/download?inline"
