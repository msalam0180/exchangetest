Feature: Create and View File Content
  As a Content Creator to the Insider
  I want to be able to add files
  So that users can get information available in files on Insider

    Background:
    Given "top_level_group" terms:
        | name     |
        | toplevel |
        | sports   |
      And "topic" terms:
        | name    |
        | techno  |
        | hr      |
      And "audiences" terms:
        | name    |
        | Insider |
        | Lawyer  |
      And "office_division" terms:
        | name                |
        | DERA                |
        | Corporation Finance |
      And "group_club" terms:
        | name    |
        | Running |
        | Cooking |

@api
Scenario: View a File Node
  Given I am logged in as a user with the "Authenticated user" role
    And I am viewing a "file" content:
      | title                      | BEHAT File Test                                     |
      | field_description_abstract | This is a description and abstract about this file. |
      | field_retain_disposal_date | +1 day                                              |
      | field_file_upload          | file;behat-form1.pdf                                |
  Then I should see response headers with content type "PDF"

@api @javascript
Scenario: Create a file node through the Admin UI
  Given I am logged in as a user with the "administrator" role
  When I visit "/node/add/file"
    And I fill in the following:
      | Title                                      | BEHAT Testing File Admin UI         |
      | Description/Abstract                       | This is a Description or Abstract   |
      | field_retain_disposal_date[0][value][date] | 08/11/2017                          |
    And I attach the file "behat-form1.pdf" to "File Upload"
    And I wait for AJAX to finish
    And I select "sports" from "Top Level Group"
    And I select "techno" from "Topic"
    And I press "Save and Publish"
  Then I should see the text "This is a Description or Abstract"
    And the link "behat-testing-file-admin-ui.pdf" should match the Drupal url "/files/exchange/media/behat-testing-file-admin-ui.pdf"

@api @javascript
Scenario: Associate Multiple Taxonomy Terms
  Given I am logged in as a user with the "administrator" role
  When I visit "/node/add/file"
    And I fill in the following:
      | Title                                      | BEHAT Testing File Admin UI       |
      | Description/Abstract                       | This is a Description or Abstract |
      | field_retain_disposal_date[0][value][date] | 08/11/2017                        |
    And I attach the file "behat-file.pdf" to "File Upload"
    And I select "Lawyer" from "Audience"
    And I additionally select "Insider" from "Audience"
    And I select "hr" from "Topic"
    And I additionally select "techno" from "Topic"
    And I select "Running" from "Group/Club"
    And I additionally select "Cooking" from "Group/Club"
    And I select "Corporation Finance" from "Division / Office"
    And I additionally select "DERA" from "Division / Office"
    And I select "sports" from "Top Level Group"
    And I press "Save and Publish"
  Then I should see the heading "BEHAT Testing File Admin UI"

@api @javascript
Scenario: Delete a File
  Given I am logged in as a user with the "administrator" role
    And I create "node" of type "file":
      | title           | field_description_abstract                          | field_retain_disposal_date | field_file_upload | nid     |
      | BEHAT File Test | This is a description and abstract about this file. | +1 day                     | behat-form1.pdf   | 8272019 |
  When I visit "/node/8272019/edit"
    And I wait 2 seconds
    And I click "edit-delete"
    And I press the "Delete" button
  Then I should see the text "The Static File BEHAT File Test has been deleted."
