Feature: View and Search for Videos
  As a visitor to the Insider
  I want to be able to watch videos
  So I can learn information about the SEC

  Background:
    Given "topic" terms:
      | name            |
      | Technology      |
      | Human Resources |
      And "top_level_group" terms:
        | name     |
        | toplevel |
        | sports   |
      And "office_division" terms:
        | name  |
        | Moana |
        | Brave |

@api @javascript
Scenario: Create a Video
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/video"
    And I fill in the following:
      | Title              | BEHAT Test Video |
      | Video Running Time | 08:22:32         |
    And I select "YouTube or Vimeo" from "Video Origin"
    And I fill in "YouTube/Vimeo Link" with "http://www.youtube.com/watch?v=xf9BpXOtMcc"
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I type "This is a transcript" in the "Transcript" WYSIWYG editor
    And I select "Technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I select "Moana" from "Division / Office"
    And I see the text "Enter in HH:MM:SS format."
    And I press the "List additional actions" button
    And I click the input with the value "Save and Publish"
  Then I should see the heading "BEHAT Test Video"

@api @javascript
Scenario Outline: Test Embed Types
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/video"
    And I fill in the following:
      | Title              | BEHAT Test Video |
      | Video Running Time | 22m              |
    And I select "YouTube or Vimeo" from "Video Origin"
    And I fill in "YouTube/Vimeo Link" with "<Video>"
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I type "This is a transcript" in the "Transcript" WYSIWYG editor
    And I select "Technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the heading "BEHAT Test Video"
    And I should see the "<Video>" in the "<Type>" player

  Examples:
    | Video                                      | Type    |
    | http://www.youtube.com/watch?v=xf9BpXOtMcc | YouTube |
    | https://vimeo.com/159251193                | Vimeo   |

@api @javascript
Scenario: Create a Wowza Video
  #This scenario will fail if the test is run while connecting to the SEC network as the video player will not show up.  Please run this test outside of SEC network and it should pass.
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/video"
    And I fill in the following:
      | Title                 | BEHAT Test Video |
      | Video Running Time    | 26m              |
	  And I select "Wowza" from "Video Origin"
	  And I attach the file "behat-rabbit.jpg" to "Video on Demand Page Thumbnail"
    And I wait for ajax to finish
    And I fill in "Wowza URL" with "https://www.w3schools.com/tags/movie.mp4"
    And I fill in "Alternative text" with "Behat Test Text"
    And I fill in "Caption" with "some caption text"
	  And I type "Test Body" in the "Body" WYSIWYG editor
    And I type "This is a transcript" in the "Transcript" WYSIWYG editor
    And I select "Technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the heading "BEHAT Test Video"
    And I should see a video player

@api @javascript
Scenario: View a Wowza Video
  Given I am logged in as a user with the "Authenticated user" role
  When I am viewing a "video" content:
    | body                     | This is the body                           |
    | title                    | BEHAT Video                                |
    | field_transcript         | This is a transcript                       |
    | field_video_running_time | 00:06:25                                   |
    | field_media_id           | https://www.w3schools.com/html/mov_bbb.mp4 |
    | field_video_origin       | Wowza                                      |
    | status                   | 1                                          |
  Then I should see the heading "BEHAT Video"
    And I should see the text "Video Running Time"
    And I should see the text "00:06:25"
    And I should see the text "This is the body"
    And I should see the text "Transcript"
    And I click the "#accordion-transcript" element
    And I wait for Ajax to finish
    And I should see the text "This is a transcript"
  	And I should see the text "Modified"
    #should test for the time

