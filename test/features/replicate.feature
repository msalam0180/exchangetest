Feature: Replicate Contents
  As a content approver user
  I want to be able to replicate content
  So that I can leverage existing content to create similar content

  Background:
  Given users:
    | name               | mail               | status | roles           | uid   |
    | replicating_author | replicate@test.com | 1      | administrator   | 77777 |
    | original_author    | original@test.com  | 1      | content_creator | 99999 |
    And "top_level_group" terms:
      | name       |
      | group      |
      | sports     |
      | procedures |
    And "topic" terms:
      | name    |
      | fun     |
      | not fun |
    And I create "paragraph" of type "paragraph_session":
      | KEY | field_location | field_start_date | field_end_date | type              |
      | 100 | Texas          | +3 day           | +3 day         | paragraph_session |
      | 101 | Michigan       | +1 day           | +1 day +1 hour | paragraph_session |
    And "form_topic" terms:
      | name           |
      | Altruists      |
      | Boondoggle     |
      | Man of War     |
      | Foreign Travel |
    And "timezone" terms:
      | name    | field_abbreviation |
      | Eastern | ET                 |

@api @javascript
Scenario: Replicate Article Content
  Given "sec_article" content:
    | title                        | body      | field_source | field_top_level_group | field_topic | status | moderation_state | nid     | field_comments | field_enable_likes | field_comment_moderator | uid   |
    | DI-3265 Behat Test Article 1 | test body | test source  | sports                | fun         | 1      | published        | 9876501 | 2              | 1                  | john@email.com          | 99999 |
    And I am logged in as "replicating_author"
  When I visit "/node/9876501/edit"
  Then Radio button with id "edit-field-comments-0-status-2" should be checked
    And the "Enable Likes" checkbox should be checked
    And I should see the text "original_author" in the "editmetaauthor" region
  When I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876501?"
    And I fill in "edit-new-label-en" with "DI-3265 Behat Test Article 2"
    And I press "Replicate"
  Then I should see the heading "Edit Article DI-3265 Behat Test Article 2"
    And I should see the text "node (9876501) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
    And the "input" element with ID "edit-field-comment-moderator-0-value" should not be set
    And Radio button with id "edit-field-comments-0-status-1" should be checked
    And the "Enable Likes" checkbox should not be checked
    And I should see the "Save and Create New Draft" button
  When I press "Save and Create New Draft"
  Then I should see the heading "DI-3265 Behat Test Article 2"
    And I should see the text "test body"
    And I should see the text "test source"
    But I should not see the text "DI-3265 Behat Test Article 1"

@api @javascript
Scenario: Replicate Alert Content
  Given "sec_alert" content:
    | title                  | body                     | status | moderation_state | nid     | field_alert_type | uid   |
    | DI-3265 Active Alert 1 | This is an active alert. | 1      | published        | 9876526 | critical         | 99999 |
    And I am logged in as "replicating_author"
  When I visit "/node/9876526/edit"
  Then I should see the text "original_author" in the "editmetaauthor" region
  When I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876526?"
    And I fill in "edit-new-label-en" with "DI-3265 Active Alert 2"
    And I press "Replicate"
  Then I should see the heading "Edit Site Alert DI-3265 Active Alert 2"
    And I should see the text "node (9876526) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
    And I should see the "Save and Create New Draft" button
    And I press "Save and Create New Draft"
  Then I should see the heading "DI-3265 Active Alert 2"
    And I should see the text "Alert Type"
    And I should see the link "critical"
    And I should see the text "This is an active alert"
    But I should not see the text "DI-3265 Active Alert 1"

@api @javascript
Scenario: Replicate Announcement Content
  Given "announcement" content:
    | title                        | field_to             | field_from | field_short_title | body   |  status | field_announcement_type | moderation_state | nid     | field_source  | field_topic | field_top_level_group | field_date | field_comments | field_enable_likes | field_comment_moderator | uid   |
    | DI-3265 Free Ice Cream Today | Drupal Support Staff | Chairman   | Free today        | Test 1 |  1      | Obituary                | published        | 9876551 | Ben & Jerry's | fun         | sports                | 2019-05-27 | 2              | 1                  | john@email.com          | 99999 |
    And I am logged in as "replicating_author"
  When I visit "node/9876551/edit"
  Then Radio button with id "edit-field-comments-0-status-2" should be checked
    And the "Enable Likes" checkbox should be checked
    And I should see the text "original_author" in the "editmetaauthor" region
  When I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876551?"
    And I fill in "edit-new-label-en" with "DI-3265 Free Ice Cream This Hot Afternoon"
    And I press "Replicate"
  Then I should see the heading "Edit Announcement DI-3265 Free Ice Cream This Hot Afternoon"
    And I should see the text "node (9876551) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
    And the "input" element with ID "edit-field-comment-moderator-0-value" should not be set
    And Radio button with id "edit-field-comments-0-status-1" should be checked
    And the "Enable Likes" checkbox should not be checked
    And I should see the "Save and Create New Draft" button
  When I press "Save and Create New Draft"
  Then I should see the heading "DI-3265 Free Ice Cream This Hot Afternoon"
    And I should see the text "Drupal Support Staff"
    And I should see the text "Chairman"
    And I should see the text "Test 1"
    And I should see the text "Ben & Jerry's"
    And I should see the heading "DI-3265 Free Ice Cream This Hot Afternoon"
    But I should not see the text "DI-3265 Free Ice Cream Today"

