Feature: Exchange Forms
  As content creator
  I want to be able to post forms to the Insider
  So employees can find them easily

  Background:
  Given "form_topic" terms:
    | name           |
    | Altruists      |
    | Boondoggle     |
    | Man of War     |
    | Foreign Travel |
    | 508 Compliant  |
    | Benefits       |
    | Fitness        |
    | Records        |
    And "top_level_group" terms:
      | name     |
      | toplevel |
      | sports   |
    And "topic" terms:
      | name            |
      | techno          |
      | hr              |
      | foreign travel  |
    And "link" content:
      | title       | field_url                                     |
      | BEHAT Link  | BEHAT Test Link Title - http://www.google.com |

@api
Scenario: View a Form
  Given I am logged in as a user with the "Authenticated user" role
  When I am viewing a "form" content:
    | body                  | This is the body   |
    | title                 | BEHAT Test Article |
    | field_form_number     | 3222               |
    | field_link_reference  | BEHAT Link         |
    | field_form_topic      | Boondoggle         |
    | field_top_level_group | toplevel           |
    | status                | 1                  |
  Then I should see the text "This is the body"

@api @javascript
Scenario: Create A Form With Link
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/form"
    And I fill in the following:
      | Title           | BEHAT Testing Form UI |
      | Form Number     | FORM BH455AM          |
    And I should see the text "Enter the number for this form. Leave blank for un-numbered forms."
    And I should see the text "Select the type of link to be used. Link will embed the Link node, media will embed the Media type"
    And I select "Link" from "Link/Media Type"
    And I should see the text "Start typing the title of a link to select it. You can also enter an internal path such as /node/add or an external."
    And I fill in "Link Reference" with "BEHAT Link"
    And I select "Man of War" from "Form Topic"
    And I select "sports" from "Top Level Group"
    And I select "techno" from "Topic"
    And I publish it
  Then I should see the text "Form BEHAT Testing Form UI has been created"
    And I should see the link "BEHAT Test Link Title"
  When I am on "/forms"
  Then I should see the link "BEHAT Testing Form UI"
    And I should see the text "Man of War" in the "FORM BH455AM" row

@api @javascript
Scenario: Create A Form With New Media File
  Given I am logged in as a user with the "content_approver" role
    And I visit "/media/add/file"
    And I fill in the following:
        | Name                 | BEHAT Media File |
        | Description/Abstract | This is a test   |
    And I attach the file "behat-file.pdf" to "File Upload"
    And I wait for ajax to finish
    And I select "techno" from "Topic"
    And I select "sports" from "Top Level Group"
    And I press "Save"
  When I visit "/node/add/form"
    And I fill in the following:
        | Title           | BEHAT Testing Form UI |
        | Form Number     | FORM BH455AM          |
    And I select "Media" from "Link/Media Type"
    And I should see the text "Create your media on the media add page (opens a new window), then add it by name to the field below."
    And I should see the text "Type part of the media name. See the media list (opens a new window) to help locate media. Allowed media types: File"
    And I fill in "Use existing media" with "BEHAT Media File"
    And I select "Man of War" from "Form Topic"
    And I select "sports" from "Top Level Group"
    And I select "techno" from "Topic"
    And I publish it
  Then I should see the text "Form BEHAT Testing Form UI has been created."
    And I should see the link "BEHAT Media File (PDF)"
  When I am on "/forms"
  Then I should see the link "BEHAT Testing Form UI"
    And I should see the text "Man of War" in the "FORM BH455AM" row

@api @javascript
Scenario: Forms Should Not Allow Static Files
  Given I am logged in as a user with the "content_approver" role
    And "file" content:
      | title      | field_description_abstract                          | field_retain_disposal_date |
      | BEHAT File | This is a description and abstract about this file. | +1 day                     |
  When I visit "/node/add/form"
    And I fill in the following:
      | Title       | BEHAT Testing Form UI |
      | Form Number | FORM BH455AM          |
    And I select "Media" from "Link/Media Type"
    And I fill in "Use existing media" with "BEHAT File"
    And I select "Man of War" from "Form Topic"
    And I select "sports" from "Top Level Group"
    And I select "techno" from "Topic"
    And I publish it
  Then I should see the text "There are no media items matching"
    And I should not see the text "Form BEHAT Testing Form UI has been created."

