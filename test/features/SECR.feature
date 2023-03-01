Feature: Create and View SECR Content
  As a Visitor to the Insider
  I want to be able to view SECRs
  So that I can learn information about SECRs

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
        | group  |
        | sports |
      And "operating_procedure" content:
        | title    | field_release_number | field_publish_date | field_series | status |
        | OP1 test | OP1-2                | now                | 1            | 1      |
      And "link" content:
        | title      | field_url                                     |
        | BEHAT Link | BEHAT Test Link Title - http://www.google.com |

@api @javascript
Scenario: Create an SECR With Link
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/secr"
    And I fill in the following:
      | Title                              | BEHAT Test SECR |
      | field_publish_date[0][value][date] | 12/01/2017      |
      | field_publish_date[0][value][time] | 14:20:16pm      |
      | SECR Number                        | R1-2            |
      | Series                             | 1               |
      | Related OP                         | OP1 test        |
    And I select "Link" from "Link/Media Type"
    And I fill in "Link Reference" with "BEHAT Link"
    And I type "This is the Description" in the "Description" WYSIWYG editor
    And I type "This is the Source" in the "Source" WYSIWYG editor
    And I select "corpfin" from "Division / Office"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the heading "R1-2 - BEHAT Test SECR"
    And I should see "SECR BEHAT Test SECR has been created."
    And I should see the text "Series"
    And I should see the text "Directives Management"
    And I should see the text "Revision Date"
    And I should see the text "Dec. 1, 2017"
    And I should see the text "This is the Description"
    And I should see the link "BEHAT Test Link Title"
    And I should see the text "Related OP"
    And I should see the link "OP1 test"
    And I should see the text "Source"
    And I should see the text "This is the Source"

@api @javascript
Scenario: Create an SECR With Media File
  Given I am logged in as a user with the "content_approver" role
    And I visit "/media/add/file"
    And I fill in the following:
      | Name                 | BEHAT Media    |
      | Description/Abstract | This is a test |
    And I attach the file "behat-file.pdf" to "File"
    And I wait 2 seconds
    And I select "Benefits" from "Topic"
    And I select "News" from "Top Level Group"
    And I press "Save"
  When I visit "/node/add/secr"
    And I fill in the following:
      | Title                              | BEHAT Test SECR |
      | field_publish_date[0][value][date] | 12/01/2017      |
      | field_publish_date[0][value][time] | 14:20:16pm      |
      | SECR Number                        | R1-2            |
      | Series                             | 1               |
      | Related OP                         | OP1 test        |
    And I select "Media" from "Link/Media Type"
    And I fill in "Use existing media" with "BEHAT Media"
    And I type "This is the Description" in the "Description" WYSIWYG editor
    And I type "This is the Source" in the "Source" WYSIWYG editor
    And I select "corpfin" from "Division / Office"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the heading "R1-2 - BEHAT Test SECR"
    And I should see "SECR BEHAT Test SECR has been created."
    And I should see the text "Series"
    And I should see the text "Directives Management"
    And I should see the text "Revision Date"
    And I should see the text "Dec. 1, 2017"
    And I should see the link "BEHAT Media (PDF)"
    And I should see the text "This is the Description"
    And I should see the text "Related OP"
    And I should see the link "OP1-2 - OP1 test"
    And I should see the text "Source"
    And I should see the text "This is the Source"

@api @javascript
Scenario: SECR Should Not Allow Static Files
  Given I am logged in as a user with the "content_approver" role
    And "file" content:
      | title      | field_description_abstract                          | field_retain_disposal_date |
      | BEHAT File | This is a description and abstract about this file. | +1 day                     |
  When I visit "/node/add/secr"
    And I fill in the following:
      | Title                              | BEHAT Test SECR |
      | field_publish_date[0][value][date] | 12/01/2017      |
      | field_publish_date[0][value][time] | 14:20:16pm      |
      | SECR Number                        | R1-2            |
      | Series                             | 1               |
      | Related OP                         | OP1 test        |
    And I select "Media" from "Link/Media Type"
    And I fill in "Use existing media" with "BEHAT File"
    And I type "This is the Description" in the "Description" WYSIWYG editor
    And I type "This is the Source" in the "Source" WYSIWYG editor
    And I select "corpfin" from "Division / Office"
    And I select "technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the text "There are no media items matching"
    And I should not see "SECR BEHAT Test SECR has been created."

# TODO: Scenario: View SECR Details on List Page

@api @javascript
Scenario: Default Sorting by SECR number ascending
  Given I am logged in as a user with the "Authenticated user" role
    And "secr" content:
      | title                             | field_secr_number | field_publish_date | field_series | field_related_op |status |
      | Free Ice Cream Today              | R1-2              | now                | 1            |                  | 1     |
      | Sign Up For Benefits By Friday    | R1-3              | -5 day             | 2            |                  | 1     |
      | Early Dismissal                   | R1-4              | -2 day             | 3            |                  | 1     |
      | New Director of Enforcement Joins | R1-5              | +1 day             | 4            |                  | 1     |
      | Impacts from the Hurricane        | R1-6              | -1 month           | 5            |                  | 1     |
      | Vigil Held for 9/11               | R1-7              | -1 month           | 6            |                  | 0     |
      | Pizza Party Planned               | R1-8              | +1 month           | 6            |                  | 0     |
  When I visit "/admin-regulations"
  Then "Free Ice Cream Today" should precede "Early Dismissal" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Sign Up For Benefits By Friday" should precede "Impacts from the Hurricane" for the query "//td[contains(@class, 'views-field views-field-title')]"