@api @javascript
Scenario: Video type filter validation
#TODO Delete all video content before running this
  Given I am logged in as a user with the "Authenticated user" role
    And "video" content:
      | title                             | field_video_type | field_video_origin | field_video                                 | field_media_id                           | body            | field_transcript     | status |
      | Free Ice Cream Today              | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 1     | Transcript 1         | 1      |
      | Sign Up For Benefits By Friday    | instructional    | Wowza              |                                             | https://vjs.zencdn.net/v/oceans.mp4      | Behat Mogadishu | Transcript 2         | 1      |
      | Early Dismissal                   | town_hall        | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 3     | Behat Constantinople | 1      |
      | New Director of Enforcement Joins | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 4     | Transcript 4         | 1      |
      | Impacts from the Hurricane        | town_hall        | Wowza              |                                             | https://www.w3schools.com/tags/movie.mp4 | Body text 5     | Transcript 5         | 1      |
      | Vigil Held for 9/11               | guest_speaker    | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Body text 6     | Transcript 6         | 1      |
      | Pizza Party Planned               | instructional    | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Body text 7     | Transcript 7         | 1      |
  When I visit "/news/videos"
    And I select "Guest Speaker" from "Video Type"
    And I press "Search" in the "filters" region
  Then I should see the link "Free Ice Cream Today"
    And I should see the link "New Director of Enforcement Joins"
    And I should see the link "Vigil Held for 9/11"
    But I should not see the link "Pizza Party Planned"
    And I should not see the link "Impacts from the Hurricane"
    And I should not see the link "Early Dismissal "
    And I should not see the link "Sign Up For Benefits By Friday"

@api
Scenario Outline: Search Videos by Title, Transcript and Body
#TODO Test that the other links don't show
  Given I am logged in as a user with the "Authenticated user" role
    And "video" content:
      | title                             | field_video_type | field_video_origin | field_video                                 | field_media_id                           | body            | field_transcript     | status |
      | Free Ice Cream Today              | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 1     | Transcript 1         | 1      |
      | Sign Up For Benefits By Friday    | instructional    | Wowza              |                                             | https://www.w3schools.com/tags/movie.mp4 | Behat Mogadishu | Transcript 2         | 1      |
      | Early Dismissal                   | town_hall        | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 3     | Behat Constantinople | 1      |
      | New Director of Enforcement Joins | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 4     | Transcript 4         | 1      |
      | Impacts from the Hurricane        | town_hall        | Wowza              |                                             | https://vjs.zencdn.net/v/oceans.mp4      | Body text 5     | Transcript 5         | 1      |
      | Vigil Held for 9/11               | guest_speaker    | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Body text 6     | Transcript 6         | 1      |
      | Pizza Party Planned               | instructional    | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Body text 7     | Transcript 7         | 1      |
  When I visit "/news/videos"
  Then I should see the heading "Video on Demand"
  When I fill in "search" with "<SearchText>"
    And I press "edit-submit-video-on-demand"
  Then the search results should show the link "<Link>"

    Examples:
      | SearchText           | Link                           |
      | Free Ice Cream Today | Free Ice Cream Today           |
      | Behat Mogadishu      | Sign Up For Benefits By Friday |
      | Behat Constantinople | Early Dismissal                |

@api @javascript
Scenario: Default sort order by most recent posted first
  Given I am logged in as a user with the "Authenticated user" role
    And "video" content:
      | title                             | field_video_type | field_video_origin | field_video                                 | field_media_id                           | body            | field_transcript     | status | created |
      | Free Ice Cream Today              | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 1     | Transcript 1         | 1      | -1 day  |
      | Sign Up For Benefits By Friday    | instructional    | Wowza              |                                             | https://www.w3schools.com/tags/movie.mp4 | Behat Mogadishu | Transcript 2         | 1      | now     |
      | Early Dismissal                   | town_hall        | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 3     | Behat Constantinople | 1      | -5 day  |
      | New Director of Enforcement Joins | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 4     | Transcript 4         | 1      | -3 day  |
      | Impacts from the Hurricane        | town_hall        | Wowza              |                                             | https://vjs.zencdn.net/v/oceans.mp4      | Body text 5     | Transcript 5         | 1      | -2 day  |
      | Vigil Held for 9/11               | guest_speaker    | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Body text 6     | Transcript 6         | 1      | -4 day  |
      | Pizza Party Planned               | instructional    | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Body text 7     | Transcript 7         | 1      | -7 day  |
  When I visit "/news/videos"
  Then "Sign Up For Benefits By Friday" should precede "Free Ice Cream Today" for the query "//h3[contains(@class, 'media-heading')]/a"
    And "Free Ice Cream Today" should precede "New Director of Enforcement Joins" for the query "//h3[contains(@class, 'media-heading')]/a"

