Feature: Admin Content
  As content creator
  I want to be able to search/filter/view created content, publish/unpublish/deleting multiple content records at a time
  So that I can save time from doing them individually

  Background:
    Given "top_level_group" terms:
      | name       |
      | group      |
      | sports     |
      | procedures |
      And "topic" terms:
        | name     |
        | fun      |
        | not fun  |
      And "form_topic" terms:
        | name           |
        | Altruists      |
        | Boondoggle     |
        | Man of War     |
        | Foreign Travel |
      And "office_division" terms:
        | name  |
        | omaha |
      And "group_club" terms:
        | name    |
        | testers |

  @api @javascript
  Scenario: Bulk Unpublish Content
    Given I am logged in as a user with the "administrator" role
      And "sec_article" content:
        | title                        | body      | field_source | field_top_level_group | field_topic | status | moderation_state |
        | DI-1687 Behat Test Article 1 | test body | test source  | sports                | fun         | 1      | published        |
      And "sec_alert" content:
        | title                  | body                     | status | moderation_state |
        | DI-1687 Active Alert 1 | This is an active alert. | 1      | published        |
      And "announcement" content:
        | title                        | field_short_title | body   | status | field_announcement_type | moderation_state |
        | DI-1687 Free Ice Cream Today | Free today        | Test 1 | 1      | Obituary                | published        |
      And "event" content:
        | title                               | field_short_title | body               | field_source | field_topic | field_top_level_group | status | moderation_state |
        | DI-1687 BEHAT Test Event - Training | Home Page Title 1 | This is an Event 1 | Minnie Mouse | fun         | sports                | 1      | published        |
      And "file" content:
        | title                     | field_description_abstract                          | field_retain_disposal_date | field_file_upload    | moderation_state | status |
        | DI-1687 BEHAT File Test 1 | This is a description and abstract about this file. | +1 day                     | file;behat-form1.pdf | published        | 1      |
      And "form" content:
        | body             | title                     | field_form_topic | field_form_number | status | moderation_state |
        | This is the body | DI-1687 BEHAT Test Form 1 | Altruists        | Test              | 1      | published        |
      And "library_item" content:
        | title                       | field_vendor | field_format | body                  | field_contact_for_questions | field_topic | field_top_level_group | status | moderation_state |
        | DI-1687 Bloomberg Service 1 | Bloomberg    | web-based    | Bloomberg description | John Smith                  | fun         | sports                | 1      | published        |
      And "operating_procedure" content:
        | title                  | field_release_number | field_publish_date | field_series | status | moderation_state |
        | DI-1687 BEHAT Test OP1 | OP 12345             | now                | 1            | 1      | published        |
      And "secr" content:
        | title                    | field_secr_number | field_publish_date | field_series | field_related_op       | status | moderation_state |
        | DI-1687 BEHAT Test SECR1 | R1-2              | now                | 1            | DI-1687 BEHAT Test OP1 | 1      | published        |
      And "video" content:
        | title                      | field_video_type | field_video_origin | field_video                                 | field_media_id | body        | field_transcript | status | moderation_state |
        | DI-1687 Behat Test Video 1 | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                | Body text 1 | Transcript 1     | 1      | published        |
      And "featured" content:
        | title                        | field_featured_type | field_teaser        | field_url                      | promote | status | moderation_state |
        | DI-1687 BEHAT Announcement 0 | highlighted_item    | This is not a bird. | Link 1 - http://www.google.com | 0       | 1      | published        |
      And "landing_page" content:
        | title                  | field_description_abstract | field_landing_page_subtype | field_top_level_group | status | moderation_state |
        | DI-1687 Landing Page 1 | Bloomberg                  | web-based                  | sports                | 1      | published        |
    When I visit "/admin/content"
      And I fill in "DI-1687" for "Title"
      And I press "Filter"
      And I wait for AJAX to finish
      And I click on the element with css selector ".views-table > thead:nth-child(1) > tr:nth-child(1) > th:nth-child(1) > input:nth-child(1)"
      And I wait for AJAX to finish
      And I select "Set Content as Unpublished" from "action"
      And I press "edit-submit"
      And I should see the text "Set Content as Unpublished was applied to 11 items"
      And I visit "/admin/content"
      And I fill in "DI-1687" for "edit-title"
      And I press "Filter"
      And I wait for AJAX to finish
      And I should see the text "Unpublished" in the "DI-1687 Behat Test Article 1" row
      And I should see the text "Unpublished" in the "DI-1687 Active Alert 1" row
      And I should see the text "Unpublished" in the "DI-1687 Free Ice Cream Today" row
      And I should see the text "Unpublished" in the "DI-1687 BEHAT Test Event - Training" row
      And I should not see the link "DI-1687 BEHAT File Test 1"
      And I should see the text "Unpublished" in the "DI-1687 Bloomberg Service 1" row
      And I should see the text "Unpublished" in the "DI-1687 BEHAT Test OP1" row
      And I should see the text "Unpublished" in the "DI-1687 BEHAT Test SECR1" row
      And I should see the text "Unpublished" in the "DI-1687 Behat Test Video 1" row
      And I should see the text "Unpublished" in the "DI-1687 BEHAT Announcement 0" row
      And I should see the text "Unpublished" in the "DI-1687 Landing Page 1" row
      And I click "Edit" in the "DI-1687 Behat Test Article 1" row
    Then I should see the text "Not published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 Active Alert 1" row
      And I should see the text "Not published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 Free Ice Cream Today" row
      And I should see the text "Not published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 BEHAT Test Event - Training" row
      And I should see the text "Not published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 BEHAT Test Form 1" row
      And I should see the text "Not published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 Bloomberg Service 1" row
      And I should see the text "Not published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 BEHAT Test OP1" row
      And I should see the text "Not published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 BEHAT Test SECR1" row
      And I should see the text "Not published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 Behat Test Video 1" row
      And I should see the text "Not published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 BEHAT Announcement 0" row
      And I should see the text "Not published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 Landing Page 1" row
      And I should see the text "Not published" in the "editmeta" region

  @api @javascript
  Scenario: Bulk Publish Content
    Given I am logged in as a user with the "administrator" role
      And "sec_article" content:
        | title                        | body      | field_source | field_top_level_group | field_topic | status | moderation_state |
        | DI-1687 Behat Test Article 1 | test body | test source  | sports                | fun         | 0      | draft            |
      And "sec_alert" content:
        | title                  | body                     | status | moderation_state |
        | DI-1687 Active Alert 1 | This is an active alert. | 0      | draft            |
      And "announcement" content:
        | title                        | field_short_title | body   | status | field_announcement_type | moderation_state |
        | DI-1687 Free Ice Cream Today | Free today        | Test 1 | 0      | Obituary                | draft            |
      And "event" content:
        | title                               | field_short_title | body               | field_source | field_topic | field_top_level_group | status | moderation_state |
        | DI-1687 BEHAT Test Event - Training | Home Page Title 1 | This is an Event 1 | Minnie Mouse | fun         | sports                | 0      | draft            |
      And "form" content:
        | body             | title                     | field_form_topic | field_form_number | status | moderation_state |
        | This is the body | DI-1687 BEHAT Test Form 1 | Altruists        | Test              | 0      | draft            |
      And "library_item" content:
        | title                       | field_vendor | field_format | body                  | field_contact_for_questions | field_topic | field_top_level_group | status | moderation_state |
        | DI-1687 Bloomberg Service 1 | Bloomberg    | web-based    | Bloomberg description | John Smith                  | fun         | sports                | 0      | draft            |
      And "operating_procedure" content:
        | title                  | field_release_number | field_publish_date | field_series | status | moderation_state |
        | DI-1687 BEHAT Test OP1 | OP 12345             | now                | 1            | 0      | draft            |
      And "secr" content:
        | title                    | field_secr_number | field_publish_date | field_series | field_related_op       | status | moderation_state |
        | DI-1687 BEHAT Test SECR1 | R1-2              | now                | 1            | DI-1687 BEHAT Test OP1 | 0      | draft            |
      And "video" content:
        | title                      | field_video_type | field_video_origin | field_video                                 | field_media_id | body        | field_transcript | status | moderation_state |
        | DI-1687 Behat Test Video 1 | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                | Body text 1 | Transcript 1     | 0      | draft            |
      And "featured" content:
        | title                        | field_featured_type | field_teaser        | field_url                      | promote | status | moderation_state |
        | DI-1687 BEHAT Announcement 0 | highlighted_item    | This is not a bird. | Link 1 - http://www.google.com | 0       | 0      | draft            |
      And "landing_page" content:
        | title                  | field_description_abstract | field_landing_page_subtype | field_top_level_group | status | moderation_state |
        | DI-1687 Landing Page 1 | Bloomberg                  | web-based                  | sports                | 0      | draft            |
    When I visit "/admin/content"
      And I fill in "DI-1687" for "Title"
      And I press "Filter"
      And I wait for AJAX to finish
      And I click on the element with css selector ".views-table > thead:nth-child(1) > tr:nth-child(1) > th:nth-child(1) > input:nth-child(1)"
      And I select "Set Content as Published" from "action"
      And I press "edit-submit"
      And I should see the text "Set Content as Published was applied to 11 items"
      And I visit "/admin/content"
      And I fill in "DI-1687" for "edit-title"
      And I press "Filter"
      And I wait for AJAX to finish
      And I should see the text "Published" in the "DI-1687 Behat Test Article 1" row
      And I should see the text "Published" in the "DI-1687 Active Alert 1" row
      And I should see the text "Published" in the "DI-1687 Free Ice Cream Today" row
      And I should see the text "Published" in the "DI-1687 BEHAT Test Event - Training" row
      And I should see the text "Published" in the "DI-1687 BEHAT Test Form 1" row
      And I should see the text "Published" in the "DI-1687 Bloomberg Service 1" row
      And I should see the text "Published" in the "DI-1687 BEHAT Test OP1" row
      And I should see the text "Published" in the "DI-1687 BEHAT Test SECR1" row
      And I should see the text "Published" in the "DI-1687 Behat Test Video 1" row
      And I should see the text "Published" in the "DI-1687 BEHAT Announcement 0" row
      And I should see the text "Published" in the "DI-1687 Landing Page 1" row
      And I click "Edit" in the "DI-1687 Behat Test Article 1" row
    Then I should see the text "Published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 Active Alert 1" row
      And I should see the text "Published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 Free Ice Cream Today" row
      And I should see the text "Published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 BEHAT Test Event - Training" row
      And I should see the text "Published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 BEHAT Test Form 1" row
      And I should see the text "Published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 Bloomberg Service 1" row
      And I should see the text "Published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 BEHAT Test OP1" row
      And I should see the text "Published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 BEHAT Test SECR1" row
      And I should see the text "Published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 Behat Test Video 1" row
      And I should see the text "Published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 BEHAT Announcement 0" row
      And I should see the text "Published" in the "editmeta" region
      And I visit "/admin/content"
      And I click "Edit" in the "DI-1687 Landing Page 1" row
      And I should see the text "Published" in the "editmeta" region

  @api @javascript
  Scenario: Bulk Delete Content
    Given I am logged in as a user with the "administrator" role
      And "sec_article" content:
        | title                        | body      | field_source | field_top_level_group | field_topic | status | moderation_state |
        | DI-1687 Behat Test Article 1 | test body | test source  | sports                | fun         | 1      | published        |
      And "sec_alert" content:
        | title                  | body                     | status | moderation_state |
        | DI-1687 Active Alert 1 | This is an active alert. | 0      | draft            |
      And "announcement" content:
        | title                        | field_short_title | body   | status | field_announcement_type | moderation_state |
        | DI-1687 Free Ice Cream Today | Free today        | Test 1 | 1      | Obituary                | published        |
      And "event" content:
        | title                               | field_short_title | body               | field_source | field_topic | field_top_level_group | status | moderation_state |
        | DI-1687 BEHAT Test Event - Training | Home Page Title 1 | This is an Event 1 | Minnie Mouse | fun         | sports                | 1      | published        |
      And "form" content:
        | body             | title                     | field_form_topic | field_form_number | status | moderation_state |
        | This is the body | DI-1687 BEHAT Test Form 1 | Altruists        | Test              | 0      | draft            |
      And "image" content:
        | title                      | field_alt_text             | field_image_upload   | status | moderation_state |
        | DI-1687 BEHAT Image Test 1 | This is a picure of a bird | image;behat-bird.gif | 0      | draft            |
      And "library_item" content:
        | title                       | field_vendor | field_format | body                  | field_contact_for_questions | field_topic | field_top_level_group | status | moderation_state |
        | DI-1687 Bloomberg Service 1 | Bloomberg    | web-based    | Bloomberg description | John Smith                  | fun         | sports                | 1      | published        |
      And "link" content:
        | title                              | field_description_abstract | field_url                        | status | moderation_state |
        | DI-1687 Behat Email Contact Link 1 | Mailto Link Description    | Click Me - mailto:behat@test.com | 0      | draft            |
      And "operating_procedure" content:
        | title                  | field_release_number | field_publish_date | field_series | status | field_link_reference               | moderation_state |
        | DI-1687 BEHAT Test OP1 | OP 12345             | now                | 1            | 0      | DI-1687 Behat Email Contact Link 1 | draft            |
      And "secr" content:
        | title                    | field_secr_number | field_publish_date | field_series | field_related_op       | status | moderation_state |
        | DI-1687 BEHAT Test SECR1 | R1-2              | now                | 1            | DI-1687 BEHAT Test OP1 | 1      | published        |
      And "video" content:
        | title                      | field_video_type | field_video_origin | field_video                                 | field_media_id | body        | field_transcript | status | moderation_state |
        | DI-1687 Behat Test Video 1 | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                | Body text 1 | Transcript 1     | 0      | draft            |
      And "featured" content:
        | title                        | field_featured_type | field_teaser        | field_image_reference      | field_url                      | promote | status | moderation_state |
        | DI-1687 BEHAT Announcement 0 | highlighted_item    | This is not a bird. | DI-1687 BEHAT Image Test 1 | Link 1 - http://www.google.com | 0       | 0      | draft            |
      And "landing_page" content:
        | title                  | field_description_abstract | field_landing_page_subtype | field_top_level_group | status | moderation_state |
        | DI-1687 Landing Page 1 | Bloomberg                  | web-based                  | sports                | 1      | published        |

    When I visit "/admin/content"
      And I fill in "DI-1687" for "Title"
      And I press "Filter"
      And I wait for AJAX to finish
      And I click on the element with css selector ".views-table > thead:nth-child(1) > tr:nth-child(1) > th:nth-child(1) > input:nth-child(1)"
      And I select "Delete content" from "action"
      And I press "edit-submit"
      And I should see the text "Are you sure you want to delete these content items?"
      And I should see the text "This action cannot be undone"
      And I press "edit-submit"
      And I should see the text "Deleted 13 content items."
      And I visit "/admin/content"
      And I fill in "DI-1687" for "edit-title"
      And I press "Filter"
      And I wait for AJAX to finish
    Then I should not see "DI-1687 Behat Test Article 1"
      And I should not see "DI-1687 Active Alert 1"
      And I should not see "DI-1687 Free Ice Cream Today"
      And I should not see "DI-1687 BEHAT Test Event - Training"
      And I should not see "DI-1687 BEHAT Test Form 1"
      And I should not see "DI-1687 BEHAT Image Test 1"
      And I should not see "DI-1687 Bloomberg Service 1"
      And I should not see "DI-1687 Behat Email Contact Link 1"
      And I should not see "DI-1687 BEHAT Test OP1"
      And I should not see "DI-1687 BEHAT Test SECR1"
      And I should not see "DI-1687 Behat Test Video 1"
      And I should not see "DI-1687 BEHAT Announcement 0"
      And I should not see "DI-1687 Landing Page 1"

  @api
  Scenario: Filter Content For Expiration/Review Date
    Given I am logged in as a user with the "administrator" role
      And "sec_article" content:
        | title                | body      | field_source | field_top_level_group | field_topic | status | moderation_state | field_retain_disposal_date |
        | Behat Test Article 1 | test body | test source  | sports                | fun         | 0      | draft            | 2023-09-11                 |
      And "announcement" content:
        | title                | field_short_title | body   | status | field_announcement_type | moderation_state | field_retain_disposal_date |
        | Free Ice Cream Today | Free today        | Test 1 | 1      | Obituary                | published        | 2023-08-12                 |
      And "event" content:
        | title                       | field_short_title | body               | field_source | field_topic | field_top_level_group | status | moderation_state | field_retain_disposal_date |
        | BEHAT Test Event - Training | Home Page Title 1 | This is an Event 1 | Minnie Mouse | fun         | sports                | 1      | published        | 2023-07-05                 |
    When I visit "/admin/content"
      And I fill in "08/02/2023" for "Expiration/Review Start Date"
      And I fill in "08/30/2023" for "Expiration/Review End Date"
      And I press "Filter"
    Then I should see the link "Free Ice Cream Today"
      And I should not see the link "Behat Test Article 1"
      And I should not see the link "BEHAT Test Event - Training"
      And I should see the text "08/12/2023" in the "Free Ice Cream Today" row
    When I press "Reset"
      And I fill in "09/02/2023" for "Expiration/Review Start Date"
      And I select "Unpublished" from "Published status"
      And I press "Filter"
    Then I should see the link "Behat Test Article 1"
      And I should not see the link "Free Ice Cream Today"
      And I should not see the link "BEHAT Test Event - Training"
      And I should see the text "09/11/2023" in the "Behat Test Article 1" row
      And I should see the text "Unpublished" in the "Behat Test Article 1" row
    When I press "Reset"
      And I fill in "07/30/2023" for "Expiration/Review End Date"
      And I press "Filter"
    Then I should see the link "BEHAT Test Event - Training"
      And I should not see the link "Free Ice Cream Today"
      And I should not see the link "Behat Test Article 1"
      And I should see the text "07/05/2023" in the "BEHAT Test Event - Training" row

  @api @javascript
  Scenario: UI Content CSV Export With Division/Office Filtering
    Given "announcement" content:
      | title                | field_short_title | body   | status | field_announcement_type | moderation_state | field_division_office | field_group_club |
      | Free Ice Cream Today | Free today        | Test 1 | 1      | Obituary                | published        | omaha                 | testers          |
      And "event" content:
        | title                       | field_short_title | body               | field_source | field_topic | field_top_level_group | status | moderation_state | field_division_office | field_group_club |
        | BEHAT Test Event - Training | Home Page Title 1 | This is an Event 1 | Minnie Mouse | fun         | sports                | 1      | published        | omaha                 |                  |
        | BEHAT Test Event - General  | Home Page Title 2 | This is an Event 2 | Minnie Mouse | fun         | sports                | 1      | published        |                       | testers          |
    When I am logged in as a user with the "Content Creator" role
      And I am on "/admin/content"
      And I select "omaha" from "Division/Office"
      And I press "Filter"
    Then I should see the link "Free Ice Cream Today"
      And I should see the link "BEHAT Test Event - Training"
      And I should not see the link "BEHAT Test Event - General"
    When I click "Download CSV"
      And I wait 2 seconds
    Then I should see the text "Export complete. Download the file here if file is not automatically downloaded."
      And I should see the link "here"

  @api
  Scenario: Status Code - Content CSV Export With Group/Club Filtering
    Given "announcement" content:
      | title                | field_short_title | body   | status | field_announcement_type | moderation_state | field_division_office | field_group_club |
      | Free Ice Cream Today | Free today        | Test 1 | 1      | Obituary                | published        |                       | testers          |
      And "event" content:
        | title                       | field_short_title | body               | field_source | field_topic | field_top_level_group | status | moderation_state | field_division_office | field_group_club |
        | BEHAT Test Event - Training | Home Page Title 1 | This is an Event 1 | Minnie Mouse | fun         | sports                | 1      | published        |                       |                  |
        | BEHAT Test Event - General  | Home Page Title 2 | This is an Event 2 | Minnie Mouse | fun         | sports                | 1      | published        | omaha                 | testers          |
    When I am logged in as a user with the "Content Approver" role
    When I am on "/admin/content"
      And I select "testers" from "Group/Club"
      And I press "Filter"
    Then I should see the link "Free Ice Cream Today"
      And I should see the link "BEHAT Test Event - General"
      And I should not see the link "BEHAT Test Event - Training"
    When I click "Download CSV"
    Then the response status code should not be 500
      And the response status code should be 200
