Feature: WDIO View Announcement Content
As a visitor to the Exchange
I want to be able to view announcements
So that I can be kept up to date on the latest important content on the Exchange

Background:

  Given "audiences" terms:
    | name     |
    | insiders |
    And "topic" terms:
      | name |
      | wdio |
    And "office_division" terms:
      | name |
      | enf  |
      | dera |
    And "group_club" terms:
      | name   |
      | poker  |
      | soccer |
    And "top_level_group" terms:
      | name      |
      | top-shelf |
      | sports    |
      | sec.gov   |

@api @javascript @ui @wdio
Scenario: Memorandum With Image Embed
  Given "image" content:
    | title            | field_alt_text              | field_image_upload   |
    | Dirty Bird Image | This is a picture of a bird | image;behat-bird.gif |
    And "announcement" content:
      | title                     | field_short_title         | published_at | status | field_announcement_type | changed             | field_date | field_source | field_topic | field_top_level_group | moderation_state | nid     | field_to    | field_from | field_override_modified_date |
      | WDIO Memo With Image Test | wdio memo with image test | now          | 1      | Memorandum              | 2032-03-01T13:00:00 | 2032-02-28 | open source  | wdio        | top-shelf             | published        | 1212022 | Drupal Team | Dirty Bird | 2032-02-29T13:00:05          |
  When I am logged in as a user with the "content_approver" role
    And I am on "/node/1212022/edit"
    And I scroll "#edit-body-wrapper" into view
    And I type "see me play with used tennis ball" in the "Body" WYSIWYG editor
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Dirty Bird Image" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I publish it
  Then I take a screenshot using "announcements.feature" file with "@memo_image" tag

@api @javascript @ui @wdio
Scenario: Obituary With Image Embed
  Given "image" content:
    | title            | field_alt_text              | field_image_upload   |
    | Dirty Bird Image | This is a picture of a bird | image;behat-bird.gif |
    And "announcement" content:
      | title                         | field_short_title         | published_at | status | field_announcement_type | changed             | field_date | field_source | field_topic | field_top_level_group | moderation_state | nid     | field_to    | field_from | field_override_modified_date |
      | WDIO Obituary With Image Test | wdio obit with image test | now          | 1      | Obituary                | 2032-03-01T13:00:00 | 2032-02-28 | open source  | wdio        | top-shelf             | published        | 1212022 | Drupal Team | Dirty Bird | 2032-02-29T13:00:05          |
  When I am logged in as a user with the "content_approver" role
    And I am on "/node/1212022/edit"
    And I scroll "#edit-body-wrapper" into view
    And I type "see me play with used tennis ball" in the "Body" WYSIWYG editor
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Dirty Bird Image" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I publish it
  Then I take a screenshot using "announcements.feature" file with "@obit_image" tag

@api @javascript @ui @wdio
Scenario: Detail With Image Embed
  Given "image" content:
    | title            | field_alt_text              | field_image_upload   |
    | Dirty Bird Image | This is a picture of a bird | image;behat-bird.gif |
    And "announcement" content:
      | title                       | field_short_title           | published_at | status | field_announcement_type | changed             | field_source | field_topic | field_top_level_group | moderation_state | nid     | field_override_modified_date |
      | WDIO Detail With Image Test | wdio detail with image test | now          | 1      | Detail                  | 2032-03-01T13:00:00 | open source  | wdio        | top-shelf             | published        | 1212022 | 2032-02-29T13:00:05          |
  When I am logged in as a user with the "content_approver" role
    And I am on "/node/1212022/edit"
    And I scroll "#edit-body-wrapper" into view
    And I type "see me play with used tennis ball" in the "Body" WYSIWYG editor
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Dirty Bird Image" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I publish it
  Then I take a screenshot using "announcements.feature" file with "@det_image" tag

