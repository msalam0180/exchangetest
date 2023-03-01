Feature: Create Video Screenshot
  As a Content Creator, I should be able to see Preview Image Show up For The Vimeo Video On Gallery Pages

@api @javascript @ui @wdio
Scenario: Preview Image Thumbnail On Gallery Pages WDIO
  Given I am logged in as a user with the "content_approver" role
    And "video" content:
      | title                | field_video_type | field_video_origin | field_caption     | field_video                 | body        | field_transcript | status | nid |
      | Free Ice Cream Today | guest_speaker    | youtubevimeo       | Ice Cream Caption | https://vimeo.com/674315269 | Body text 1 | Transcript 1     | 1      | 6   |
  When I visit "/node/add/gallery"
    And I fill in "Title" with "Behat Test Title"
    And I scroll to the bottom
    And I press "Save"
    And I visit "/admin/content"
    And I select "Gallery" from "Content type"
    And I press "Filter"
    And I click "Edit" in the "Behat Test Title" row
    And I scroll to the bottom
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
    And I check "Free Ice Cream Today" on the files selector
    And I click on the element with css selector "#edit-submit"
    And I wait 2 seconds
    And I switch to the main window
    And I press "Save"
  Then I take a screenshot using "video.feature" file with "@image_vmvideo" tag

@api @javascript @ui @wdio
Scenario: Embed Vimeo Video to Article Content WDIO
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
    And I select the first autocomplete option for "The $20 Billion Dollar Holiday (Copy)" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I wait for ajax to finish
    And I click "Embed" on the modal "Embed content item"
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Technology" from "Topic"
    And I select "My SEC" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "video.feature" file with "@embed_vmvideo" tag

@api @javascript @ui @wdio
Scenario: Replicated Youtube To Vimeo Video WDIO
  Given I am logged in as a user with the "content_approver" role
    And "video" content:
      | title                | field_video_type | field_video_origin | field_caption     | field_video                                 | body        | field_transcript | status | nid |
      | Free Ice Cream Today | guest_speaker    | youtubevimeo       | Ice Cream Caption | https://vimeo.com/674315269                 | Body text 1 | Transcript 1     | 1      | 6   |
      | Behat Training Video | guest_speaker    | youtubevimeo       | Behat Caption     | https://www.youtube.com/watch?v=xf9BpXOtMcc | Drama       | airforce         | 1      | 7   |
  When I visit "/node/add/gallery"
    And I fill in "Title" with "Behat Test"
    And I scroll to the bottom
    And I press "Save"
    And I visit "/admin/content"
    And I select "Gallery" from "Content type"
    And I press "Filter"
    And I click "Edit" in the "Behat Test" row
    And I scroll to the bottom
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
    And I check "Behat Training Video" on the files selector
    And I click on the element with css selector "#edit-submit"
    And I wait 2 seconds
    And I switch to the main window
    And I press "Save"
    And I visit "/admin/content"
    And I select "Video" from "Content type"
    And I press "Filter"
    And I wait for AJAX to finish
    And I click "Edit" in the "Behat Training Video" row
    And I click "Replicate"
    And I press "Replicate"
    And I fill in "YouTube/Vimeo Link" with "https://vimeo.com/674315269"
    And I select "Technology" from "Topic"
    And I select "My SEC" from "Top Level Group"
    And I publish it
    And I visit "/admin/content"
    And I select "Gallery" from "Content type"
    And I press "Filter"
    And I click "Edit" in the "Behat Test" row
    And I scroll to the bottom
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
    And I check "Behat Training Video (Copy)" on the files selector
    And I click on the element with css selector "#edit-submit"
    And I wait 2 seconds
    And I switch to the main window
    And I press "Save"
  Then I take a screenshot using "video.feature" file with "@ytube_vmvideo" tag
