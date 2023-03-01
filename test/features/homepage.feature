Feature: View the Homepage
  As a Visitor to the Insider
  I want to see the latest highlighted and updated information on the homepage
  So that I can quickly navigate to the most important information on the Insider

  Background:
    Given users:
      | name            | mail                     | roles            |
      | jack-creator    | jack_creator@test.com    | content_creator  |
      | jill@approver   | jill_approver@test.com   | content_approver |
      | bob.sitebuilder | bob_sitebuilder@test.com | sitebuilder      |
      | john auth       | john_auth@test.com       |                  |
      | suzy_admin      | suzy_admin@test.com      | administrator    |
      | jane auth       | jane_auth@test.com       |                  |

  @api
  Scenario: View All Types of Highlighted Information on the Homepage
    Given I am logged in as a user with the "Authenticated user" role
      And "image" content:
      | title              | field_alt_text               | field_image_upload     |
      | BEHAT Bird Image   | This is a picure of a bird   | image;behat-bird.gif   |
      | BEHAT Rabbit Image | This is a picure of a rabbit | image;behat-rabbit.jpg |
      | BEHAT Dog Image    | This is a picure of a bird   | image;behat-dog.jpeg   |
      | BEHAT Cat Image    | This is a picure of a bird   | image;behat-cat.png    |
      And "featured" content:
      | title                | field_featured_type | field_teaser        | field_image_reference | field_url                         | promote | status |
      | BEHAT Announcement 0 | highlighted_item    | This is not a bird. | BEHAT Bird Image      | Link 1 - http://www.google.com    | 0       | 1      |
      | BEHAT Announcement 1 | highlighted_item    | This is a bird.     | BEHAT Bird Image      | Link 1 - http://www.google.com    | 1       | 1      |
      | BEHAT Announcement 2 | highlighted_item    | This is a rabbit.   | BEHAT Rabbit Image    |                                   | 1       | 1      |
      | BEHAT Announcement 3 | highlighted_item    | This is a dog.      | BEHAT Dog Image       | Link 3 - http://www.accenture.com | 1       | 1      |
      | BEHAT Announcement 4 | highlighted_item    | This is a cat.      | BEHAT Cat Image       | Link 4 - http://www.youtube.com   | 1       | 1      |
      | BEHAT Announcement 5 | highlighted_item    | This is not a cat.  | BEHAT Cat Image       |                                   | 1       | 1      |
    When I am on the homepage
    Then I should see the heading "Highlights"
      And I should see the link "BEHAT Announcement 1"
      And I should see the text "This is a bird."
      And I should see the text "BEHAT Announcement 2"
      And I should see the text "This is a rabbit."
      And I should not see the link "BEHAT Announcement 2"
      And I should see the link "BEHAT Announcement 3"
      And I should see the text "This is a dog."
      And I should see the link "BEHAT Announcement 4"
      And I should see the text "This is a cat."
      And I should not see the link "BEHAT Announcement 5"
      And I should not see the text "This is not a cat."
      And I should not see the link "BEHAT Announcement 0"
      And I should not see the text "This is not a bird."
      And I should see the "img" element with the "alt" attribute set to "Behat test image" in the "highlights" region

  @api @javascript
  Scenario: Create Highlight through UI with Internal Link
    Given "image" content:
      | title            | field_alt_text              | field_image_upload   |
      | BEHAT Bird Image | This is a picture of a bird | image;behat-bird.gif |
      And "sec_article" content:
      | title         | body                            | status |
      | BEHAT Article | This is the body of the article | 1      |
      And I am logged in as a user with the "content_approver" role
    When I am on "/node/add/featured"
      And I fill in the following:
      | Title         | BEHAT Highlight  |
      | Featured Type | highlighted_item |
      And I select the first autocomplete option for "BEHAT Article" on the "Content/Link URL" field
      And I select the first autocomplete option for "BEHAT Bird Image" on the "Image Reference" field
      And I type "This is a new BEHAT Highlight." in the "Teaser" WYSIWYG editor
      And I click secondary option "Promotion options"
      And I fill in "edit-promote-value" with "1"
      And I publish it
      And I am on the homepage
    Then I should see the link "BEHAT Highlight"
      And I should see the text "This is a new BEHAT Highlight."
      And I should see the "img" element with the "alt" attribute set to "Behat test image" in the "highlights" region
    When I visit "/admin/content"
      And I click "Edit" in the "BEHAT Highlight" row
      And I wait 1 seconds
      And I scroll "#edit-field-teaser-wrapper" into view
      And I type "This is the most up to date BEHAT Highlight." in the "Teaser" WYSIWYG editor
      And I publish it
      And I am on the homepage
    Then I should see the link "BEHAT Highlight"
      And I should see the text "This is the most up to date BEHAT Highlight."

  @api @javascript
  Scenario: Change Order of Highlights on Homepage
    Given "image" content:
      | title              | field_alt_text               | field_image_upload     |
      | BEHAT Bird Image   | This is a picure of a bird   | image;behat-bird.gif   |
      | BEHAT Rabbit Image | This is a picure of a rabbit | image;behat-rabbit.jpg |
      | BEHAT Dog Image    | This is a picure of a bird   | image;behat-dog.jpeg   |
      | BEHAT Cat Image    | This is a picure of a bird   | image;behat-cat.png    |
      And "featured" content:
      | title                | field_featured_type | field_teaser        | field_image_reference | field_url                         | promote | status |
      | BEHAT Announcement 0 | highlighted_item    | This is not a bird. | BEHAT Bird Image      | Link 1 - http://www.google.com    | 0       | 1      |
      | BEHAT Announcement 1 | highlighted_item    | This is a bird.     | BEHAT Bird Image      | Link 1 - http://www.google.com    | 1       | 1      |
      | BEHAT Announcement 2 | highlighted_item    | This is a rabbit.   | BEHAT Rabbit Image    |                                   | 1       | 1      |
      | BEHAT Announcement 3 | highlighted_item    | This is a dog.      | BEHAT Dog Image       | Link 3 - http://www.accenture.com | 1       | 1      |
      | BEHAT Announcement 4 | highlighted_item    | This is a cat.      | BEHAT Cat Image       | Link 4 - http://www.youtube.com   | 1       | 1      |
      | BEHAT Announcement 5 | highlighted_item    | This is not a cat.  | BEHAT Cat Image       |                                   | 1       | 1      |
      And I am logged in as a user with the "administrator" role
    When I am on "/admin/content/highlights"
    Then I should see the text 'The top four Featured Items in the list will appear on the homepage under the "Highlights" section. For Featured Items that are not going be posted on the homepage again, please uncheck the "Promoted to front page" checkbox to remove those items from this list.'
    When I drag highlight "BEHAT Announcement 3" onto "BEHAT Announcement 1"
      And I scroll to the top
      And I press "Save order"
      And I am on the homepage
    Then "BEHAT Announcement 3" should precede "BEHAT Announcement 1" for the query "//div[contains(@class, 'highlights-block_1')]//h3"

  @api
  Scenario: Click an event link
    Given I am logged in as a user with the "Authenticated user" role
      And I create "paragraph" of type "paragraph_session":
      | KEY | field_location | field_start_date | field_end_date |
      | 100 | Texas          | +2 hour          | +1 day         |
      And I create "node" of type "event":
      | title              | field_short_title | field_event_type | body                | status | field_session |
      | BEHAT Event Test 0 | Home Page Title 0 | general          | This is an Event 0. | 1      | 100           |
    When I am on the homepage
      And I click "Home Page Title 0"
    Then I should see the text "BEHAT Event Test 0"
      And I should see the text "Texas"
      And I should see the text "This is an Event 0."

  @api @javascript
  Scenario Outline: Masquerade-Unmasquerade As End User
    Given "top_level_group" terms:
      | name   |
      | sports |
      And "sec_article" content:
        | title           | moderation_state | status | body             |
        | My test article | published        | 1      | This is the body |
      And "landing_page" content:
        | title                | field_description_abstract | field_landing_page_subtype | field_top_level_group | status | moderation_state |
        | DI-6242 Landing Page | Bloomberg                  | web-based                  | sports                | 1      | published        |
		  And "event" content:
        | title                | field_short_title    | body                   | field_source | status | published_at | moderation_state | changed |
        | Behat Training Event | Home Page Title 0 K9 | This is a Drupal Event | Minnie Mouse | 1      | +3 day       | published        | +5 day  |
      And "announcement" content:
        | title                | field_short_title    | body       | status | field_announcement_type | moderation_state | nid     |
        | DI-6242 announcement | Free ice-cubes today | ice-cubes! | 1      | Obituary                | published        | 9687456 |
    When I am logged in as a user with the "<role>" role
    #Article
      And I am on "/my-test-article"
      And I should see the heading "My test article"
      And I press the "Preview as Enduser" button
    Then I should see the text "Welcome, Enduser" in the "username" region
      And I should not see the link "Workbench"
      And I should not see the link "Manage"
      And I should not see the text "You are not allowed to masquerade as enduser."
      And I should see the heading "My test article"
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the link "Workbench"
      And I should see the link "Manage"
      And I should see the "Preview as Enduser" button
      And I should see the heading "My test article"
    #Landing Page
    When I am on "/web-based/di-6242-landing-page"
      And I should see the heading "DI-6242 Landing Page"
      And I press the "Preview as Enduser" button
    Then I should see the text "Welcome, Enduser" in the "username" region
      And I should not see the link "Workbench"
      And I should not see the link "Manage"
      And I should not see the text "You are not allowed to masquerade as enduser."
      And I should see the heading "DI-6242 Landing Page"
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the link "Workbench"
      And I should see the link "Manage"
      And I should see the "Preview as Enduser" button
      And I should see the heading "DI-6242 Landing Page"
    #List Page
    When I am on "/news/announcements"
      And I should see the link "DI-6242 announcement"
      And I press the "Preview as Enduser" button
    Then I should see the text "Welcome, Enduser" in the "username" region
      And I should not see the link "Workbench"
      And I should not see the link "Manage"
      And I should not see the text "You are not allowed to masquerade as enduser."
      And I should see the link "DI-6242 announcement"
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the link "Workbench"
      And I should see the link "Manage"
      And I should see the "Preview as Enduser" button
      And I should see the link "DI-6242 announcement"
    #Event
    When I am on "/events/behat-training-event"
      And I should see the heading "Behat Training Event"
      And I press the "Preview as Enduser" button
    Then I should see the text "Welcome, Enduser" in the "username" region
      And I should not see the link "Workbench"
      And I should not see the link "Manage"
      And I should not see the text "You are not allowed to masquerade as enduser."
      And I should see the heading "Behat Training Event"
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the link "Workbench"
      And I should see the link "Manage"
      And I should see the "Preview as Enduser" button
      And I should see the heading "Behat Training Event"
    #Announcement
    When I am on "/node/9687456"
      And I should see the heading "DI-6242 announcement"
      And I press the "Preview as Enduser" button
    Then I should see the text "Welcome, Enduser" in the "username" region
      And I should not see the link "Workbench"
      And I should not see the link "Manage"
      And I should not see the text "You are not allowed to masquerade as enduser."
      And I should see the heading "DI-6242 announcement"
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the link "Workbench"
      And I should see the link "Manage"
      And I should see the "Preview as Enduser" button
      And I should see the heading "DI-6242 announcement"

    Examples:
      | role             |
      | sitebuilder      |
      | content_approver |
      | content_creator  |

  @api @javascript
  Scenario: Masquerade On Page With Panelizer
    Given I am logged in as a user with the "content_approver" role
    When I am viewing an "landing_page" content:
      | title            | BEHAT Landing Page |
      | moderation_state | published          |
      | status           | 1                  |
      | body             | This is the body   |
      And I press the "Preview as Enduser" button
    Then I should see the text "Welcome, Enduser" in the "username" region
      And I should not see the link "Workbench"
      And I should not see the link "Manage"
      And I should not see the text "You are not allowed to masquerade as enduser."
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the link "Workbench"
      And I should see the link "Manage"
      And I should see the "Preview as Enduser" button
    #Test panelizer Edit button does not render masquerade button non-clickable
      And I visit "/behat-landing-page"
      And I click the Panelizer "Edit" link
      And I press the "Preview as Enduser" button
    Then I should see the text "Welcome, Enduser" in the "username" region
      And I should not see the link "Workbench"
      And I should not see the link "Manage"
      And I should not see the text "You are not allowed to masquerade as enduser."
    When I click "Switch back"
    Then I should see the text "You are no longer masquerading as enduser."
      And I should see the link "Workbench"
      And I should see the link "Manage"
      And I should see the "Preview as Enduser" button

  @api @javascript
  Scenario: Verify askHR Link On Main Menu Opens In New Tab
    Given I am logged in as a user with the "sitebuilder" role
    When I visit "/admin/structure/menu/manage/main/add"
      And I fill in the following:
      | Menu link title | askHR1                                           |
      | Link            | https://seceamsprod.servicenowservices.com/askhr |
      | Weight          | -73                                              |
      And I select "MY SEC" from "Parent link"
      And I press "Save"
      And I am logged in as a user with the "Authenticated user" role
      And I visit "/"
      And I wait 1 seconds
      And I hover over the element "#main-menu > li:nth-child(1)"
      And I wait 1 seconds
      And I click "askHR1"
    Then the link should open in a new tab
      And I close the current window

  @api @javascript
  Scenario Outline: Username Visibility On The Exchange
    Given I am logged in as "<username>"
    When I visit "/"
    Then I should not see the text "<mail>" in the "username" region
      And I should see the text "<name>" in the "username" region
    When I visit "/news"
    Then I should not see the text "<mail>" in the "username" region
      And I should see the text "<name>" in the "username" region
    When I visit "/announcements"
    Then I should not see the text "<mail>" in the "username" region
      And I should see the text "<name>" in the "username" region
    When I visit "/events"
    Then I should not see the text "<mail>" in the "username" region
      And I should see the text "<name>" in the "username" region

    Examples:
      | username        | name            | mail                     |
      | jack-creator    | Jack-Creator    | jack_creator@test.com    |
      | jill@approver   | Jill            | jill_approver@test.com   |
      | bob.sitebuilder | Bob.Sitebuilder | bob_sitebuilder@test.com |
      | john auth       | John Auth       | john_auth@test.com       |
      | suzy_admin      | Suzy_Admin      | suzy_admin@test.com      |

  @api @javascript
  Scenario: User Can Add Custom QuickLinks
    Given "link" content:
      | title         | field_description_abstract | field_url                  | field_add_to_available_quicklink |
      | BEHAT Link 1  | This is a test             | A Link1 - http://test.com  | 1                                |
      | BEHAT Link 2  | This is a test             | A Link2 - http://test.com  | 1                                |
      | BEHAT Link 3  | This is a test             | A Link3 - http://test.com  | 1                                |
      | BEHAT Link 4  | This is a test             | A Link4 - http://test.com  | 1                                |
      | BEHAT Link 5  | This is a test             | A Link5 - http://test.com  | 1                                |
      | BEHAT Link 6  | This is a test             | A Link6 - http://test.com  | 1                                |
      | BEHAT Link 7  | This is a test             | A Link7 - http://test.com  | 1                                |
      | BEHAT Link 8  | This is a test             | A Link8 - http://test.com  | 1                                |
      | BEHAT Link 9  | This is a test             | A Link9 - http://test.com  | 1                                |
      | BEHAT Link 10 | This is a test             | A Link10 - http://test.com | 1                                |
      | BEHAT Link 11 | This is a test             | A Link11 - http://test.com | 1                                |
      | BEHAT Link 12 | This is a test             | A Link12 - http://test.com | 1                                |
      | BEHAT Link 13 | This is a test             | A Link13 - http://test.com | 1                                |
    When I am logged in as a user with the "Authenticated user" role
      And I am on "/"
      And I wait 1 seconds
    Then I should see the link "QuickLinks"
    When I hover over the element "#quick-links"
      And I wait 1 seconds
      And I click "+ Edit"
    Then I should see the heading "Available QuickLinks"
      And I should see the heading "My QuickLinks"
    When I select "Remove all QuickLinks" from "Reset My QuickLinks"
      And I press "Apply"
      And I click "Add to My QuickLinks" in the "A Link1" row
    Then I should see the text "The selected QuickLink has been added."
    When I click "Add to My QuickLinks" in the "A Link2" row
      And I click "Add to My QuickLinks" in the "A Link3" row
      And I click "Add to My QuickLinks" in the "A Link4" row
      And I click "Add to My QuickLinks" in the "A Link5" row
      And I click "Add to My QuickLinks" in the "A Link6" row
      And I click "Add to My QuickLinks" in the "A Link7" row
      And I click "Add to My QuickLinks" in the "A Link8" row
      And I click "Add to My QuickLinks" in the "A Link9" row
      And I click "Add to My QuickLinks" in the "A Link10" row
      And I click "Add to My QuickLinks" in the "A Link11" row
      And I click "Add to My QuickLinks" in the "A Link12" row
      And I click "Add to My QuickLinks" in the "A Link13" row
    Then I should see the text "You can only have 12 QuickLinks. To add more, you need to remove some QuickLinks from your list."
      And I should see the text "A Link1" in the "myquicklinks" region
      And I should see the text "A Link2" in the "myquicklinks" region
      And I should see the text "A Link11" in the "myquicklinks" region
      And I should see the text "A Link12" in the "myquicklinks" region
      And I should not see the text "A Link13" in the "myquicklinks" region

  @api @javascript
  Scenario Outline: Search QuickLinks
    Given "link" content:
      | title         | field_description_abstract | field_url                      | field_add_to_available_quicklink |
      | BEHAT Link 1  | This is a test             | BEHAT Link1 - http://test.com  | 1                                |
      | BEHAT Link 2  | This is a test             | BEHAT Link2 - http://test.com  | 1                                |
      | BEHAT Link 3  | This is a test             | BEHAT Link3 - http://test.com  | 1                                |
      | BEHAT Link 10 | This is a test             | BEHAT Link10 - http://test.com | 1                                |
      | BEHAT Link 20 | This is a test             | BEHAT Link20 - http://test.com | 1                                |
      | BEHAT Link 30 | This is a test             | BEHAT Link30 - http://test.com | 1                                |
    When I am logged in as a user with the "Authenticated user" role
      And I am on "/"
      And I wait 1 seconds
      And I hover over the element "#quick-links"
      And I wait 1 seconds
      And I click "+ Edit"
      And I fill in "Search QuickLinks" with "<keyword>"
      And I click on the element with css selector "#edit-submit-available-quicklinks"
    Then I should see the text "<value1>"
      And I should see the text "<value2>"
      And I should not see the text "<value3>"
    Examples:
      | keyword | value1      | value2       | value3      |
      | 1       | BEHAT Link1 | BEHAT Link10 | BEHAT Link2 |
      | 2       | BEHAT Link2 | BEHAT Link20 | BEHAT Link3 |
      | 3       | BEHAT Link3 | BEHAT Link30 | BEHAT Link1 |

  @api @javascript
  Scenario: External QuickLinks Open In New Tab
    Given "link" content:
      | title        | field_description_abstract | field_url                     | field_add_to_available_quicklink |
      | BEHAT Link 1 | This is a test             | BEHAT Link1 - http://test.com | 1                                |
      | BEHAT Link 2 | This is a test             | BEHAT Link2 - http://test.com | 1                                |
      | BEHAT Link 3 | This is a test             | BEHAT Link3 - http://test.com | 1                                |
      And I am logged in as a user with the "Authenticated user" role
      And I am on "/"
      And I wait 1 seconds
    When I hover over the element "#quick-links"
    Then I should not see the link "BEHAT Link1"
      And I should not see the link "BEHAT Link2"
      And I should not see the link "BEHAT Link3"
      And I wait 1 seconds
      And I click "+ Edit"
      And I click "Add to My QuickLinks" in the "BEHAT Link1" row
      And I click "Add to My QuickLinks" in the "BEHAT Link2" row
      And I click "Add to My QuickLinks" in the "BEHAT Link3" row
    When I hover over the element "#quick-links"
      And I wait 1 seconds
      And I click "BEHAT Link1"
    Then the link should open in a new tab
      And I close the current window

  @api @javascript
  Scenario Outline: User Can Reset QuickLinks
    Given "link" content:
      | title        | field_description_abstract | field_url                     | field_add_to_available_quicklink |
      | BEHAT Link 1 | This is a test             | BEHAT Link1 - http://test.com | 1                                |
      | BEHAT Link 2 | This is a test             | BEHAT Link2 - http://test.com | 1                                |
      | BEHAT Link 3 | This is a test             | BEHAT Link3 - http://test.com | 1                                |
      And I am logged in as a user with the "Authenticated user" role
      And I am on "/"
      And I wait 1 seconds
    When I hover over the element "#quick-links"
      And I wait 1 seconds
      And I click "+ Edit"
      And I click "Add to My QuickLinks" in the "BEHAT Link1" row
      And I click "Add to My QuickLinks" in the "BEHAT Link2" row
      And I should see the text "BEHAT Link1" in the "myquicklinks" region
      And I should see the text "BEHAT Link2" in the "myquicklinks" region
      And I should not see the text "BEHAT Link3" in the "myquicklinks" region
    When I select "<option>" from "Reset My QuickLinks"
      And I press "Apply"
    Then I should see the text "<result>"

    Examples:
      | option                      | result                                      |
      | Remove all QuickLinks       | All your QuickLinks have been reset.        |
      | Reset to default QuickLinks | Your QuickLinks have been reset to default. |

  @api @javascript
  Scenario: Sorting And Pagination On QuickLinks Page
    Given "link" content:
      | title         | field_description_abstract | field_url                  | field_add_to_available_quicklink |
      | BEHAT Link 1  | This is a test             | A Link1 - http://test.com  | 1                                |
      | BEHAT Link 2  | This is a test             | A Link2 - http://test.com  | 1                                |
      | BEHAT Link 3  | This is a test             | A Link3 - http://test.com  | 1                                |
      | BEHAT Link 4  | This is a test             | A Link4 - http://test.com  | 1                                |
      | BEHAT Link 5  | This is a test             | A Link5 - http://test.com  | 1                                |
      | BEHAT Link 6  | This is a test             | A Link6 - http://test.com  | 1                                |
      | BEHAT Link 7  | This is a test             | A Link7 - http://test.com  | 1                                |
      | BEHAT Link 8  | This is a test             | A Link8 - http://test.com  | 1                                |
      | BEHAT Link 9  | This is a test             | A Link9 - http://test.com  | 1                                |
      | BEHAT Link 10 | This is a test             | A Link10 - http://test.com | 1                                |
      | BEHAT Link 11 | This is a test             | A Link11 - http://test.com | 1                                |
      | BEHAT Link 12 | This is a test             | A Link12 - http://test.com | 1                                |
      | BEHAT Link 13 | This is a test             | A Link13 - http://test.com | 1                                |
      | BEHAT Link 14 | This is a test             | A Link14 - http://test.com | 1                                |
      | BEHAT Link 15 | This is a test             | A Link15 - http://test.com | 1                                |
      | BEHAT Link 16 | This is a test             | A Link16 - http://test.com | 1                                |
      | BEHAT Link 17 | This is a test             | A Link17 - http://test.com | 1                                |
      | BEHAT Link 18 | This is a test             | A Link18 - http://test.com | 1                                |
      | BEHAT Link 19 | This is a test             | A Link19 - http://test.com | 1                                |
      | BEHAT Link 20 | This is a test             | A Link20 - http://test.com | 1                                |
      | BEHAT Link 21 | This is a test             | A Link21 - http://test.com | 1                                |
      | BEHAT Link 22 | This is a test             | A Link22 - http://test.com | 1                                |
      | BEHAT Link 23 | This is a test             | A Link23 - http://test.com | 1                                |
      | BEHAT Link 24 | This is a test             | A Link24 - http://test.com | 1                                |
      | BEHAT Link 25 | This is a test             | A Link25 - http://test.com | 1                                |
      | BEHAT Link 26 | This is a test             | A Link26 - http://test.com | 1                                |
      | BEHAT Link 27 | This is a test             | A Link27 - http://test.com | 1                                |
      | BEHAT Link 28 | This is a test             | A Link28 - http://test.com | 1                                |
      And I am logged in as a user with the "Authenticated user" role
      And I am on "/"
      And I wait 1 seconds
      And I hover over the element "#quick-links"
      And I wait 1 seconds
      And I click "+ Edit"
      And I wait 1 seconds
    Then "A Link1" should precede "A Link10" for the query "//td[contains(@class, 'views-field views-field-field-url')]"
      And "A Link17" should precede "A Link18" for the query "//td[contains(@class, 'views-field views-field-field-url')]"
      And "A Link19" should precede "A Link2" for the query "//td[contains(@class, 'views-field views-field-field-url')]"
      And I click "Page 2"
      And I wait for ajax to finish
      And "A Link28" should precede "A Link3" for the query "//td[contains(@class, 'views-field views-field-field-url')]"
      And "A Link8" should precede "A Link9" for the query "//td[contains(@class, 'views-field views-field-field-url')]"

  @api @javascript
  Scenario: QuickLinks List as Hyperlink
    Given "link" content:
      | title        | field_description_abstract | field_url                           | field_add_to_available_quicklink |
      | BEHAT Link 1 | This is a test             | BEHAT Link1 - http://www.google.com | 1                                |
      | BEHAT Link 2 | This is a test             | BEHAT Link2 - http://www.google.com | 1                                |
      And "sec_article" content:
      | title           | field_body | field_source | top_level_group | topic | status |
      | Behat Article-1 | testing    | testing      | anything        | fun   | 1      |
      And I am logged in as a user with the "content_approver" role
      And I visit "/node/add/link"
      And I fill in the following:
      | Title                | Behat Test Internal Link |
      | Description/Abstract | Link Description         |
      | Link text            | BEHAT Link3              |
      And I select the first autocomplete option for "BEHAT Article-1" on the "URL" field
      And I check "Add to Available QuickLinks"
      And I press "Save"
    When I am logged in as a user with the "Authenticated user" role
      And I am on "/user/profile/quicklinks"
      And I scroll to the bottom
      And I click "BEHAT Link1"
      And I wait 2 seconds
    Then the link should open in a new tab
    When I am on "/user/profile/quicklinks"
      And I scroll to the bottom
      And I click "BEHAT Link2"
    Then the link should open in a new tab
    When I am on "/user/profile/quicklinks"
      And I scroll to the bottom
      And I click "BEHAT Link3"
    Then the link should open in a new tab
      And I close the current window

  @api @javascript
  Scenario: Add to Default QuickLinks
    Given I am logged in as a user with the "content_approver" role
    When I visit "/node/add/link"
      And I fill in the following:
      | Title                | Behat Test Internal Link 1 |
      | Description/Abstract | Link Description           |
      | Link text            | Behat Link 1               |
      And I fill in "URL" with "http://google.com"
      And I check "Add to Available QuickLinks"
      And I check "Add to Default QuickLinks"
      And I check the box "Published"
      And I press "Save"
      And I visit "/node/add/link"
      And I fill in the following:
      | Title                | Behat Test Internal Link 2 |
      | Description/Abstract | Link Description           |
      | Link text            | Behat Link 2               |
      And I fill in "URL" with "http://google.com"
      And I check "Add to Available QuickLinks"
      And I check "Add to Default QuickLinks"
      And I uncheck the box "Published"
      And I press "Save"
      And I am logged in as a user with the "Authenticated user" role
      And I hover over the element "#quick-links"
      And I wait 1 seconds
      And I click "+ Edit"
      And I select "Reset to default QuickLinks" from "Reset My QuickLinks"
      And I press "Apply"
    Then I should see the text "Your QuickLinks have been reset to default."
    When I hover over the element "#quick-links"
      And I wait 1 seconds
    Then I should see the text "Behat Link 1"
      And I should not see the text "Behat Link 2"

  @api @javascript
  Scenario: Update QuickLinks Help Text
    Given I am logged in as a user with the "content_creator" role
      And I am on "user/profile/quicklinks"
      And I wait 2 seconds
    When I click on the element with css selector "#block-quicklinkshelp > div.contextual > button"
      And I click on the element with css selector "#block-quicklinkshelp > div.contextual > ul > li.block-contentblock-edit > a"
      And I click on the element with css selector "body"
      And I type "QuickLinks help text is updated." in the "Body" WYSIWYG editor
      And I click on the element with css selector "#edit-submit"
      And I am on "user/profile/quicklinks"
    Then I should see the text "QuickLinks help text is updated."
    When I am logged in as a user with the "Authenticated user" role
      And I am on "user/profile/quicklinks"
    Then I should see the text "QuickLinks help text is updated."
    When I am on "/block/46"
    Then I should see the heading "Error 403: Forbidden"
    When I am not logged in
      And I am on "user/profile/quicklinks"
    Then I should see the heading "Access denied"
      And I should not see the text "QuickLinks Help"

  @api @javascript
  Scenario: Add and Remove Link to Default QuickLinks Using Admin Content Page
    Given "link" content:
      | title        | field_description_abstract | field_url                     | field_add_to_available_quicklink |
      | BEHAT Link 1 | This is a test             | BEHAT Link1 - http://test.com | 1                                |
      And I am logged in as a user with the "content_creator" role
    When I hover over the element "#quick-links"
      And I should not see the text "BEHAT Link 1"
      And I visit "/admin/content"
      And I fill in "BEHAT Link 1" for "Title"
      And I press "Filter"
      And I select "Add to my QuickLinks Menu" from "Action"
      And I check "edit-node-bulk-form-0"
      And I click on the element with css selector "#edit-submit--2"
    Then I visit "/"
      And I hover over the element "#quick-links"
      And I wait 2 seconds
      And I should see the text "BEHAT Link1"
    When I visit "/admin/content"
      And I fill in "BEHAT Link 1" for "Title"
      And I press "Filter"
      And I select "Remove from my QuickLinks Menu" from "Action"
      And I check "edit-node-bulk-form-0"
      And I click on the element with css selector "#edit-submit--2"
    Then I visit "/"
      And I hover over the element "#quick-links"
      And I wait 2 seconds
      And I should not see the text "BEHAT Link1"

  @api @javascript
  Scenario: Date Sort on Highlights Archive
    Given I am logged in as a user with the "Authenticated user" role
      And "image" content:
      | title        | field_alt_text               | field_image_upload     |
      | BEHAT Bird   | This is a bird.              | image;behat-bird.gif   |
      | BEHAT Rabbit | This is a picure of a rabbit | image;behat-rabbit.jpg |
      And "featured" content:
      | title                      | field_featured_type | field_teaser        | field_image_reference | field_url                      | published_at        | changed             | field_publish_date promote | status | field_title_visibility | field_hero_position | promote |
      | BEHAT DI-4169 Announcement | highlighted_item    | This is not a bird. | BEHAT Rabbit          | Link 1 - http://www.yahoo.com  | 2019-08-11 12:00:00 | 2019-08-10 12:00:00 | 0                          | 1      |                        |                     |         |
      | BEHAT NewTest Announcement | highlighted_item    | This is not a fox   | BEHAT Bird            | Link 1 - http://www.google.com | 2019-05-11 12:00:00 | 2019-05-10 12:00:00 | 0                          | 1      |                        |                     |         |
      | BEHAT hero1                | hero                |                     | BEHAT Rabbit          | Link 1 - http://www.yahoo.com  | 2019-12-10 12:00:00 | 2019-12-10 12:00:00 |                            | 1      | visible                | Middle              | 0       |
      | BEHAT hero2                | hero                |                     | BEHAT Bird            | Link 1 - http://www.google.com | 2019-11-16 12:00:00 | 2019-11-16 12:00:00 |                            | 1      | visible                | Middle              | 0       |
    When I am on "/highlights"
    Then I should see the heading "Highlights Archive"
      And I should see the link "BEHAT DI-4169 Announcement"
      And I should see the link "BEHAT NewTest Announcement"
      And I should see the link "BEHAT hero1"
      And I should see the link "BEHAT hero2"
    When I click the sort filter "Date"
      And I wait for ajax to finish
    Then "BEHAT NewTest Announcement" should precede "BEHAT DI-4169 Announcement" for the query "//*[@class ='views-field views-field-title']"
      And "BEHAT DI-4169 Announcement" should precede "BEHAT hero2" for the query "//*[@class ='views-field views-field-title']"
      And "BEHAT hero2" should precede "BEHAT hero1" for the query "//*[@class ='views-field views-field-title']"
    When I click the sort filter "Date"
      And I wait for ajax to finish
    Then "BEHAT hero1" should precede "BEHAT hero2" for the query "//*[@class ='views-field views-field-title']"
      And "BEHAT hero2" should precede "BEHAT DI-4169 Announcement" for the query "//*[@class ='views-field views-field-title']"
      And "BEHAT DI-4169 Announcement" should precede "BEHAT NewTest Announcement" for the query "//*[@class ='views-field views-field-title']"

  @api @javascript
  Scenario: Featured Type Filter on Highlights Archive
    Given I am logged in as a user with the "content_approver" role
      And "image" content:
      | title        | field_alt_text               | field_image_upload     |
      | BEHAT Bird   | This is a bird.              | image;behat-bird.gif   |
      | BEHAT Rabbit | This is a picure of a rabbit | image;behat-rabbit.jpg |
      And "featured" content:
      | title               | field_featured_type | field_teaser                     | field_image_reference | field_url                      | published_at        | changed             | field_publish_date promote | status | field_hero_position | field_title_visibility |
      | BEHAT Announcement1 | highlighted_item    | This is not a bird but a rabbit. | BEHAT Rabbit          | Link 1 - http://www.yahoo.com  | 2019-08-11 12:00:00 | 2019-08-10 12:00:00 | 0                          | 1      |                     |                        |
      | BEHAT Announcement2 | hero                |                                  | BEHAT Bird            | Link 1 - http://www.google.com |                     | 2019-12-10 12:00:00 | 0                          | 1      | Middle              | Visible                |
    When I am on "/highlights"
    Then I should see the link "BEHAT Announcement1"
      And I should see the link "BEHAT Announcement2"
    When I select "Hero Image" from "Featured Type"
      And I press the "Apply" button
    Then I should see the link "BEHAT Announcement2"
      And I should not see the link "BEHAT Announcement1"
    When I select "Highlighted Item" from "Featured Type"
      And I press the "Apply" button
    Then I should see the link "BEHAT Announcement1"
      And I should not see the link "BEHAT Announcement2"

  @api
  Scenario: All types of Featured nodes not promoted to frontpage should show in Highlights
    Given I am logged in as a user with the "content_approver" role
      And "image" content:
      | title        | field_alt_text               | field_image_upload     |
      | BEHAT Bird   | This is a bird.              | image;behat-bird.gif   |
      | BEHAT Rabbit | This is a picure of a rabbit | image;behat-rabbit.jpg |
      And "featured" content:
      | title                    | field_featured_type | field_teaser    | field_image_reference | field_url                     | published_at        | changed             | status | path                      | promote |
      | BEHAT Featured Highlight | highlighted_item    | This is a bird. | BEHAT Bird            | Link 1 - http://www.yahoo.com | 2019-08-11 12:00:00 | 2019-08-10 12:00:00 | 1      | /behat-featured-highlight | 1       |
      And "featured" content:
      | title               | field_featured_type | field_image_reference | field_url                      | field_title_visibility | published_at        | changed             | status | field_hero_position | path                  | promote |
      | BEHAT Featured Hero | hero                | BEHAT Rabbit          | Link 2 - http://www.google.com | visible                | 2019-08-11 12:01:00 | 2019-08-10 12:01:00 | 1      | Top                 | /behat-featured-hero  | 1       |
    When I am on "/highlights"
    Then I should not see the link "BEHAT Featured Highlight"
      And I should not see the link "BEHAT Featured Hero"
    When I am on the homepage
    Then I should see the link "BEHAT Featured Highlight"
      And I should see the text "BEHAT Featured Hero"
    When I visit "/behat-featured-highlight/edit"
      And I uncheck the box "Promoted to front page"
      And I press "Save and Publish"
      And I visit "/behat-featured-hero/edit"
      And I uncheck the box "Promoted to front page"
      And I press "Save and Publish"
      And I visit "/highlights"
    Then I should see "BEHAT Featured Highlight"
      And I should see "BEHAT Featured Hero"
    When I am on the homepage
    Then I should not see the link "BEHAT Featured Highlight"
      And I should not see "BEHAT Featured Hero"

  @api @javascript
  Scenario: Archive Promoted Highlights Not On Homepage
    Given "image" content:
      | title                   | field_alt_text                  | field_image_upload               |
      | BEHAT Bird Image        | This is a picure of a bird      | image;behat-bird.gif             |
      | BEHAT Rabbit Image      | This is a picure of a rabbit    | image;behat-rabbit.jpg           |
      | BEHAT Dog Image         | This is a picure of a dog       | image;behat-dog.jpeg             |
      | BEHAT Cat Image         | This is a picure of a cat       | image;behat-cat.png              |
      | BEHAT Cream Shiba Image | This is a picure of a puppy     | image;behat-test_shiba_puppy.jpg |
      | BEHAT Red Shiba Image   | This is a picure of a red shiba | image;behat-test_shiba_snow.jpg  |
      And "featured" content:
        | title                | field_featured_type | field_teaser           | field_image_reference   | field_url                         | promote | status | published_at | changed | created |
        | BEHAT Announcement 0 | highlighted_item    | This is a bird.        | BEHAT Bird Image        | Link 1 - http://www.google.com    | 1       | 1      | -1 day       | -1 day  | -1 day  |
        | BEHAT Announcement 1 | highlighted_item    | This is a rabbit.      | BEHAT Rabbit Image      | Link 1 - http://www.google.com    | 1       | 1      | -2 day       | -2 day  | -2 day  |
        | BEHAT Announcement 2 | highlighted_item    | This is a dog.         | BEHAT Dog Image         |                                   | 1       | 1      | -3 day       | -3 day  | -3 day  |
        | BEHAT Announcement 3 | highlighted_item    | This is a cat.         | BEHAT Cat Image         | Link 3 - http://www.accenture.com | 1       | 1      | -4 day       | -4 day  | -4 day  |
        | BEHAT Announcement 4 | highlighted_item    | This is a white shiba. | BEHAT Cream Shiba Image | Link 4 - http://www.youtube.com   | 1       | 1      | -5 day       | -5 day  | -5 day  |
        | BEHAT Announcement 5 | highlighted_item    | This is a red shiba.   | BEHAT Red Shiba Image   |                                   | 1       | 1      | -6 day       | -6 day  | -6 day  |
      And I am logged in as a user with the "content_approver" role
    When I am on "/admin/content/highlights"
      And I drag highlight "BEHAT Announcement 5" onto "BEHAT Announcement 0"
      And I wait 1 seconds
      And I drag highlight "BEHAT Announcement 4" onto "BEHAT Announcement 0"
      And I wait 1 seconds
      And I drag highlight "BEHAT Announcement 3" onto "BEHAT Announcement 0"
      And I wait 1 seconds
      And I drag highlight "BEHAT Announcement 2" onto "BEHAT Announcement 0"
      And I wait 1 seconds
      And I drag highlight "BEHAT Announcement 1" onto "BEHAT Announcement 0"
      And I wait 1 seconds
      And I press "edit-save-order"
      And I am on the homepage
    Then "BEHAT Announcement 5" should precede "BEHAT Announcement 4" for the query "//div[contains(@class, 'highlights-block_1')]//h3"
      And "BEHAT Announcement 4" should precede "BEHAT Announcement 3" for the query "//div[contains(@class, 'highlights-block_1')]//h3"
      And "BEHAT Announcement 3" should precede "BEHAT Announcement 2" for the query "//div[contains(@class, 'highlights-block_1')]//h3"
    When I visit "/highlights"
    Then I should see "BEHAT Announcement 1"
      And I should see "BEHAT Announcement 0"
      But I should not see "BEHAT Announcement 5"
      And I should not see "BEHAT Announcement 4"
      And I should not see "BEHAT Announcement 3"
      And I should not see "BEHAT Announcement 2"

  @api @javascript
  Scenario: Change Order of Highlights on Homepage Using Row Weights
    Given "image" content:
      | title                   | field_alt_text                  | field_image_upload               |
      | BEHAT Bird Image        | This is a picure of a bird      | image;behat-bird.gif             |
      | BEHAT Rabbit Image      | This is a picure of a rabbit    | image;behat-rabbit.jpg           |
      | BEHAT Dog Image         | This is a picure of a dog       | image;behat-dog.jpeg             |
      | BEHAT Cat Image         | This is a picure of a cat       | image;behat-cat.png              |
      | BEHAT Cream Shiba Image | This is a picure of a puppy     | image;behat-test_shiba_puppy.jpg |
      | BEHAT Red Shiba Image   | This is a picure of a red shiba | image;behat-test_shiba_snow.jpg  |
      And "featured" content:
      | title            | field_featured_type | field_teaser           | field_image_reference   | field_url                         | promote | status | published_at | changed | created |
      | BEHAT Featured 0 | highlighted_item    | This is a bird.        | BEHAT Bird Image        | Link 1 - http://www.google.com    | 1       | 1      | -1 day       | -1 day  | -1 day  |
      | BEHAT Featured 1 | highlighted_item    | This is a rabbit.      | BEHAT Rabbit Image      | Link 1 - http://www.google.com    | 1       | 1      | -2 day       | -2 day  | -2 day  |
      | BEHAT Featured 2 | highlighted_item    | This is a dog.         | BEHAT Dog Image         |                                   | 1       | 1      | -3 day       | -3 day  | -3 day  |
      | BEHAT Featured 3 | highlighted_item    | This is a cat.         | BEHAT Cat Image         | Link 3 - http://www.accenture.com | 1       | 1      | -4 day       | -4 day  | -4 day  |
      | BEHAT Featured 4 | highlighted_item    | This is a white shiba. | BEHAT Cream Shiba Image | Link 4 - http://www.youtube.com   | 1       | 1      | -5 day       | -5 day  | -5 day  |
      | BEHAT Featured 5 | highlighted_item    | This is a red shiba.   | BEHAT Red Shiba Image   |                                   | 1       | 1      | -6 day       | -6 day  | -6 day  |
      And I am logged in as a user with the "Authenticated user" role
    When I am on the homepage
    Then "BEHAT Featured 0" should precede "BEHAT Featured 1" for the query "//div[contains(@class, 'highlights-block_1')]//h3"
      And "BEHAT Featured 1" should precede "BEHAT Featured 2" for the query "//div[contains(@class, 'highlights-block_1')]//h3"
      And "BEHAT Featured 2" should precede "BEHAT Featured 3" for the query "//div[contains(@class, 'highlights-block_1')]//h3"
    When I am logged in as a user with the "content_approver" role
      And I visit "/admin/content/highlights"
      And I reload the page
      And I press "Show row weights"
      And I fill in "edit-draggableviews-0-weight" with "5"
      And I fill in "edit-draggableviews-1-weight" with "4"
      And I fill in "edit-draggableviews-2-weight" with "3"
      And I fill in "edit-draggableviews-3-weight" with "2"
      And I fill in "edit-draggableviews-4-weight" with "1"
      And I fill in "edit-draggableviews-5-weight" with "0"
      And I scroll to the top
      And I press "Save order"
      And I am logged in as a user with the "Authenticated user" role
      And I am on the homepage
      And I run drush "cr"
      And I reload the page
    Then "BEHAT Featured 5" should precede "BEHAT Featured 4" for the query "//div[contains(@class, 'highlights-block_1')]//h3"
      And "BEHAT Featured 4" should precede "BEHAT Featured 3" for the query "//div[contains(@class, 'highlights-block_1')]//h3"
      And "BEHAT Featured 3" should precede "BEHAT Featured 2" for the query "//div[contains(@class, 'highlights-block_1')]//h3"

  @api
  Scenario: Archive Promoted Featured Hero Images Not On Homepage
    Given "image" content:
      | title                   | field_alt_text                  | field_image_upload               |
      | BEHAT Bird Image        | This is a picure of a bird      | image;behat-bird.gif             |
      | BEHAT Rabbit Image      | This is a picure of a rabbit    | image;behat-rabbit.jpg           |
      | BEHAT Cream Shiba Image | This is a picure of a puppy     | image;behat-test_shiba_puppy.jpg |
      | BEHAT Red Shiba Image   | This is a picure of a red shiba | image;behat-test_shiba_snow.jpg  |
      And "featured" content:
        | title       | field_featured_type | field_image_reference   | field_url                      | published_at        | changed             | status | field_title_visibility | field_hero_position | promote |
        | BEHAT hero1 | hero                | BEHAT Rabbit Image      | Link 1 - http://www.yahoo.com  | 2019-12-10 12:00:00 | 2019-12-10 12:00:00 | 1      | visible                | Middle              | 1       |
        | BEHAT hero2 | hero                | BEHAT Bird Image        | Link 1 - http://www.google.com | 2019-11-16 12:00:00 | 2019-11-16 12:00:00 | 1      | visible                | Middle              | 1       |
        | BEHAT hero3 | hero                | BEHAT Cream Shiba Image | Link 1 - http://www.cnn.com    | 2019-12-10 12:00:00 | 2019-12-10 12:00:00 | 1      | visible                | Top                 | 1       |
        | BEHAT hero4 | hero                | BEHAT Red Shiba Image   | Link 1 - http://www.apple.com  | 2019-11-16 12:00:00 | 2019-11-16 12:00:00 | 1      | visible                | Top                 | 1       |
    When I am logged in as a user with the "Authenticated user" role
      And I am on the homepage
    Then I should see "BEHAT hero1"
      And I should see "BEHAT hero3"
    When I visit "/highlights"
    Then I should see "BEHAT hero2"
      And I should see "BEHAT hero4"
      But I should not see "BEHAT hero1"
      And I should not see "BEHAT hero3"

  @api
  Scenario: Unpublished Highlights And Heroes Do Not Appear
    Given "image" content:
      | title                   | field_alt_text                  | field_image_upload               |
      | BEHAT Bird Image        | This is a picure of a bird      | image;behat-bird.gif             |
      | BEHAT Rabbit Image      | This is a picure of a rabbit    | image;behat-rabbit.jpg           |
      | BEHAT Dog Image         | This is a picure of a dog       | image;behat-dog.jpeg             |
      | BEHAT Cat Image         | This is a picure of a cat       | image;behat-cat.png              |
      | BEHAT Cream Shiba Image | This is a picure of a puppy     | image;behat-test_shiba_puppy.jpg |
      | BEHAT Red Shiba Image   | This is a picure of a red shiba | image;behat-test_shiba_snow.jpg  |
      And "featured" content:
        | title                | field_featured_type | field_teaser           | field_image_reference   | field_url                         | promote | status |
        | BEHAT Announcement 0 | highlighted_item    | This is a bird.        | BEHAT Bird Image        | Link 1 - http://www.google.com    | 1       | 1      |
        | BEHAT Announcement 1 | highlighted_item    | This is a rabbit.      | BEHAT Rabbit Image      | Link 1 - http://www.google.com    | 1       | 0      |
        | BEHAT Announcement 2 | highlighted_item    | This is a dog.         | BEHAT Dog Image         |                                   | 1       | 1      |
        | BEHAT Announcement 3 | highlighted_item    | This is a cat.         | BEHAT Cat Image         | Link 3 - http://www.accenture.com | 1       | 1      |
        | BEHAT Announcement 4 | highlighted_item    | This is a white shiba. | BEHAT Cream Shiba Image | Link 4 - http://www.youtube.com   | 1       | 0      |
        | BEHAT Announcement 5 | highlighted_item    | This is a red shiba.   | BEHAT Red Shiba Image   |                                   | 1       | 1      |
      And "featured" content:
        | title       | field_featured_type | field_image_reference   | field_url                      | published_at        | changed             | status | field_title_visibility | field_hero_position | promote |
        | BEHAT hero1 | hero                | BEHAT Rabbit Image      | Link 1 - http://www.yahoo.com  | 2019-12-10 12:00:00 | 2019-12-10 12:00:00 | 1      | visible                | Middle              | 1       |
        | BEHAT hero2 | hero                | BEHAT Bird Image        | Link 1 - http://www.google.com | 2019-11-16 12:00:00 | 2019-11-16 12:00:00 | 0      | visible                | Middle              | 1       |
        | BEHAT hero3 | hero                | BEHAT Cream Shiba Image | Link 1 - http://www.cnn.com    | 2019-12-10 12:00:00 | 2019-12-10 12:00:00 | 1      | visible                | Top                 | 1       |
        | BEHAT hero4 | hero                | BEHAT Red Shiba Image   | Link 1 - http://www.apple.com  | 2019-11-16 12:00:00 | 2019-11-16 12:00:00 | 0      | visible                | Top                 | 1       |
    When I am logged in as a user with the "content_approver" role
      And I am on "/admin/content/highlights"
    Then I should not see "BEHAT Announcement 4"
      And I should not see "BEHAT Announcement 1"
    When I am on the homepage
    Then I should see "BEHAT hero3"
      And I should see "BEHAT Announcement 5"
      But I should not see "BEHAT Announcement 1"
      And I should not see "BEHAT Announcement 4"
      And I should not see "BEHAT hero2"
      And I should not see "BEHAT hero4"
    When I visit "/highlights"
    Then I should not see "BEHAT Announcement 1"
      And I should not see "BEHAT Announcement 4"
      And I should not see "BEHAT hero2"
      And I should not see "BEHAT hero4"

  @api @javascript
  Scenario: Twitter Feed Block
    Given I am logged in as a user with the "Authenticated user" role
    When I am on "/"
      And I wait 5 seconds
      And I scroll to the bottom
      And I switch to the iframe "twitter-widget-0"
    Then I should see the link "View more on Twitter"
    When I click "View more on Twitter"
    Then the link should open in a new tab
      And I wait 3 seconds
      And I should see the text "SEC Tweets"
      And I close the current window

  @api @javascript
  Scenario: Verify Featured Link Is Not Broken When The Maximum Characters Are Provided
    Given I am logged in as a user with the "content_approver" role
      And "image" content:
      | title        | field_alt_text               | field_image_upload     |
      | BEHAT Bird   | This is a bird.              | image;behat-bird.gif   |
      | BEHAT Rabbit | This is a picure of a rabbit | image;behat-rabbit.jpg |
      And "sec_article" content:
      | title                                                                                                                                                                                                                                                           | body                   | status |
      | A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy | This is a test article | 1      |
      And "featured" content:
      | title                                           | field_featured_type | field_teaser        | field_image_reference | published_at        | changed             | status | promote |
      | BEHAT DI-5372 Max Character                     | highlighted_item    | This is not a bird. | BEHAT Rabbit          |                     |                     | 1      | 1       |
      | BEHAT DI-5372 Archieved Highlight Max Character | highlighted_item    | This is not a fox   | BEHAT Bird            | 2019-08-11 12:00:00 | 2019-05-10 12:00:00 | 1      |         |
    When I visit "/admin/content"
      And I click "Edit" in the "BEHAT DI-5372 Max Character" row
      And I select the first autocomplete option for "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy" on the "Content/Link URL" field
      And I wait 1 seconds
      And I publish it
    When I visit "/"
    Then I should see the link "BEHAT DI-5372 Max Character"
    When I click "BEHAT DI-5372 Max Character"
    Then I should be on "/wonderful-serenity-has-taken-possession-my-entire-soul-these-sweet-mornings-spring-which-i-enjoy-my"
    When I visit "/admin/content"
      And I fill in "BEHAT DI-5372 Archieved Highlight Max Character" for "Title"
      And I press "Filter"
      And I click "Edit" in the "BEHAT DI-5372 Archieved Highlight Max Character" row
      And I select the first autocomplete option for "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy" on the "Content/Link URL" field
      And I wait 1 seconds
      And I publish it
    When I am logged in as a user with the "Authenticated user" role
      And I visit "/highlights"
    Then I should see the link "BEHAT DI-5372 Archieved Highlight Max Character"
    When I click "BEHAT DI-5372 Archieved Highlight Max Character"
    Then I should be on "/wonderful-serenity-has-taken-possession-my-entire-soul-these-sweet-mornings-spring-which-i-enjoy-my"
      And I should see the text "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy"

  @api @javascript
  Scenario: Verify System Message for Add And Remove Quicklinks
    Given "link" content:
      | title        | field_description_abstract | field_url                     | field_add_to_available_quicklink |
      | BEHAT Link 1 | This is a test             | BEHAT Link1 - http://test.com | 1                                |
    When I am logged in as a user with the "Authenticated user" role
      And I am on "/user/profile/quicklinks"
      And I select "Remove all QuickLinks" from "Reset My QuickLinks"
      And I press "Apply"
      And I wait 2 seconds
      And I fill in "Search QuickLinks" with "behat"
      And I click on the element with css selector "#edit-submit-available-quicklinks"
      And I click "Add to My QuickLinks"
    Then I should see the text "The selected QuickLink has been added."
    When I click "Remove from My QuickLinks"
    Then I should see the text "The selected QuickLink has been removed."
      And I should not see the link "Remove from My QuickLinks"

  @api
  Scenario: No <container> Tag On Homepage
    Given I am logged in as a user with the "Authenticated user" role
    When I am on "/"
    Then I should not see the html element "container" on the page

  @api @javascript
  Scenario: Users Should Not Share QuickLinks
    Given "link" content:
      | title        | field_description_abstract | field_url                 | field_add_to_available_quicklink |
      | BEHAT Link 1 | This is a test             | A Link1 - http://test.com | 1                                |
      | BEHAT Link 2 | This is a test             | A Link2 - http://test.com | 1                                |
      | BEHAT Link 3 | This is a test             | A Link3 - http://test.com | 1                                |
      | BEHAT Link 4 | This is a test             | A Link4 - http://test.com | 1                                |
      | BEHAT Link 5 | This is a test             | A Link5 - http://test.com | 1                                |
    When I am logged in as "john auth"
      And I am on "/"
      And I wait 1 seconds
      And I hover over the element "#quick-links"
      And I wait 1 seconds
      And I click "+ Edit"
    Then I should see the heading "Available QuickLinks"
      And I should see the heading "My QuickLinks"
    When I select "Remove all QuickLinks" from "Reset My QuickLinks"
      And I press "Apply"
      And I click "Add to My QuickLinks" in the "A Link1" row
    Then I should see the text "The selected QuickLink has been added."
    When I click "Add to My QuickLinks" in the "A Link2" row
    Then I should see the text "The selected QuickLink has been added."
    When I click "Add to My QuickLinks" in the "A Link3" row
    Then I should see the text "The selected QuickLink has been added."
    When I click "Add to My QuickLinks" in the "A Link4" row
    Then I should see the text "The selected QuickLink has been added."
    When I click "Add to My QuickLinks" in the "A Link5" row
    Then I should see the text "The selected QuickLink has been added."
      And I should see the text "A Link1" in the "myquicklinks" region
      And I should see the text "A Link2" in the "myquicklinks" region
      And I should see the text "A Link3" in the "myquicklinks" region
      And I should see the text "A Link4" in the "myquicklinks" region
      And I should see the text "A Link5" in the "myquicklinks" region
    When I am logged in as "jane auth"
      And I am on "/"
      And I wait 1 seconds
      And I hover over the element "#quick-links"
      And I wait 1 seconds
      And I click "+ Edit"
    Then I should see the heading "Available QuickLinks"
      And I should see the heading "My QuickLinks"
      And I should not see the text "A Link1" in the "myquicklinks" region
      And I should not see the text "A Link2" in the "myquicklinks" region
      And I should not see the text "A Link3" in the "myquicklinks" region
      And I should not see the text "A Link4" in the "myquicklinks" region
      And I should not see the text "A Link5" in the "myquicklinks" region

  @api @javascript
  Scenario: Archived Highlights Pagination
    Given "image" content:
      | title                   | field_alt_text                  | field_image_upload               |
      | BEHAT Bird Image        | This is a picure of a bird      | image;behat-bird.gif             |
      | BEHAT Rabbit Image      | This is a picure of a rabbit    | image;behat-rabbit.jpg           |
      | BEHAT Dog Image         | This is a picure of a dog       | image;behat-dog.jpeg             |
      | BEHAT Cat Image         | This is a picure of a cat       | image;behat-cat.png              |
      | BEHAT Cream Shiba Image | This is a picure of a puppy     | image;behat-test_shiba_puppy.jpg |
      | BEHAT Red Shiba Image   | This is a picure of a red shiba | image;behat-test_shiba_snow.jpg  |
      And "featured" content:
      | title      | field_featured_type | field_teaser           | field_image_reference   | field_url                         | promote | status |
      | BEHAT HL 0 | highlighted_item    | This is a bird.        | BEHAT Bird Image        | Link 1 - http://www.google.com    | 0       | 1      |
      | BEHAT HL 1 | highlighted_item    | This is a rabbit.      | BEHAT Rabbit Image      | Link 1 - http://www.google.com    | 0       | 1      |
      | BEHAT HL 2 | highlighted_item    | This is a dog.         | BEHAT Dog Image         |                                   | 0       | 1      |
      | BEHAT HL 3 | highlighted_item    | This is a cat.         | BEHAT Cat Image         | Link 3 - http://www.accenture.com | 0       | 1      |
      | BEHAT HL 4 | highlighted_item    | This is a white shiba. | BEHAT Cream Shiba Image | Link 4 - http://www.youtube.com   | 0       | 1      |
      | BEHAT HL 5 | highlighted_item    | This is a red shiba.   | BEHAT Red Shiba Image   |                                   | 0       | 1      |
      | BEHAT HL 6 | highlighted_item    | This is a red shiba.   | BEHAT Red Shiba Image   |                                   | 0       | 1      |
      | BEHAT HL 7 | highlighted_item    | This is a red shiba.   | BEHAT Red Shiba Image   |                                   | 0       | 1      |
      And "featured" content:
      | title       | field_featured_type | field_image_reference   | field_url                      | published_at | changed   | status | field_title_visibility | field_hero_position | promote |
      | BEHAT hero1 | hero                | BEHAT Rabbit Image      | Link 1 - http://www.yahoo.com  | -11 days     | -11 days  | 1      | visible                | Middle              | 0       |
      | BEHAT hero2 | hero                | BEHAT Bird Image        | Link 1 - http://www.google.com | -12 days     | -11 days  | 1      | visible                | Middle              | 0       |
      | BEHAT hero3 | hero                | BEHAT Cream Shiba Image | Link 1 - http://www.cnn.com    | -13 days     | -11 days  | 1      | visible                | Top                 | 0       |
      | BEHAT hero4 | hero                | BEHAT Red Shiba Image   | Link 1 - http://www.apple.com  | -14 days     | -11 days  | 1      | visible                | Top                 | 0       |
      | BEHAT hero5 | hero                | BEHAT Red Shiba Image   | Link 1 - http://www.apple.com  | -15 days     | -11 days  | 1      | visible                | Top                 | 0       |
      | BEHAT hero6 | hero                | BEHAT Red Shiba Image   | Link 1 - http://www.apple.com  | -2 months    | -2 months | 1      | visible                | Top                 | 0       |
    When I am logged in as a user with the "Authenticated user" role
      And I visit "/highlights"
    Then I should not see the link "Go to last page"
      And I select "5" from "Show"
    Then I should see the link "Go to page 2"
      And I should see the link "Go to last page"
      And I should see the link "Go to next page"
      And I should not see the link "BEHAT hero6"
    When I select "All" from "Show"
    Then I should not see the link "Go to next page"
      And I should not see the link "Go to last page"
      And I should see the link "BEHAT hero6"
