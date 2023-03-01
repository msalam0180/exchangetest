Feature: Workflow and Permissions
  As an authenticated user
  I want to be able to view use workflow with the right permissions
  So that I create, edit, delete, and publish content

  Background:
    Given "topic" terms:
      | name                |
      | Behat Workflow Test |
      And "top_level_group" terms:
        | name      |
        | The Brass |
      And users:
        | name               | mail           | roles              |
        | creator            | test1@test.com | content_creator    |
        | approver           | test2@test.com | content_approver   |
        | sitebuilder        | test3@test.com | sitebuilder        |
        | microsite_creator  | test4@test.com | microsite_creator  |
        | microsite_approver | test5@test.com | microsite_approver |

@api @javascript
Scenario Outline: Content Workflow Option Based on Role
  Given I am logged in as a user with the "<role>" role
    And I visit "/node/add/announcement"
    And I fill in "Home Page Title" with "Behat Testing"
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I type "Source Test" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Obituary" from "Announcement Type"
    And I fill in "To" with "All SEC Contractors"
    And I select "Behat Workflow Test" from "Topic"
    And I select "The Brass" from "Top Level Group"
  When I press the "List additional actions" button
  Then I should see the "<button1>" button
    And I should see the "<button2>" button
    And I should see the "<button3>" button
    And I should not see the "<button4>" button

  Examples:
    | role             | button1                   | button2                 | button3                 | button4              |
    | content_creator  | Save and Create New Draft | Save and Request Review | Save and Request Review | Save and Publish     |
    | content_approver | Save and Create New Draft | Save and Request Review | Save and Publish        | Save and Unpublished |

@api @javascript
Scenario Outline: Microsite Field Required for Microsite Roles
  Given I am logged in as a user with the "<role>" role
  When I visit "<visit1>"
    And I fill in "Title" with "BEHAT Test Article"
    And I type "This is a test body" in the "Body" WYSIWYG editor
    And I type "This is a test source" in the "Source" WYSIWYG editor
    And I press the "Save and Create New Draft" button
  Then I should see the text "<result>"
  When I visit "<visit2>"
    And I fill in the following:
      | Title           | BEHAT Test announcement |
      | Home Page Title | Home page               |
    And I type "This is a test body" in the "Body" WYSIWYG editor
    And I type "This is a test source" in the "Source" WYSIWYG editor
    And I press the "Save and Create New Draft" button
  Then I should see the text "<result>"
  When I visit "<visit3>"
    And I fill in the following:
      | Title           | BEHAT Test announcement |
      | Home Page Title | Home page               |
    And I select "General" from "Event Type"
    And I select "Eastern" from "Timezone"
    And I fill in "2019-05-15 10:00:00 AM" in the "1" event start date
    And I fill in "2019-05-16 10:00:00 AM" in the "1" event end date
    And I type "Test Location" in the "1" session "Location" WYSIWYG editor
    And I type "This is a test body" in the "Body" WYSIWYG editor
    And I type "This is a test source" in the "Source" WYSIWYG editor
    And I press the "Save and Create New Draft" button
  Then I should see the text "<result>"

  Examples:
    | role                                  | visit1                | visit2                 | visit3          | result                       |
    | microsite_creator                     | /node/add/sec_article | /node/add/announcement | /node/add/event | Microsite field is required. |
    | microsite_approver                    | /node/add/sec_article | /node/add/announcement | /node/add/event | Microsite field is required. |
    | microsite_creator, microsite_approver | /node/add/sec_article | /node/add/announcement | /node/add/event | Microsite field is required. |