@api @javascript
Scenario: Create LinkIt Link to Video
  Given I am logged in as a user with the "content_approver" role
    And "video" content:
      | title                   | field_video_type | field_video_origin | field_video                                 | field_media_id                   | body            | field_transcript     | status |   nid    |
      | About Mr. Joe Connolly  | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                  | Body text 1     | Transcript 1         | 1      | 9999999  |
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "BEHAT Video LinkIt Article"
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
    And I fill in "URL" with "/node/9999999"
    And I click "Save" on the modal "Add Link"
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I fill in "Display Text" with "SEC - Joe Connolly"
    And I press the "OK" button
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Policy" from "Article Type"
    And I select "Technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I should see the heading "BEHAT Video LinkIt Article"
    And I should see the link "SEC - Joe Connolly"
    And I click "SEC - Joe Connolly"
    And I should see the heading "About Mr. Joe Connolly"

@api @javascript
Scenario Outline: Thumbnail On Wowza Video Content
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/video"
    And I fill in the following:
      | Title              | BEHAT Test Video |
      | Video Running Time | 26m              |
    And I select "Wowza" from "Video Origin"
    And I attach the file "<img_file_type>" to "Video on Demand Page Thumbnail"
    And I wait for ajax to finish
  Then I should see the "div" element with the "class" attribute set to "image-preview" in the "thumbnail" region
    And I should see the "img" element with the "data-drupal-selector" attribute set to "edit-field-limelight-thumbnail-0-preview" in the "thumbnail" region
    And I should see the "img" element with the "class" attribute set to "image-style-thumbnail" in the "thumbnail" region
  When I fill in "Wowza URL" with "https://www.w3schools.com/tags/movie.mp4"
    And I fill in "Alternative text" with "<alt_text>"
    And I type "Test Body" in the "Body" WYSIWYG editor
    And I type "This is a transcript" in the "Transcript" WYSIWYG editor
    And I select "Technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the text "Video BEHAT Test Video has been created."
  When I am on "/news/videos"
  Then I should see the text "Behat Test Video"
    And I should see the "div" element with the "class" attribute set to "media-left" in the "videolist" region
    And I should see the "img" element with the "width" attribute set to "250" in the "videolist" region
    And I should see the "img" element with the "height" attribute set to "150" in the "videolist" region
    And I should see the "img" element with the "alt" attribute set to "<alt_text>" in the "videolist" region

    Examples:
      | img_file_type          | alt_text        |
      | behat-bird.gif         | bird gif file   |
      | behat-black_rabbit.jpg | rabbit jpg file |
      | behat-cat.png          | cat png file    |
      | behat-dog.jpeg         | dog jpeg file   |

@api
Scenario: Search Filter Containing All Words
  Given I am logged in as a user with the "Authenticated user" role
    And "video" content:
      | title                             | field_video_origin | field_video                                 | field_media_id                           | body              | field_transcript     | status |
      | Town Hall Gensler                 | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 1       | Transcript 1         | 1      |
      | Sign Up For Benefits By Friday    | Wowza              |                                             | https://vjs.zencdn.net/v/oceans.mp4      | Behat Mogadishu   | Transcript 2         | 1      |
      | Early Dismissal                   | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 3       | Behat Constantinople | 1      |
      | New Director of Enforcement Joins | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 4       | Town Hall Gensler    | 1      |
      | Impacts from the Hurricane        | Wowza              |                                             | https://www.w3schools.com/tags/movie.mp4 | Body text 5       | Transcript 5         | 1      |
      | Vigil Held for 9/11               | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Body text 6       | Transcript 6         | 1      |
      | Pizza Party Planned               | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Town Hall Gensler | Transcript 7         | 1      |
  When I visit "/news/videos"
    And I fill in "search" with "Town Hall Gensler"
    And I press "Search" in the "filters" region
  Then I should see the link "Town Hall Gensler"
    And I should see the link "New Director of Enforcement Joins"
    And I should see the link "Pizza Party Planned"
    But I should not see the link "Vigil Held for 9/11"
    And I should not see the link "Impacts from the Hurricane"
    And I should not see the link "Early Dismissal"
    And I should not see the link "Sign Up For Benefits By Friday"