@api
Scenario: View Form List Page
  Given I am logged in as a user with the "Authenticated user" role
    And "form" content:
      | body                 | title                | field_form_number  | field_link_reference | field_form_topic | status |
      | This is the body     | BEHAT Test Article 1 | 1111               | BEHAT Link           | Altruists        | 1      |
      | This is another body | BEHAT Test Article 2 | 2222               |                      | Boondoggle       | 1      |
      | This is a third body | BEHAT Test Article 3 | 3333               |                      | Man of War       | 1      |
      | This is a fourth body| BEHAT Test Article 4 | 4444               |                      | Foreign Travel   | 0      |
  When I am on "/forms"
  Then I should see the link "BEHAT Test Article 1"
    And I should see the text "1111"
    And I should see the link "BEHAT Test Article 2"
    And I should see the text "2222"
    And I should see the link "BEHAT Test Article 3"
    And I should see the text "3333"
    But I should not see the link "BEHAT Test Article 4"
    And I should not see the text "4444"

@api @javascript
Scenario: Search by Title and Form Number
  Given I am logged in as a user with the "Authenticated user" role
    And "form" content:
      | body             | title               | field_form_topic | field_form_number | status |
      | This is the body | 1BEHAT Test Article | Altruists        | Test              | 1      |
      | This is the body | My Link             | Boondoggle       | Test Me           | 1      |
      | This is the body | Link Again          | Man of War       | Not a Test        | 1      |
      | This is the body | Test                | Altruists        | Unicorns          | 1      |
      | This is the body | Washington Capitals | Man of War       | Fairies           | 1      |
    And I am on "/forms"
  When I fill in "combine" with "Test"
    And I press "edit-submit-forms"
  Then the search results should show the link "BEHAT Test Article"
    And the search results should show the link "My Link"
    And the search results should show the link "Link Again"
    And the search results should show the link "Test"
    And the search results should not show the link "Washington Capitals"
  Then I press "edit-reset"
    And the search results should show the link "Washington Capitals"
    And the search results should show the link "BEHAT Test Article"
    And the search results should show the link "My Link"
    And the search results should show the link "Link Again"
    And the search results should show the link "Test"

@api @javascript
Scenario: Sort Forms Page by Title
  Given I am logged in as a user with the "Authenticated user" role
    And "form" content:
      | body             | title                | field_form_topic | field_form_number | status |
      | This is the body | BEHAT Test Article   | Altruists        | Test              | 1      |
      | This is the body | My Link              | Boondoggle       | Test Me           | 1      |
      | This is the body | Link Again           | Man of War       | Not a Test        | 1      |
      | This is the body | Test                 | Altruists        | Unicorns          | 1      |
      | This is the body | Washington Capitals  | Man of War       | Fairies           | 1      |
      | This is the body | 2018 Open Enrollment | Man of War       | Fairies           | 1      |
  When I visit "/forms"
    And I click the sort filter "Title"
  Then "2018 Open Enrollment" should precede "BEHAT Test Article" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "BEHAT Test Article" should precede "Link Again" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Link Again" should precede "My Link" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "My Link" should precede "Test" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Test" should precede "Washington Capitals" for the query "//td[contains(@class, 'views-field views-field-title')]"
  When I click the sort filter "Title"
  Then "Washington Capitals" should precede "Test" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Test" should precede "My Link" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "My Link" should precede "Link Again" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Link Again" should precede "BEHAT Test Article" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "BEHAT Test Article" should precede "2018 Open Enrollment" for the query "//td[contains(@class, 'views-field views-field-title')]"