@api @javascript @ui @wdio
Scenario: Training With Image Embed
  Given "image" content:
    | title            | field_alt_text              | field_image_upload   |
    | Dirty Bird Image | This is a picture of a bird | image;behat-bird.gif |
    And "announcement" content:
      | title                         | field_short_title          | published_at | status | field_announcement_type | changed             | field_source | field_topic | field_top_level_group | moderation_state | nid     | field_override_modified_date |
      | WDIO Training With Image Test | wdio train with image test | now          | 1      | Training                | 2032-03-01T13:00:00 | open source  | wdio        | top-shelf             | published        | 1212022 | 2032-02-29T13:00:05          |
  When I am logged in as a user with the "content_approver" role
    And I am on "/node/1212022/edit"
    And I scroll "#edit-body-wrapper" into view
    And I type "see me play with used tennis ball" in the "Body" WYSIWYG editor
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Dirty Bird Image" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I publish it
  Then I take a screenshot using "announcements.feature" file with "@train_image" tag

@api @javascript @ui @wdio @wowza
Scenario: Memorandum With Wowza Video Embed
  Given "video" content:
      | title          | field_video_type | field_video_origin | field_media_id                             | body        | field_transcript | status | created |
      | Some SEC Video | town_hall        | Wowza              | https://www.w3schools.com/html/mov_bbb.mp4 | Body text 5 | Transcript 5     | 1      | -2 day  |
    And "announcement" content:
      | title                     | field_short_title         | published_at | status | field_announcement_type | changed             | field_date | field_source | field_topic | field_top_level_group | moderation_state | nid     | field_to | field_from | field_override_modified_date |
      | WDIO Memo With Video Test | wdio memo with video test | now          | 1      | Memorandum              | 2032-03-01T13:00:00 | 2032-02-28 | open source  | wdio        | top-shelf             | published        | 1212022 | You      | Me         | 2032-02-29T13:00:05          |
  When I am logged in as a user with the "content_approver" role
    And I am on "/node/1212022/edit"
    And I scroll "#edit-body-wrapper" into view
    And I type "see some wz video" in the "Body" WYSIWYG editor
    And I press "Video Embed" in the WYSIWYG Toolbar
    And I select the first autocomplete option for "some sec video" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I publish it
  Then I take a screenshot using "announcements.feature" file with "@memo_wzvideo" tag

@api @javascript @ui @wdio @wowza
Scenario: Obituary With Wowza Video Embed
  Given "video" content:
      | title          | field_video_type | field_video_origin | field_media_id                             | body        | field_transcript | status | created |
      | Some SEC Video | town_hall        | Wowza              | https://www.w3schools.com/html/mov_bbb.mp4 | Body text 5 | Transcript 5     | 1      | -2 day  |
    And "announcement" content:
      | title                         | field_short_title         | published_at | status | field_announcement_type | changed             | field_date | field_source | field_topic | field_top_level_group | moderation_state | nid     | field_to | field_from | field_override_modified_date |
      | WDIO Obituary With Video Test | wdio obit with video test | now          | 1      | Obituary                | 2032-03-01T13:00:00 | 2032-02-28 | open source  | wdio        | top-shelf             | published        | 1212022 | You      | Me         | 2032-02-29T13:00:05          |
  When I am logged in as a user with the "content_approver" role
    And I am on "/node/1212022/edit"
    And I scroll "#edit-body-wrapper" into view
    And I type "see some wz video" in the "Body" WYSIWYG editor
    And I press "Video Embed" in the WYSIWYG Toolbar
    And I select the first autocomplete option for "some sec video" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I publish it
  Then I take a screenshot using "announcements.feature" file with "@obit_wzvideo" tag

@api @javascript @ui @wdio @wowza
Scenario: Detail With Wowza Video Embed
  Given "video" content:
      | title          | field_video_type | field_video_origin | field_media_id                             | body        | field_transcript | status | created |
      | Some SEC Video | town_hall        | Wowza              | https://www.w3schools.com/html/mov_bbb.mp4 | Body text 5 | Transcript 5     | 1      | -2 day  |
    And "announcement" content:
      | title                       | field_short_title           | published_at | status | field_announcement_type | changed             | field_source | field_topic | field_top_level_group | moderation_state | nid     | field_override_modified_date |
      | WDIO Detail With Video Test | wdio detail with video test | now          | 1      | Detail                  | 2032-03-01T13:00:00 | open source  | wdio        | top-shelf             | published        | 1212022 | 2032-02-29T13:00:05          |
  When I am logged in as a user with the "content_approver" role
    And I am on "/node/1212022/edit"
    And I scroll "#edit-body-wrapper" into view
    And I type "see some wz video" in the "Body" WYSIWYG editor
    And I press "Video Embed" in the WYSIWYG Toolbar
    And I select the first autocomplete option for "some sec video" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I publish it
  Then I take a screenshot using "announcements.feature" file with "@det_wzvideo" tag

