Feature: Create and View Landing Page Content
  As a Content Creator
  I want to be able to create landing pages
  So that I can create pages for visitors that displays curated and dynamic content about a topic

@api @javascript
Scenario Outline: Create a Landing Page With a Curated Block and a Dynamic Block
Given I create "block_content" of type "basic":
  | type  | info            | body    | uuid                 |
  | basic | Here be dragons | RAWWWR! | test--here-be-dragon |
  | basic | And dinosour    | Boo...  | test--and-dino       |
  And "top_level_group" terms:
    | name     |
    | toplevel |
    | sports   |
  And I am logged in as a user with the "<role>" role
When I visit "/node/add/landing_page"
  And I fill in the following:
    | Title                | BEHAT Landing Page       |
    | Description/Abstract | This is the description. |
  And I click "Exchange Details"
  And I select "toplevel" from "Top Level Group"
  And I press "Save and Create New Draft"
  And I reload the page
  And I place the "Custom" type "Here be dragons" block into the "top" panelizer region
  And I click "Save"
  And I wait 2 seconds
  And I place the "Lists (Views)" type "Recent content" block into the "left" panelizer region
  And I click "Save"
Then the "Here be dragons" block should be in the "top" region
  And the "Recent content" block should be in the "left" region

  Examples:
  | role             |
  | content_creator  |
  | content_approver |

@api
Scenario: Test the ability to select a subtype for a landing page and publish
Given I am logged in as a user with the "administrator" role
  And "top_level_group" terms:
    | name     |
    | toplevel |
    | sports   |
When I visit "/node/add/landing_page"
  And I fill in the following:
      | Title                | BEHAT Landing Page       |
      | Description/Abstract | This is the description. |
  And I select "toplevel" from "Top Level Group"
  And I select "Audience" from "Landing Page Subtype"
  And I publish it
Then I should see the heading "BEHAT Landing Page"

@api @javascript
Scenario Outline: Remove a curated block and a dynamic block from a landing page
Given I create "block_content" of type "basic":
  | type  | info            | body    | uuid                  |
  | basic | Here be dragons | RAWWWR! | test--here-be-dragons |
  And "top_level_group" terms:
    | name     |
    | toplevel |
    | sports   |
  And I am logged in as a user with the "<role>" role
When I visit "/node/add/landing_page"
  And I fill in the following:
    | Title                | BEHAT Landing Page       |
    | Description/Abstract | This is the description. |
  And I click "Exchange Details"
  And I select "toplevel" from "Top Level Group"
  And I press "Save and Create New Draft"
  And I click "Manage Content"
  And I wait 5 seconds
  And I click "Lists (Views)"
  And I wait 2 seconds
  And I click "Recent content"
  And I wait 5 seconds
  And I select "5" from "Items per block"
  And I select "left" from "Region"
  And I press the "Add" button
  And I wait 5 seconds
  And I click "Save"
  And I place the "Custom" type "Here be dragons" block into the "top" panelizer region
  And I click "Save"
  And the "Here be dragons" block should be in the "top" region
  And I wait 10 seconds
  And the "Recent content" block should be in the "left" region
  And I click the Panelizer "Edit" link
  And I wait 2 seconds
  And I remove the "Here be dragons" block from the "top" panelizer region
  And I scroll ".view-id-content_recent" into view
  And I remove the "Recent content" block from the "left" panelizer region
  And I wait 2 seconds
  And I click "Save"
Then I should not see the heading "Here be dragons"
  And I should not see the heading "Recent content"

  Examples:
  | role             |
  | content_creator  |
  | content_approver |

@api @javascript
Scenario: Create a Landing Page layout
Given I create "block_content" of type "basic":
  | type  | info           | body    | uuid                 |
  | basic | Here be dragon | RAWWWR! | test--here-be-dragon |
  | basic | And dinosour   | Boo...  | test--and-dino       |
  And "top_level_group" terms:
    | name     |
    | toplevel |
    | sports   |
  And I am logged in as a user with the "content_approver" role
When I visit "/node/add/landing_page"
  And I fill in the following:
    | Title                | BEHAT Landing Page       |
    | Description/Abstract | This is the description. |
  And I click on the element with css selector "#edit-group-l > summary:nth-child(1)"
  And I type "This is a left 1 box" in the "Left 1 - Box" WYSIWYG editor
  And I type "This is a left 2 box" in the "Left 2 - Box" WYSIWYG editor
  And I type "This is a left 3 box" in the "Left 3 - Box" WYSIWYG editor
  And I type "This is a left 4 box" in the "Left 4 - Box" WYSIWYG editor
  And I type "This is a left 5 box" in the "Left 5 - Box" WYSIWYG editor
  And I click on the element with css selector "#edit-group-center-content > summary:nth-child(1)"
  And I type "This is a center 2 box" in the "Center 2 - Box" WYSIWYG editor
  And I click on the element with css selector "#edit-group-ri > summary:nth-child(1)"
  And I type "This is a right 2 box" in the "Right 2 - Box" WYSIWYG editor
  And I type "This is a right 3 box" in the "Right 3 - Box" WYSIWYG editor
  And I type "This is a right 4 box" in the "Right 4 - Box" WYSIWYG editor
  And I scroll to the top
  And I click "Exchange Details"
  And I select "toplevel" from "Top Level Group"
  And I publish it