@api @javascript
Scenario: Content Review and Edits Workflow
  Given users:
    | name    | mail           | status | roles           | uid  |
    | behatcc | test3@test.com | 1      | content_creator | 9999 |
    And "announcement" content:
      | title             | field_short_title | body                   | field_source    | field_topic         | field_top_level_group | field_creator | field_sec_content_approver | status | moderation_state | uid  |
      | Free Pizzas Today | Free Pizzas       | This is the first body | Workflow Source | Behat Workflow Test | The Brass             | behatcc       | approver                   | 0      | draft            | 9999 |
  When I am logged in as "behatcc"
    And I visit "/admin/workbench/content/needs-edits"
  Then I should see the link "Free Pizzas Today"
  When I click "Edit" in the "Free Pizzas Today" row
    And I press the "List additional actions" button
    And I press the "Save and Request Review" button
  Then I should see the text "An email notification has been sent to test2@test.com for review article Free Pizzas Today."
  When I visit "/admin/workbench/content/needs-edits"
  Then I should not see the link "Free Pizzas Today"
  When I am logged in as "approver"
    And I visit "/admin/workbench/content/needs-review"
    And I should see the link "Free Pizzas Today"
    And I click "Edit" in the "Free Pizzas Today" row
    And I fill in "Revision log message" with "Back to Draft for a date change to next week instead!"
    And I press the "List additional actions" button
    And I press the "Save and Send Back to Draft" button
    And I visit "/admin/workbench/content/needs-review"
  Then I should not see the link "Free Pizzas Today"
  When I am logged in as "behatcc"
    And I visit "/admin/workbench/content/needs-edits"
  Then I should see the link "Free Pizzas Today"
    And I should see the text "Back to Draft for a date change to next week instead!"
  When I click "Edit" in the "Free Pizzas Today" row
    And I fill in "Title" with "Free Pizzas Next Week"
    And I fill in "Revision log message" with "I updated the title to next week"
    And I press the "List additional actions" button
    And I press the "Save and Request Review" button
    And I am logged in as "approver"
    And I visit "/admin/workbench/content/needs-review"
  Then I should see the link "Free Pizzas Next Week"
    And I should see the text "I updated the title to next week"

@api @javascript
Scenario: Content Review and Publish Workflow
  Given users:
    | name    | mail           | status | roles           | uid  |
    | behatcc | test3@test.com | 1      | content_creator | 9999 |
    And "announcement" content:
      | title                | field_short_title | body                   | field_source    | field_topic         | field_top_level_group | field_creator | field_sec_content_approver | status | moderation_state | uid  |
      | Free Pizzas Tomorrow | Free Pizzas       | This is the first body | Workflow Source | Behat Workflow Test | The Brass             | behatcc       | approver                   | 0      | draft            | 9999 |
  When I am logged in as "behatcc"
    And I visit "/admin/workbench/content/needs-edits"
    And I click "Edit" in the "Free Pizzas Tomorrow" row
    And I press the "List additional actions" button
    And I press the "Save and Request Review" button
  Then I should see the text "An email notification has been sent to test2@test.com for review article Free Pizzas Tomorrow."
  When I visit "/admin/workbench/content/needs-edits"
    And I should not see the link "Free Pizzas Tomorrow"
    And I am logged in as "approver"
    And I visit "/admin/workbench/content/needs-review"
  Then I should see the link "Free Pizzas Tomorrow"
  When I click "Edit" in the "Free Pizzas Tomorrow" row
    And I press the "List additional actions" button
    And I press the "Save and Publish" button
  Then I should see the text "An email notification has been sent to test3@test.com for review article Free Pizzas Tomorrow. Announcement Free Pizzas Tomorrow has been updated."
  When I visit "/admin/workbench/content/needs-review"
  Then I should not see the link "Free Pizzas Tomorrow"

@api @javascript
Scenario: Assigning Creator to Approve Content
  Given I am logged in as "creator"
    And I visit "/node/add/sec_article"
    And I fill in "Title" with "Behat Workflow Testing"
    And I type "Testing Workflow body" in the "Body" WYSIWYG editor
    And I type "Source Workflow Test" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Behat Workflow Test" from "Topic"
    And I select "The Brass" from "Top Level Group"
    And I click secondary option "Workflow Options"
    And I fill in "SEC Content Approver" with "creator"
  When I press the "Save and Create New Draft" button
  Then I should see the text "There are no users matching"