@api @javascript
Scenario: Replicate Event Content
  Given I create "node" of type "event":
    | title                               | field_short_title | body               | field_source | field_topic | field_top_level_group | status | field_session | moderation_state | nid     | field_event_type | field_timezone_select | field_comments | field_enable_likes | field_comment_moderator | uid   |
    | DI-3265 BEHAT Test Event - Training | Home Page Title 1 | This is an Event 1 | Minnie Mouse | fun         | sports                | 1      | 100           | published        | 9876516 | Training         | Eastern               | 2              | 1                  | john@email.com          | 99999 |
    And I am logged in as "replicating_author"
  When I visit "node/9876516/edit"
  Then Radio button with id "edit-field-comments-0-status-2" should be checked
    And the "Enable Likes" checkbox should be checked
    And I should see the text "original_author" in the "editmetaauthor" region
  When I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876516?"
    And I fill in "edit-new-label-en" with "DI-3265 BEHAT Test Event - Drupal Training"
    And I press "Replicate"
  Then I should see the heading "Edit Event DI-3265 BEHAT Test Event - Drupal Training"
    And I should see the text "node (9876516) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
    And the "input" element with ID "edit-field-comment-moderator-0-value" should not be set
    And Radio button with id "edit-field-comments-0-status-1" should be checked
    And the "Enable Likes" checkbox should not be checked
    And I fill in "+6 days 03:45:00 PM" in the "1" dynamic event start date
    And I fill in "+6 days 04:45:00 PM" in the "1" dynamic event end date
    And I scroll to the bottom
    And I should see the "Save and Create New Draft" button
    And I press "Save and Create New Draft"
  Then I should see the heading "DI-3265 BEHAT Test Event - Drupal Training"
    And I should see the text "Texas"
    And I should see the text "This is an Event 1"
    And I should see the text "Minnie Mouse"
    And I should see the text "3:45 pm – 4:45 pm ET"
    But I should not see the text "DI-3265 BEHAT Test Event - Training"
  When I visit "/admin/content"
    And I fill in "Drupal Training" for "Title"
    And I press "Filter"
    And I wait for AJAX to finish
    And I press the "List additional actions" button
    And I click "Set to Published" in the "DI-3265 BEHAT Test Event - Drupal Training" row
    And I am logged in as a user with the "Authenticated user" role
    And I visit "/events"
  Then I should see "DI-3265 BEHAT Test Event - Drupal Training"
    And I should see "DI-3265 BEHAT Test Event - Training"

@api @javascript
Scenario: Replicate Form Content
  Given "form" content:
    | body             | title                     | field_form_topic | field_form_number | status | moderation_state | nid     | field_source | field_topic | field_top_level_group | field_comments | field_enable_likes | field_comment_moderator | uid   |
    | This is the body | DI-3265 BEHAT Test Form 1 | Altruists        | T-06122019        | 1      | published        | 9876521 | for testing  | fun         | sports                | 2              | 1                  | john@email.com          | 99999 |
    And I am logged in as "replicating_author"
  When I visit "node/9876521/edit"
  Then Radio button with id "edit-field-comments-0-status-2" should be checked
    And the "Enable Likes" checkbox should be checked
    And I should see the text "original_author" in the "editmetaauthor" region
  When I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876521?"
    And I fill in "edit-new-label-en" with "DI-3265 BEHAT Test Form 2"
    And I press "Replicate"
  Then I should see the heading "Edit Form DI-3265 BEHAT Test Form 2"
    And I should see the text "node (9876521) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
    And the "input" element with ID "edit-field-comment-moderator-0-value" should not be set
    And Radio button with id "edit-field-comments-0-status-1" should be checked
    And the "Enable Likes" checkbox should not be checked
    And I should see the "Save and Create New Draft" button
  When I press "Save and Create New Draft"
  Then I should see the heading "DI-3265 BEHAT Test Form 2"
    And I should see the text "T-06122019"
    And I should see the text "This is the body"
    And I should see the text "for testing"
    But I should not see the text "DI-3265 BEHAT Test Form 1"