@api
Scenario: Search Filter Containing Separated Words
  Given I am logged in as a user with the "Authenticated user" role
    And "video" content:
      | title                             | field_video_origin | field_video                                 | field_media_id                           | body              | field_transcript     | status |
      | Town Hall Gensler                 | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 1       | Transcript 1         | 1      |
      | Sign Up For Benefits By Friday    | Wowza              |                                             | https://vjs.zencdn.net/v/oceans.mp4      | Behat Mogadishu   | Transcript 2         | 1      |
      | Early Dismissal                   | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 3       | Behat Constantinople | 1      |
      | New Director of Enforcement Joins | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 4       | Town Hall Gensler    | 1      |
      | Impacts from the Hurricane        | Wowza              |                                             | https://www.w3schools.com/tags/movie.mp4 | Body text 5       | Gensler              | 1      |
      | Vigil Held for 9/11               | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Town Hall         | Transcript 6         | 1      |
      | Pizza Party Planned               | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Town Hall Gensler | Transcript 7         | 1      |
      | Town Meeting                      | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Hall              | Gensler              | 1      |
      | Hall Gensler Town                 | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 4       | Transcript           | 1      |
  When I visit "/news/videos"
    And I fill in "search" with "Town Hall Gensler"
    And I press "Search" in the "filters" region
  Then I should see the link "Town Hall Gensler"
    And I should see the link "New Director of Enforcement Joins"
    And I should see the link "Pizza Party Planned"
    And I should see the link "Town Meeting"
    And I should see the link "Hall Gensler Town"
    But I should not see the link "Vigil Held for 9/11"
    And I should not see the link "Impacts from the Hurricane"
    And I should not see the link "Early Dismissal"
    And I should not see the link "Sign Up For Benefits By Friday"

@api @javascript
Scenario: Videos Pagination
  Given I am logged in as a user with the "Authenticated user" role
    And "video" content:
      | title                             | field_video_origin | field_video                                 | field_media_id                           | body              | field_transcript     | status | published_at |
      | Town Hall Gensler                 | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 1       | Transcript 1         | 1      | -1 days      |
      | Sign Up For Benefits By Friday    | Wowza              |                                             | https://vjs.zencdn.net/v/oceans.mp4      | Behat Mogadishu   | Transcript 2         | 1      | -2 days      |
      | Early Dismissal                   | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 3       | Behat Constantinople | 1      | -3 days      |
      | New Director of Enforcement Joins | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 4       | Town Hall Gensler    | 1      | -4 days      |
      | Impacts from the Hurricane        | Wowza              |                                             | https://www.w3schools.com/tags/movie.mp4 | Body text 5       | Gensler              | 1      | -5 days      |
      | Vigil Held for 9/11               | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Town Hall         | Transcript 6         | 1      | -6 days      |
      | Pizza Party Planned               | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Town Hall Gensler | Transcript 7         | 1      | -7 days      |
      | Town Meeting                      | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Hall              | Gensler              | 1      | -8 days      |
      | Hall Gensler Town                 | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 4       | Transcript           | 1      | -9 days      |
      | Pool Party Planned                | youtubevimeo       | https://vimeo.com/159251193                 |                                          | Town Hall Gensler | Transcript 7         | 1      | -10 days     |
      | City Meeting                      | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Hall              | Gensler              | 1      | -11 days     |
      | Gender Reveal Party               | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                                          | Body text 4       | Transcript           | 1      | -12 days     |
  When I visit "/news/videos"
  Then I should see the text "1 to 10 of 12 items"
  When I select "5" from "Show"
  Then I should see the link "Go to page 2"
    And I should see the link "Go to last page"
    And I should see the link "Go to next page"
    And I should not see the link "Gender Reveal Party"
  When I select "All" from "Show"
  Then I should not see the link "Go to next page"
    And I should not see the link "Go to last page"
    And I should see the link "Gender Reveal Party"
    And I should see the text "1 to 12 of 12 items"

@api @javascript
Scenario: Preview Image Shows For The Vimeo Video On Gallery Pages
  Given I am logged in as a user with the "content_approver" role
    And "video" content:
      | title                | field_video_type | field_video_origin | field_caption     | field_video                 | body        | field_transcript | status | nid |
      | Free Ice Cream Today | guest_speaker    | youtubevimeo       | Ice Cream Caption | https://vimeo.com/674315269 | Body text 1 | Transcript 1     | 1      | 6   |
  When I visit "/node/add/gallery"
    And I fill in "Title" with "Behat Test Title"
    And I scroll to the bottom
    And I press "Save"
  Then I visit "/admin/content"
    And I select "Gallery" from "Content type"
    And I press "Filter"
    And I click "Edit" in the "Behat Test Title" row
    And I scroll to the bottom
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
  When I check "Free Ice Cream Today" on the files selector
    And I click on the element with css selector "#edit-submit"
    And I wait 2 seconds
    And I switch to the main window
    And I press "Save"
  Then I should see the link "Behat Test Title"
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/gallery/behat-test-title"
  Then I should see the "div" element with the "class" attribute set to "media-box-thumbnail-container" in the "content" region
    And I should not see "media-box-thumbnail-container broken-image-here" in the "div" element