@api @javascript @ui @wdio @wowza
Scenario: Training With Wowza Video Embed
   Given "video" content:
      | title          | field_video_type | field_video_origin | field_media_id                             | body        | field_transcript | status | created |
      | Some SEC Video | town_hall        | Wowza              | https://www.w3schools.com/html/mov_bbb.mp4 | Body text 5 | Transcript 5     | 1      | -2 day  |
    And "announcement" content:
      | title                         | field_short_title          | published_at | status | field_announcement_type | changed             | field_source | field_topic | field_top_level_group | moderation_state | nid     | field_override_modified_date |
      | WDIO Training With Video Test | wdio train with video test | now          | 1      | Training                | 2032-03-01T13:00:00 | open source  | wdio        | top-shelf             | published        | 1212022 | 2032-02-29T13:00:05          |
  When I am logged in as a user with the "content_approver" role
    And I am on "/node/1212022/edit"
    And I scroll "#edit-body-wrapper" into view
    And I type "see some wz video" in the "Body" WYSIWYG editor
    And I press "Video Embed" in the WYSIWYG Toolbar
    And I select the first autocomplete option for "some sec video" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I publish it
  Then I take a screenshot using "announcements.feature" file with "@train_wzvideo" tag

@api @javascript @ui @wdio
Scenario: Memorandum With YouTube Video Embed
  Given "video" content:
    | title                             | field_video_type | field_video_origin | field_video                                 | body            | field_transcript     | status |
    | New Director of Enforcement Joins | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc | Body text 4     | Transcript 4         | 1      |
    And "announcement" content:
      | title                             | field_short_title            | published_at | status | field_announcement_type | changed             | field_date | field_source | field_topic | field_top_level_group | moderation_state | nid     | field_to | field_from | field_override_modified_date |
      | WDIO Memo With YouTube Video Test | wdio memo with yt video test | now          | 1      | Memorandum              | 2032-03-01T13:00:00 | 2032-02-28 | open source  | wdio        | top-shelf             | published        | 1212022 | You      | Me         | 2032-02-29T13:00:05          |
  When I am logged in as a user with the "content_approver" role
    And I am on "/node/1212022/edit"
    And I scroll "#edit-body-wrapper" into view
    And I type "see some yt video" in the "Body" WYSIWYG editor
    And I press "Video Embed" in the WYSIWYG Toolbar
    And I select the first autocomplete option for "New Director of Enforcement Joins" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I publish it
  Then I take a screenshot using "announcements.feature" file with "@memo_ytvideo" tag

@api @javascript @ui @wdio
Scenario: Obituary With Vimeo Video Embed
  Given "video" content:
    | title              | field_video_type | field_video_origin | field_video                                 | body            | field_transcript     | status |
    | Investor.gov Video | instructional    | youtubevimeo       | https://vimeo.com/343314163                 | Body text 7     | Transcript 7         | 1      |
    And "announcement" content:
      | title                           | field_short_title            | published_at | status | field_announcement_type | changed             | field_date | field_source | field_topic | field_top_level_group | moderation_state | nid     | field_to | field_from | field_override_modified_date |
      | WDIO Obit With Vimeo Video Test | wdio obit with vm video test | now          | 1      | Obituary                | 2032-03-01T13:00:00 | 2032-02-28 | open source  | wdio        | top-shelf             | published        | 1212022 | You      | Me         | 2032-02-29T13:00:05          |
  When I am logged in as a user with the "content_approver" role
    And I am on "/node/1212022/edit"
    And I scroll "#edit-body-wrapper" into view
    And I type "see some vm video" in the "Body" WYSIWYG editor
    And I press "Video Embed" in the WYSIWYG Toolbar
    And I select the first autocomplete option for "investor.gov video" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I publish it
  Then I take a screenshot using "announcements.feature" file with "@obit_vmvideo" tag