@api @javascript
Scenario: Replicate Library Item Content
  Given "library_item" content:
    | title                       | field_vendor | field_format | body                  | field_contact_for_questions | field_topic | field_top_level_group | status | moderation_state | nid     | field_how_to_access | field_comments | field_enable_likes | field_comment_moderator | uid   |
    | DI-3265 Bloomberg Service 1 | Bloomberg NY | web-based    | Bloomberg description | John Smith                  | fun         | sports                | 1      | published        | 9876526 | sharepoint          | 2              | 1                  | john@email.com          | 99999 |
    And I am logged in as "replicating_author"
  When I visit "node/9876526/edit"
  Then Radio button with id "edit-field-comments-0-status-2" should be checked
    And the "Enable Likes" checkbox should be checked
    And I should see the text "original_author" in the "editmetaauthor" region
  When I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876526?"
    And I fill in "edit-new-label-en" with "DI-3265 Bloomberg Service 2"
    And I press "Replicate"
  Then I should see the heading "Edit Library Item DI-3265 Bloomberg Service 2"
    And I should see the text "node (9876526) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
    And the "input" element with ID "edit-field-comment-moderator-0-value" should not be set
    And Radio button with id "edit-field-comments-0-status-1" should be checked
    And the "Enable Likes" checkbox should not be checked
    And I should see the "Save and Create New Draft" button
  When I press "Save and Create New Draft"
  Then I should see the heading "DI-3265 Bloomberg Service 2"
    And I should see the text "Bloomberg NY"
    And I should see the text "web-based"
    And I should see the text "Bloomberg description"
    And I should see the text "sharepoint"
    And I should see the text "John Smith"
    But I should not see the text "DI-3265 Bloomberg Service 1"

@api @javascript
Scenario: Replicate Image Content
  Given "image" content:
    | title                      |  field_image_upload   | status | moderation_state | field_caption                  | nid     | uid   |
    | DI-3265 BEHAT Image Test 1 |  image;behat-bird.gif | 1      | published        | Bird is either yellow or green | 9876531 | 99999 |
    And I am logged in as "replicating_author"
  When I visit "/node/9876531/edit"
  Then I should see the text "original_author" in the "editmetaauthor" region
  When I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876531?"
    And I fill in "edit-new-label-en" with "DI-3265 BEHAT Image Test 2"
    And I press "Replicate"
  Then I should see the heading "Edit Image DI-3265 BEHAT Image Test 2"
    And I should see the text "node (9876531) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
  When I press "Save"
  Then I should see the heading "DI-3265 BEHAT Image Test 2"
    # And the image src in the "image" region should match the Drupal url "/files/exchange/images/di-3265-behat-image-test-2.jpg"
    And I should see the "img" element with the "alt" attribute set to "Behat test image" in the "image" region
    And I should see the text "Bird is either yellow or green"
    But I should not see the text "DI-3265 BEHAT Image Test 1"

@api @javascript
Scenario: Replicate Link Content
  Given "link" content:
    | title                              | field_description_abstract | field_url                        | status | moderation_state | nid     | uid   |
    | DI-3265 Behat Email Contact Link 1 | Mailto Link Description    | Click Me - mailto:behat@test.com | 1      | published        | 9876536 | 99999 |
    And I am logged in as "replicating_author"
  When I visit "/node/9876536/edit"
  Then I should see the text "original_author" in the "editmetaauthor" region
    And I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876536?"
    And I fill in "edit-new-label-en" with "DI-3265 Behat Email Contact Link 2"
  When I press "Replicate"
  Then I should see the heading "Edit Link DI-3265 Behat Email Contact Link 2"
    And I should see the text "node (9876536) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
  When I press "Save"
  Then I should see the heading "DI-3265 Behat Email Contact Link 2"
    And I should see the link "Click Me"
    And the hyperlink "Click Me" should match the Drupal url "mailto:behat@test.com"
    But I should not see the text "DI-3265 Behat Email Contact Link 1"