@api
Scenario Outline: Accessing Pages Based on Role
  Given I am logged in as a user with the "<role>" role
  When I am on "<URL1>"
  Then I should see the text "<Result1>"
  When I am on "<URL2>"
  Then I should see the text "<Result2>"
  When I am on "<URL3>"
  Then I should see the text "<Result3>"

  Examples:
    | role             | URL1                        | Result1          | URL2                          | Result2              | URL3          | Result3              |
    | administrator    | /admin/content/entity-usage | Impact Reporting | /admin/structure/taxonomy/add | Add vocabulary       | /admin/people | People               |
    | sitebuilder      | /admin/content/entity-usage | Impact Reporting | /admin/structure/taxonomy/add | Error 403: Forbidden | /admin/people | Error 403: Forbidden |
    | content_approver | /admin/content/entity-usage | Impact Reporting | /admin/structure/taxonomy/add | Error 403: Forbidden | /admin/people | Error 403: Forbidden |
    | content_creator  | /admin/content/entity-usage | Impact Reporting | /admin/structure/taxonomy/add | Error 403: Forbidden | /admin/people | Error 403: Forbidden |

@api @javascript
Scenario: Content Approver Viewing Unpublished Content
  Given users:
    | name    | mail           | status | roles           | uid  |
    | behatcc | test3@test.com | 1      | content_creator | 7777 |
    And "announcement" content:
      | title               | field_short_title | body                   | field_source | field_topic         | field_top_level_group | status | uid  |
      | Free Lunch Tomorrow | Free Lunch        | This is the first body | View Source  | Behat Workflow Test | The Brass             | 0      | 7777 |
  When I am logged in as a user with the "content_approver" role
    And I visit "/admin/content"
    And I select "Unpublished" from "Published status"
    And I press the "edit-submit-content" button
  Then I should see the link "Free Lunch Tomorrow"
    #validate that Content Approver has the ability to edit unpublished content
  When I click "Edit" in the "Free Lunch Tomorrow" row
  Then I should see the heading "Edit Announcement Free Lunch Tomorrow"

@api
Scenario Outline: Static File Content Creation Access
  Given I am logged in as a user with the "<role>" role
  When I am on "/node/add/file"
  Then the response status code should be <code>

  Examples:
    | role               | code |
    | administrator      | 200  |
    | sitebuilder        | 403  |
    | content_approver   | 403  |
    | content_creator    | 403  |
    | microsite_creator  | 403  |
    | microsite_approver | 403  |

@api
Scenario Outline: Creators Can No Longer Add Static File Content
  Given I am logged in as a user with the "<Role>" role
  When I visit "/node/add"
  Then I should not see the link "Static File"

  Examples:
    | Role               |
    | content_creator    |
    | content_approver   |
    | microsite_creator  |
    | microsite_approver |

@api @javascript
Scenario Outline: Admin And Sitebuilder Users Can No Longer Add Static File Content
  Given I am logged in as a user with the "<Role>" role
  When I visit "/node/add"
  Then the "Static File" link should be hidden

  Examples:
    | Role          |
    | administrator |
    | sitebuilder   |

@api @javascript
Scenario Outline: Deleting Taxonomy Tag Terms
  Given I am logged in as a user with the "<role>" role
  When I am on "/admin/structure/taxonomy/manage/tags/overview"
    And I click "Add term"
    And I fill in "Name" with "BEHAT Test Taxonomy Tag"
    And I press "Save"
    And I visit "/admin/structure/taxonomy"
    And I click "List terms" in the "Tags" row
  Then I should see the link "BEHAT Test Taxonomy Tag"
  When I click "Edit" in the "BEHAT Test Taxonomy Tag" row
    And I click "edit-delete"
    And I press "Delete"
    And I wait 2 seconds
  Then I should not see the link "BEHAT Test Taxonomy Tag"

  Examples:
    | role          |
    | administrator |
    | sitebuilder   |