@api @javascript
Scenario: Replicate A YouTube Video And Change It To Use A Vimeo Video
  Given I am logged in as a user with the "content_approver" role
    And "video" content:
      | title                | field_video_type | field_video_origin | field_caption     | field_video                                 | body        | field_transcript | status | nid |
      | Free Ice Cream Today | guest_speaker    | youtubevimeo       | Ice Cream Caption | https://vimeo.com/674315269                 | Body text 1 | Transcript 1     | 1      | 6   |
      | Behat Training Video | guest_speaker    | youtubevimeo       | Behat Caption     | https://www.youtube.com/watch?v=xf9BpXOtMcc | Drama       | airforce         | 1      | 7   |
  When I visit "/node/add/gallery"
    And I fill in "Title" with "Behat Test Title"
    And I scroll to the bottom
    And I press "Save"
  Then I visit "/admin/content"
    And I select "Gallery" from "Content type"
    And I press "Filter"
    And I click "Edit" in the "Behat Test Title" row
    And I scroll to the bottom
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
  When I check "Behat Training Video" on the files selector
    And I click on the element with css selector "#edit-submit"
    And I wait 2 seconds
    And I switch to the main window
    And I press "Save"
  Then I should see the link "Behat Test Title"
  When I visit "/admin/content"
    And I select "Video" from "Content type"
    And I press "Filter"
    And I wait for AJAX to finish
    And I click "Edit" in the "Behat Training Video" row
    And I click "Replicate"
    And I fill in "New label (English)" with "2022 World Cup"
    And I press "Replicate"
    And I fill in "YouTube/Vimeo Link" with "https://vimeo.com/674315269"
    And I select "Technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I visit "/admin/content"
    And I select "Gallery" from "Content type"
    And I press "Filter"
    And I click "Edit" in the "Behat Test Title" row
    And I scroll to the bottom
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
  When I check "2022 World Cup" on the files selector
    And I click on the element with css selector "#edit-submit"
    And I wait 2 seconds
    And I switch to the main window
    And I press "Save"
  Then I should see the link "Behat Test Title"
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/gallery/behat-test-title"
    And I should see the text "Behat Training Video"
    And I should see the text "2022 World Cup"
  Then I should see the "button" element with the "data-src" attribute set to "https://www.youtube.com/watch?v=xf9BpXOtMcc" in the "content" region
    And I should see the "button" element with the "data-src" attribute set to "https://vimeo.com/674315269" in the "content" region

@api @javascript
Scenario: Replicate and Embed Vimeo to Article Content
  Given I am logged in as a user with the "content_approver" role
    And "video" content:
      | title                          | field_video_origin | field_video                                 | body                     | field_transcript | status |
      | The $20 Billion Dollar Holiday | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc | A Look at Valentines Day | Transcript 1     | 1      |
  When I visit "/admin/content"
    And I select "Video" from "Content type"
    And I press "Filter"
    And I wait for AJAX to finish
    And I click "Edit" in the "The $20 Billion Dollar Holiday" row
    And I click "Replicate"
    And I fill in "New label (English)" with "2022 World Cup"
    And I press "Replicate"
    And I fill in "YouTube/Vimeo Link" with "https://vimeo.com/674315269"
    And I select "My SEC" from "Top Level Group"
    And I select "Technology" from "Topic"
    And I publish it
    And I visit "/node/add/sec_article"
    And I fill in "Title" with "World Cup"
    And I type "Valentines Day" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Video Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "2022 World Cup" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I wait for ajax to finish
    And I click "Embed" on the modal "Embed content item"
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Technology" from "Topic"
    And I select "My SEC" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
    And I am logged in as a user with the "Authenticated user" role
    And I visit "/my-sec/world-cup"
  Then I should see the "iframe" element with the "src" attribute set to "https://player.vimeo.com/video/674315269?autoplay=0" in the "content" region