@api @javascript
Scenario: Replicate Video Content
  Given "video" content:
    | title                 | field_video_type | field_video_origin | field_video                                 | status | body   | field_topic | field_transcript | moderation_state | nid     | field_top_level_group | field_comments | field_enable_likes | field_comment_moderator | uid   |
    | DI-3265 Behat Video 1 | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc | 1      | Drama  | fun         | mango            | published        | 9876541 | sports                | 2              | 1                  | John@email.com          | 99999 |
    And I am logged in as "replicating_author"
  When I visit "node/9876541/edit"
  Then Radio button with id "edit-field-comments-0-status-2" should be checked
    And the "Enable Likes" checkbox should be checked
    And I should see the text "original_author" in the "editmetaauthor" region
  When I visit "/admin/content"
    And I fill in "DI-3265" for "Title"
    And I press "Filter"
    And I wait for AJAX to finish
    And I click "Edit" in the "DI-3265 Behat Video 1" row
    And I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876541?"
    And I fill in "edit-new-label-en" with "DI-3265 Behat Video 2"
    And I press "Replicate"
  Then I should see the heading "Edit Video DI-3265 Behat Video 2"
    And I should see the text "node (9876541) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
    And the "input" element with ID "edit-field-comment-moderator-0-value" should not be set
    And Radio button with id "edit-field-comments-0-status-1" should be checked
    And the "Enable Likes" checkbox should not be checked
    And I should see the "Save and Create New Draft" button
  When I publish it
  Then I should see the heading "DI-3265 Behat Video 2"
    And I should see the text "Drama"
    And I click the "#accordion-transcript" element
    And I wait 2 seconds
    And I should see the text "mango"
    But I should not see the text "DI-3265 Behat Video 1"

@api @javascript
Scenario: Replicate Featured Content
  Given "image" content:
    | title                      | field_image_upload  | status | moderation_state | field_caption        |
    | DI-3265 BEHAT Image Test 1 | image;behat-cat.png | 1      | published        | The cat is not black |
    And "featured" content:
      | title                    | field_featured_type | field_teaser        | field_image_reference      | field_url                      | promote | status | moderation_state | nid     | uid   |
      | DI-3265 BEHAT Featured 1 | highlighted_item    | This is not a bird. | DI-3265 BEHAT Image Test 1 | Link 1 - http://www.google.com | 0       | 1      | published        | 9876546 | 99999 |
    And I am logged in as "replicating_author"
  When I visit "node/9876546/edit"
  Then I should see the text "original_author" in the "editmetaauthor" region
  When I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876546?"
    And I fill in "edit-new-label-en" with "DI-3265 BEHAT Featured 2"
    And I press "Replicate"
  Then I should see the heading "Edit Featured DI-3265 BEHAT Featured 2"
    And I should see the text "node (9876546) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
    And I should see the "Save and Create New Draft" button
  When I publish it
  Then I should see the heading "DI-3265 BEHAT Featured 2"
    And I should see the text "Highlighted Item"
    And I should see the text "This is not a bird."
    And I should see the link "Link 1"
    And the hyperlink "Link 1" should match the Drupal url "http://www.google.com"
    And I should see the "img" element with the "alt" attribute set to "Behat test image" in the "image" region
    But I should not see the text "DI-3265 BEHAT Featured 1"

@api @javascript
Scenario: Replicate Landing Page Content
  Given "landing_page" content:
    | title                  | field_description_abstract | field_landing_page_subtype | field_top_level_group | status | moderation_state | nid     | field_center_2_box | field_left_1_box | field_right_2_box | field_comments | field_enable_likes | field_comment_moderator | uid   |
    | DI-3265 Landing Page 1 | Bloomberg                  | Audience                   | sports                | 1      | published        | 9876551 | center field       | left field       | right field       | 2              | 1                  | John@email.com          | 99999 |
    And I am logged in as "replicating_author"
  When I visit "node/9876551/edit"
  Then Radio button with id "edit-field-comments-0-status-2" should be checked
    And the "Enable Likes" checkbox should be checked
    And I should see the text "original_author" in the "editmetaauthor" region
  When I click "Replicate"
    And I should see the heading "Are you sure you want to replicate node entity id 9876551?"
    And I fill in "edit-new-label-en" with "DI-3265 Landing Page 2"
    And I press "Replicate"
  Then I should see the heading "Edit Landing Page DI-3265 Landing Page 2"
    And I should see the text "node (9876551) has been replicated to id"
    And I should see the text "Not published" in the "editmeta" region
    # The author field should be null (not populated with the original author value)
    And I should not see the text "original_author" in the "editmetaauthor" region
    # The author field should be populated with the current user value when the node is saved
    And I should see the text "replicating_author" in the "editmetaauthor" region
    # The "Publish On" value should not be set before the node is first published
    And The "input" element with ID "edit-published-at-0-value-date" should not be set
    And the "input" element with ID "edit-field-comment-moderator-0-value" should not be set
    And Radio button with id "edit-field-comments-0-status-1" should be checked
    And the "Enable Likes" checkbox should not be checked
    And I should see the "Save and Create New Draft" button
  When I publish it
  Then I should see the heading "DI-3265 Landing Page 2"
    And I should see the text "left field"
    And I should see the text "center field"
    And I should see the text "right field"
    But I should not see the text "DI-3265 Landing Page 1"