@api @javascript
Scenario: Sort Forms Page by Form Number
  Given I am logged in as a user with the "Authenticated user" role
    And "form" content:
      | body             | title                       | field_form_topic | field_form_number | status |
      | This is the body | Hall Pass Request           | Foreign Travel   | 89                | 1      |
      | This is the body | PTO Request                 | Altruists        | 2020              | 1      |
      | This is the body | Visitor Request             | Boondoggle       | 306 OF            | 1      |
      | This is the body | Guest Wifi Request          | Man of War       | DS-50             | 1      |
      | This is the body | System Access Request       | Altruists        | OF 123            | 1      |
      | This is the body | Parking Spot Request        | Man of War       | SEC 2020          | 1      |
      | This is the body | Telework Request            | Man of War       | SF 1223           | 1      |
      | This is the body | Lunch Reimbursement Request |                  | TSP-99            | 1      |
      | This is the body | Software Install Request    | 508 Compliant    | WH-380-F          | 1      |
      | This is the body | Hardware Upgrade Request    | Boondoggle       | SF 85/86          | 1      |
      | This is the body | Paid Parental Leave         | Boondoggle       |                   | 1      |
      | This is the body | Foreign Travel Request      | Foreign Travel   |                   | 1      |
  When I visit "/forms"
    And I click the sort filter "Form Number"
  Then "Software Install Request" should precede "Lunch Reimbursement Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Lunch Reimbursement Request" should precede "Telework Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Telework Request" should precede "Hardware Upgrade Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Hardware Upgrade Request" should precede "Parking Spot Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Parking Spot Request" should precede "System Access Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "System Access Request" should precede "Guest Wifi Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Guest Wifi Request" should precede "PTO Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "PTO Request" should precede "Visitor Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Visitor Request" should precede "Hall Pass Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Hall Pass Request" should precede "Paid Parental Leave" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Foreign Travel Request" should precede "Paid Parental Leave" for the query "//td[contains(@class, 'views-field views-field-title')]"
  When I click the sort filter "Form Number"
  Then "Foreign Travel Request" should precede "Paid Parental Leave" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Paid Parental Leave" should precede "Hall Pass Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Hall Pass Request" should precede "Visitor Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Visitor Request" should precede "PTO Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "PTO Request" should precede "Guest Wifi Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Guest Wifi Request" should precede "System Access Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "System Access Request" should precede "Parking Spot Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Parking Spot Request" should precede "Hardware Upgrade Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Hardware Upgrade Request" should precede "Telework Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Telework Request" should precede "Lunch Reimbursement Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Lunch Reimbursement Request" should precede "Software Install Request" for the query "//td[contains(@class, 'views-field views-field-title')]"

@api @javascript
Scenario: Sort By Form Topic
  Given I am logged in as a user with the "Authenticated user" role
    And "form" content:
      | body             | title                       | field_form_topic | field_form_number | status |
      | This is the body | PTO Request                 | Altruists        | 1111              | 1      |
      | This is the body | Visitor Request             | Foreign Travel   | 2222              | 1      |
      | This is the body | Guest Wifi Request          | Man of War       | 3333              | 1      |
      | This is the body | System Access Request       | Records          | 4444              | 1      |
      | This is the body | Parking Spot Request        | Fitness          | 5555              | 1      |
      | This is the body | Telework Request            | Benefits         |                   | 1      |
      | This is the body | Lunch Reimbursement Request |                  | ABCD              | 1      |
      | This is the body | Software Install Request    | 508 Compliant    | XYZ               | 1      |
      | This is the body | Hardware Upgrade Request    | Boondoggle       |                   | 1      |
  When I visit "/forms"
    And I click the sort filter "Topic"
  Then "Lunch Reimbursement Request" should precede "Software Install Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Software Install Request" should precede "PTO Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "PTO Request" should precede "Telework Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Telework Request" should precede "Hardware Upgrade Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Hardware Upgrade Request" should precede "Parking Spot Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Parking Spot Request" should precede "Visitor Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Visitor Request" should precede "Guest Wifi Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Guest Wifi Request" should precede "System Access Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
  When I click the sort filter "Topic"
  Then "System Access Request" should precede "Guest Wifi Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Guest Wifi Request" should precede "Visitor Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Visitor Request" should precede "Parking Spot Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Parking Spot Request" should precede "Hardware Upgrade Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Hardware Upgrade Request" should precede "Telework Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Telework Request" should precede "PTO Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "PTO Request" should precede "Software Install Request" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Software Install Request" should precede "Lunch Reimbursement Request" for the query "//td[contains(@class, 'views-field views-field-title')]"