@api @javascript @ui @wdio
Scenario: Announcement List Page Pagination
  Given "announcement" content:
    | title                                       | body   | published_at        | status | field_announcement_type |
    | 1 Free Ice Cream Today                      | Test 1 | 2034-07-23 12:00:00 | 1      |                         |
    | 2 Detail Opportunities                      | Test 2 | 2034-01-29 12:00:00 | 1      |                         |
    | 2 New Personal Development                  | Test 3 | 2034-02-29 12:00:00 | 1      | Obituary                |
    | 2018 FINRA Annual WebCast                   | Test 4 | 2034-03-29 12:00:00 | 1      | Memorandum              |
    | 2 Reminiders: Annual Certification          | Test 5 | 2034-04-29 12:00:00 | 1      | Memorandum              |
    | All Hands Meeting                           | Test 6 | 2034-05-29 12:00:00 | 1      | Memorandum              |
    | Access to Capital                           | Test 7 | 2034-06-29 12:00:00 | 1      | Memorandum              |
    | 6th Annual Conference                       | Test 8 | 2034-07-29 12:00:00 | 1      | Memorandum              |
    | A Message from chairman                     | Test 8 | 2034-08-29 12:00:00 | 1      | Memorandum              |
    | A New Year                                  | Test 8 | 2034-09-29 12:00:00 | 1      | Memorandum              |
    | Administrative and Support professionals    | Test 8 | 2034-09-20 12:00:00 | 1      | Memorandum              |
    | Big Data Webinar Series – Intermediate      | Test 8 | 2034-05-19 12:00:00 | 1      | Memorandum              |
    | Big Data Webinar Series – Advanced          | Test 8 | 2033-06-29 12:00:00 | 1      | Memorandum              |
    | Jewish American Heritage Book Club Meeting  | Test 8 | 2033-06-29 12:00:00 | 1      | Memorandum              |
    | Detail Opportunity for Risk Officer in OCOO | Test 8 | 2033-06-09 12:00:00 | 1      | Memorandum              |
    | SEC Celebrates Women’s History Month        | Test 8 | 2033-06-01 12:00:00 | 1      | Memorandum              |
    | Voluntary Reassignment Program Update       | Test 8 | 2035-01-02 12:00:00 | 1      | Memorandum              |
    | Voluntary Reassignment Program Update2      | Test 8 | 2035-03-19 12:00:00 | 1      | Memorandum              |
    | Veterans Committee Quarterly Meeting        | Test 8 | 2035-03-29 12:00:00 | 1      | Memorandum              |
    | Get Control! of iPhone and iPad             | Test 8 | 2035-04-26 12:00:00 | 1      | Memorandum              |
    | CLD 107 – Building Emotional Intelligence   | Test 8 | 2035-05-23 12:00:00 | 1      | Memorandum              |
    | Call for Interested Applicants              | Test 8 | 2034-06-10 12:00:00 | 1      | Memorandum              |
    | Early Dismissal for Thanksgiving            | Test 8 | 2034-07-01 12:00:00 | 1      | Memorandum              |
    | Early Dismissal for Labor Day Weekend       | Test 8 | 2034-07-14 12:00:00 | 1      | Memorandum              |
    | Women’s Committee Quarterly Meeting         | Test 8 | 2033-07-29 12:00:00 | 1      | Memorandum              |
    | Yellow Dress code on July 20th              | Test 8 | 2033-03-29 12:00:00 | 1      | Memorandum              |
    | The New York City Announcement              | Test 8 | 2033-02-20 12:00:00 | 1      | Memorandum              |
  Then I take a screenshot using "announcements.feature" file with "@announcement_pagi" tag