Then I should see the heading "BEHAT Landing Page"
  And I should see "This is a left 1 box"
  And I should see "This is a left 2 box"
  And I should see "This is a left 3 box"
  And I should see "This is a left 4 box"
  And I should see "This is a left 5 box"
  And I should see "This is a center 2 box"
  And I should see "This is a right 2 box"
  And I should see "This is a right 3 box"
  And I should see "This is a right 4 box"

@api
Scenario Outline: Access to Landing Page Creation
  Given I am logged in as a user with the "<role>" role
  When I am on "/node/add/landing_page"
  Then the response status code should be 200

  Examples:
    | role             |
    | content_creator  |
    | content_approver |
    | sitebuilder      |

@api @javascript
Scenario Outline: Landing Page Deletion
  Given "landing_page" content:
    | title                      | publish_at             | field_description_abstract | status | body  |
    | Behat DI-3232 Landing Page | 2017-11-11 12:00:00 PM | zion                       | 1      | mango |

  When I am logged in as a user with the "<role>" role
    And I am on "/admin/content"
    And I fill in "DI-3232" for "Title"
    And I press "Filter"
    And I wait for AJAX to finish
    And I click "Edit" in the "Behat DI-3232 Landing Page" row
    And I click "edit-delete"
    And I press the "Delete" button
  Then I should see the text "The Landing Page Behat DI-3232 Landing Page has been deleted."

  Examples:
    | role             |
    | content_creator  |
    | content_approver |
    | sitebuilder      |

@api @javascript
Scenario: Landing Page Override Modified Date Update
  Given "landing_page" content:
    | title             | field_description_abstract | status | body  | published_at        | changed | moderation_state | field_top_level_group |
    | Landing Page Test | zion                       | 1      | mango | 2020-07-03T16:00:05 | -5 day  | published        | My SEC                |
  When I am logged in as a user with the "content_approver" role
    And I am on "/my-sec/landing-page-test/edit"
    # Checking for usage of published date
  Then I should see the "input" element with the "value" attribute set to "2020-07-03" in the "published_on" region
  When I click secondary option "Override Modified Date"
    And I fill in the following:
      | edit-field-override-modified-date-0-value-date | 11/29/2021 |
      | edit-field-override-modified-date-0-value-time | 01:00:00AM |
    And I publish it
  Then I should see the text "Landing Page Landing Page Test has been updated."
  When I am on "/search"
    And I fill in "edit-search-api-fulltext" with "Landing Page Test"
    And I press the "edit-submit-the-exchange-search" button
  Then I should see the link "Landing Page Test"
    And I should see the text "Nov. 29, 2021"
  # Currently we cannot check on updated modified date, once the template is updated then we can uncomment out the below line
  #  And I should see the text "Modified: Nov. 29, 2021"
  When I visit "/my-sec/landing-page-test/edit"
    And I click secondary option "Override Modified Date"
    And I fill in the following:
      | edit-field-override-modified-date-0-value-date | 12/01/2021 |
      | edit-field-override-modified-date-0-value-time | 00:01:00AM |
    And I publish it
    And I run drush "cr"
    And I run drupal cron
    # Currently we cannot check on updated modified date, once the template is updated then we can uncomment out the below line
    # Then I should see the text "Modified: Dec. 1, 2021"
  When I am on "/search"
    And I fill in "edit-search-api-fulltext" with "Landing Page Test"
    And I press the "edit-submit-the-exchange-search" button
  Then I should see the link "Landing Page Test"
    And I should see the text "Dec. 1, 2021"

@api @javascript
Scenario: View Previous Revisions of Landing Page Content
  Given "landing_page" content:
    | title                   | field_description_abstract | status | body  | published_at        | changed | moderation_state | field_top_level_group | nid    |
    | Behat Landing Page Test | zion                       | 1      | mango | 2020-07-03T16:00:05 | -5 day  | published        | My SEC                | 985656 |
    And I am logged in as a user with the "Content Approver" role
  When I am on "/admin/content"
    And I select "Landing Page" from "type"
    And I press "Filter"
    And I wait for ajax to finish
    And I click "Edit" in the "Behat Landing Page Test" row
    And I fill in "This is the BEHAT v2" for "Title"
    And I press "Save and Create New Draft"
    And I am on "/node/985656/edit"
    And I fill in "This is the BEHAT v3" for "Title"
    And I publish it
    And I am on "/node/985656/edit"
    And I click "Revisions"
    And I click on the element with css selector "tr.odd:nth-child(3) > td:nth-child(1) > a:nth-child(1)"
  Then I should see the text "Behat Landing Page Test"
  When I am on "/my-sec/behat-v3/revisions"
    And I click on the element with css selector ".even > td:nth-child(1) > a:nth-child(1)"
  Then I should see the text "This is the BEHAT v2"