@api @javascript
Scenario: Form Default Sort Release Number Ascending
  Given I am logged in as a user with the "Authenticated user" role
    And "form" content:
      | body             | title               | field_form_topic | field_form_number | status |
      | This is the body | BEHAT Test Article  | Altruists        | 1111              | 1      |
      | This is the body | My Link             | Boondoggle       | DEF               | 1      |
      | This is the body | Link Again          | Man of War       | 3333              | 1      |
      | This is the body | Test Form           | Altruists        | 2222              | 1      |
      | This is the body | Washington Capitals | Man of War       | ABC               | 1      |
      | This is the body | Washington Redskins | Man of War       |                   | 1      |
  When I visit "/forms"
  Then "Washington Redskins" should precede "BEHAT Test Article" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "BEHAT Test Article" should precede "Test Form" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Test Form" should precede "Link Again" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Link Again" should precede "Washington Capitals" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Washington Capitals" should precede "My Link" for the query "//td[contains(@class, 'views-field views-field-title')]"

@api @javascript
Scenario: Create LinkIt Links to Form Nodes
  Given I am logged in as a user with the "content_approver" role
    And "form" content:
      | body                                                                                                                    | title                           | field_form_topic | field_form_number | status | field_top_level_group | field_topic    | nid      |
      | Employees traveling on international assignments are required to complete and submit a Request for Foreign Travel Form. | Request for Foreign Travel Form | Foreign Travel   | behat_555         | 1      | sports                | Foreign Travel | 55555555 |
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "BEHAT LinkIt Article"
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the WYSIWYG Toolbar
    And I fill in "URL" with "/node/55555555"
    And I click "Save" on the modal "Add Link"
    And I press "Link (Ctrl+L)" in the WYSIWYG Toolbar
    And I fill in "Display Text" with "Request for Foreign Travel"
    And I press the "OK" button
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I fill in "edit-field-retain-disposal-date-0-value-date" with "09/11/2032"
    And I select "Policy" from "Article Type"
    And I select "Technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I should see the heading "BEHAT LinkIt Article"
    And I should see the link "Request for Foreign Travel"
    And I click "Request for Foreign Travel"
    And I should see the heading "Request for Foreign Travel Form"
    And I should see the text "behat_555"
    And I should see the text "Employees traveling on international assignments are required to complete and submit a Request for Foreign Travel Form."

#Scenario: Pagination

@api @javascript
Scenario: Forms Published Date Doesn't Update When Republish
  Given "form" content:
    | body             | title           | field_form_topic | field_form_number | status | moderation_state | field_top_level_group | field_topic | published_at        | changed |
    | This is the body | BEHAT Test Form | Altruists        | 1234              | 1      | published        | sports                | hr          | 2020-07-03T16:00:05 | -5 day  |
  When I am logged in as a user with the "administrator" role
    And I am on "/forms/1234-behat-test-form/edit"
  # Checking for usage of published date
  Then I should see the "input" element with the "value" attribute set to "2020-07-03" in the "published_on" region
  When I fill in "Title" with "Updated BEHAT Test Form"
    And I publish it
  Then I should see the text "Form Updated BEHAT Test Form has been updated."
  When I am on "/forms/1234-updated-behat-test-form/edit"
  # Checking for no date updating when republish
  Then I should see the "input" element with the "value" attribute set to "2020-07-03" in the "published_on" region