@api @javascript
Scenario: Sort SECR by SECR Number descending
  Given I am logged in as a user with the "Authenticated user" role
    And "secr" content:
      | title                             | field_secr_number | field_publish_date | field_series | status |
      | Free Ice Cream Today              | R1-2              | now                | 1            |  1     |
      | Sign Up For Benefits By Friday    | R1-3              | -5 day             | 2            |  1     |
      | Early Dismissal                   | R1-4              | -2 day             | 3            |  1     |
      | New Director of Enforcement Joins | R1-5              | +1 day             | 4            |  1     |
      | Impacts from the Hurricane        | R1-6              | -1 month           | 5            |  1     |
      | Vigil Held for 9/11               | R1-7              | -1 month           | 6            |  0     |
      | Pizza Party Planned               | R1-8              | +1 month           | 6            |  0     |
  When I visit "/admin-regulations"
    And I click the sort filter "SECR Number"
  Then "Early Dismissal" should precede "Free Ice Cream Today" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Impacts from the Hurricane" should precede "Sign Up For Benefits By Friday" for the query "//td[contains(@class, 'views-field views-field-title')]"

@api @javascript
Scenario: Sort SECR list page by Title in alphabetical order
  Given I am logged in as a user with the "Authenticated user" role
    And "secr" content:
      | title                             | field_secr_number | field_publish_date | field_series | status |
      | Free Ice Cream Today              | R1-2              | now                | 1            |  1     |
      | Sign Up For Benefits By Friday    | R1-3              | -5 day             | 2            |  1     |
      | Early Dismissal                   | R1-4              | -2 day             | 3            |  1     |
      | New Director of Enforcement Joins | R1-5              | +1 day             | 4            |  1     |
      | Impacts from the Hurricane        | R1-6              | -1 month           | 5            |  1     |
      | Vigil Held for 9/11               | R1-7              | -1 month           | 6            |  0     |
      | Pizza Party Planned               | R1-8              | +1 month           | 6            |  0     |
  When I visit "/admin-regulations"
    And I click the sort filter "Title"
  Then "Early Dismissal" should precede "Sign Up For Benefits By Friday" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Impacts from the Hurricane" should precede "New Director of Enforcement Joins" for the query "//td[contains(@class, 'views-field views-field-title')]"

@api @javascript
Scenario: Sort SECR list page by Title reverse alphabetical order
  Given I am logged in as a user with the "Authenticated user" role
    And "secr" content:
      | title                             | field_secr_number | field_publish_date | field_series | status |
      | Free Ice Cream Today              | R1-2              | now                | 1            |  1     |
      | Sign Up For Benefits By Friday    | R1-3              | -5 day             | 2            |  1     |
      | Early Dismissal                   | R1-4              | -2 day             | 3            |  1     |
      | New Director of Enforcement Joins | R1-5              | +1 day             | 4            |  1     |
      | Impacts from the Hurricane        | R1-6              | -1 month           | 5            |  1     |
      | Vigil Held for 9/11               | R1-7              | -1 month           | 6            |  0     |
      | Pizza Party Planned               | R1-8              | +1 month           | 6            |  0     |
  When I visit "/admin-regulations"
    And I click the sort filter "Title"
    And I click the sort filter "Title"
  Then "Sign Up For Benefits By Friday" should precede "Early Dismissal" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "New Director of Enforcement Joins" should precede "Impacts from the Hurricane" for the query "//td[contains(@class, 'views-field views-field-title')]"

@api
Scenario: No SECR Pagination on SECR list page
  Given I am logged in as a user with the "Authenticated user" role
  When I visit "/admin-regulations"
  Then I should not see the text "1 to"
    And I should not see the link "Go to page 2"

@api @javascript
Scenario: Search SECR by Title
  Given I am logged in as a user with the "Authenticated user" role
    And "secr" content:
      | title                             | field_secr_number | field_publish_date | field_series | status |
      | Free Ice Cream Today              | SECR 1            | now                | 1            | 1      |
      | Sign Up For Benefits By Friday    | SECR 3            | -5 day             | 2            | 1      |
      | Early Dismissal                   | SECR 4            | -2 day             | 3            | 1      |
      | New Director of Enforcement Joins | SECR 5            | +1 day             | 4            | 1      |
      | Impacts from the Hurricane        | SECR 6            | -1 month           | 5            | 1      |
  When I visit "/admin-regulations"
    And I fill in "search" with "Free Ice Cream Today"
    And I press "Search" in the "filters" region
  Then the search results should show the link "Free Ice Cream Today"
    And I should not see the link "Sign Up For Benefits By Friday"
    And I should not see the link "Early Dismissal"
    And I should not see the link "New Director of Enforcement Joins"
    And I should not see the link "Impacts from the Hurricane"

 @api @javascript
 Scenario: Search SECR by SECR Number
  Given I am logged in as a user with the "Authenticated user" role
    And "secr" content:
      | title                             | field_secr_number | field_publish_date | field_series | status |
      | Free Ice Cream Today              | SECR 1            | now                | 1            | 1      |
      | Sign Up For Benefits By Friday    | ABCD 3            | -5 day             | 2            | 1      |
      | Early Dismissal                   | EFGH 4            | -2 day             | 3            | 1      |
      | New Director of Enforcement Joins | LMNO 5            | +1 day             | 4            | 1      |
      | Impacts from the Hurricane        | WXYZ 6            | -1 month           | 5            | 1      |
  When I visit "/admin-regulations"
    And I fill in "search" with "SECR 1"
    And I press "Search" in the "filters" region
  Then the search results should show the link "Free Ice Cream Today"
    And the search results should not show the link "Sign Up For Benefits By Friday"
    And the search results should not show the link "Early Dismissal"
    And the search results should not show the link "New Director of Enforcement Joins"
    And the search results should not show the link "Impacts from the Hurricane"
