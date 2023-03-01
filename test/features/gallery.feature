Feature: Gallery Slideshow
  As a content creator
  I would like to be able to create galleries around different
  events/topics/etc and select existing images or videos to be displayed
   in that gallery so that end users can quickly see all related media

  Background:

    Given "tags" terms:
      | name  |
      | pet   |
      | event |
      And "image" content:
        | title              | field_alt_text               | field_caption  | field_image_upload               | nid | field_tags |
        | BEHAT Bird Image   | This is a picure of a bird   | bird caption   | image;behat-bird.gif             | 1   | pet        |
        | BEHAT Rabbit Image | This is a picure of a rabbit | rabbit caption | image;behat-rabbit.jpg           | 2   | pet        |
        | BEHAT Cat Image    | This is a picure of a cat    | cat caption    | image;behat-cat.png              | 3   | pet        |
        | BEHAT Dog Image    | This is a picure of a dog    | dog caption    | image;behat-dog.jpeg             | 4   | pet        |
        | Just Puppy Image   | This is a picure of a puppy  | puppy caption  | image;behat-test_shiba_puppy.jpg | 5   | pet        |
      And "video" content:
        | title                          | field_video_type | field_video_origin | field_caption     | field_video                                 | body        | field_transcript | status | nid | field_tags | field_media_id                           |
        | Free Ice Cream Today           | guest_speaker    | youtubevimeo       | Ice Cream Caption | https://www.youtube.com/watch?v=xf9BpXOtMcc | Body text 1 | Transcript 1     | 1      | 6   | event      |                                          |
        | Behat Training Video           | guest_speaker    | youtubevimeo       | Behat Caption     | https://www.youtube.com/watch?v=xf9BpXOtMcc | Drama       | airforce         | 1      | 7   | event      |                                          |
        | Second Blu-ray                 | instructional    | Wowza              | Second Caption    |                                             | Horror      |                  | 1      | 8   | event      |                                          |
        | Another DVD                    | town_hall        | youtubevimeo       | Another Caption   | https://www.youtube.com/watch?v=xf9BpXOtMcc | Comedy      | sec              | 1      | 9   | event      |                                          |
        | Behat Video With No Transcript | town_hall        | youtubevimeo       | No Transcript     | https://www.youtube.com/watch?v=xf9BpXOtMcc | Comedy      |                  | 1      | 10  | event      |                                          |
        | Sign Up For Benefits By Friday | instructional    | Wowza              | Wowza Caption     |                                             | benefits    | wowza transcript | 1      | 11  | event      | https://www.w3schools.com/tags/movie.mp4 |
        | Wowza With No Transcript       | town_hall        | Wowza              | No Transcript     |                                             | sci-fi      |                  | 1      | 12  | event      | https://www.w3schools.com/tags/movie.mp4 |
        | Training Series - Part 1       | instructional    | Wowza              | Cap Part 1        |                                             | Part 1      |                  | 1      | 13  | event      | https://www.w3schools.com/tags/movie.mp4 |
        | Training Series - Part 2       | instructional    | youtubevimeo       | Cap Part 2        | https://www.youtube.com/watch?v=xf9BpXOtMcc | Part 2      |                  | 1      | 14  | event      |                                          |
        | Training Series - Part 3       | instructional    | youtubevimeo       | Cap Part 3        | https://www.youtube.com/watch?v=fsSOMSTsM0o | Part 3      |                  | 1      | 15  | event      |                                          |
        | Training Series - Part 4       | instructional    | youtubevimeo       | Cap Part 4        | https://www.youtube.com/watch?v=QIobikJiTuU | Part 4      |                  | 1      | 16  | event      |                                          |
      And "topic" terms:
        | name       |
        | technology |
        | hr         |
      And "top_level_group" terms:
        | name     |
        | toplevel |
        | sports   |

@api @javascript
Scenario: Create a Gallery
  Given I am logged in as a user with the "content_creator" role
  When I visit "/node/add/gallery"
    And I fill in "Title" with "Behat Test Title"
    And I scroll to the bottom
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
    And I wait 2 seconds
    And I fill in "edit-title" with "behat"
    And I press "edit-submit-gallery-browser-view"
    And I wait for AJAX to finish
    And I should not see the text "Free Ice Cream Today"
    And I should not see the text "Just Puppy Image"
    And I press "edit-submit"
    And I switch to the main window
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
    And I wait 2 seconds
    And I select "event" from "Tags"
    And I press "edit-submit-gallery-browser-view"
    And I wait for AJAX to finish
    And I should not see the text "BEHAT Rabbit Image"
    And I should not see the text "BEHAT Bird Image"
    And I should not see the text "BEHAT Cat Image"
    And I should not see the text "BEHAT Dog Image"
    And I should not see the text "Just Puppy Image"
    And I should see the text "Free Ice Cream Today"
    And I press "edit-submit"
    And I wait 2 seconds
    And I switch to the main window
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
    And I wait 2 seconds
    And I click on the element with css selector "#edit-entity-browser-select-node1"
    And I click on the element with css selector "#edit-entity-browser-select-node2"
    And I click on the element with css selector "#edit-entity-browser-select-node3"
    And I click on the element with css selector "#edit-entity-browser-select-node4"
    And I click on the element with css selector "#edit-entity-browser-select-node5"
    And I click on the element with css selector "#edit-submit"
    And I wait 2 seconds
    And I switch to the main window
    And I press "Save"
  Then I should see the link "Behat Test Title"
    And I visit "/gallery/behat-test-title"
    And "BEHAT Bird Image" should precede "BEHAT Rabbit Image" for the query "//div[contains(@class, 'media-box-title')]"
    And "BEHAT Rabbit Image" should precede "BEHAT Cat Image" for the query "//div[contains(@class, 'media-box-title')]"
    And "BEHAT Cat Image" should precede "BEHAT Dog Image" for the query "//div[contains(@class, 'media-box-title')]"
  When I visit "/gallery/behat-test-title/edit"
    And I scroll to the bottom
    And I drag image "BEHAT Bird Image" onto "BEHAT Rabbit Image"
    And I press "Save"
  Then I am logged in as a user with the "Authenticated user" role
    And I visit "/gallery/behat-test-title/"
    And "BEHAT Rabbit Image" should precede "BEHAT Bird Image" for the query "//div[contains(@class, 'media-box-title')]"
    And "BEHAT Bird Image" should precede "BEHAT Cat Image" for the query "//div[contains(@class, 'media-box-title')]"
    And "BEHAT Cat Image" should precede "BEHAT Dog Image" for the query "//div[contains(@class, 'media-box-title')]"
    And I should see the text "Just Puppy Image"
    And I fill in "mbox-search" with "behat"
    And I wait 2 seconds
    And I should not see the text "Just Puppy Image"
    And I click on the element with css selector "button[data-title='cat caption']"
    And I should see the text "cat caption" in the "image_popup" region
    And I press "Previous (Left arrow key)"
    And I should see the text "bird caption" in the "image_popup" region
    And I press "Previous (Left arrow key)"
    And I should see the text "rabbit caption" in the "image_popup" region
    And I press "Next (Right arrow key)"
    And I should see the text "bird caption" in the "image_popup" region
    And I press "Next (Right arrow key)"
    And I should see the text "cat caption" in the "image_popup" region
    And I press "Next (Right arrow key)"
    And I should see the text "dog caption" in the "image_popup" region

@api @javascript
Scenario Outline: Check Gallery Title and Caption
  Given I am logged in as a user with the "content_creator" role
  When I visit "/node/add/gallery"
    And I fill in "Title" with "Behat Test Title"
    And I scroll to the bottom
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
    And I wait 2 seconds
    And I click on the element with css selector "#edit-entity-browser-select-node1"
    And I click on the element with css selector "#edit-entity-browser-select-node4"
    And I click on the element with css selector "#edit-submit"
    And I wait 2 seconds
    And I switch to the main window
    And I click on the element with css selector "<Title_Checkbox>"
    And I click on the element with css selector "<Caption_Checkbox>"
    And I press "Save"
  Then I visit "/gallery/behat-test-title"
    And I wait 1 seconds
    And I should <img_title_flag> the text "BEHAT Bird Image"
    And I should <img_caption_flag> the text "bird caption"
    And I should <vid_title_flag> the text "BEHAT Dog Image"
    And I should <vid_caption_flag> the text "dog caption"
    And I click on the element with css selector "div.graphic:nth-child(2) > div:nth-child(1) > button:nth-child(2)"
    And I should <img_caption_flag> the text "bird caption"
    And I press "Next (Right arrow key)"
    And I should <vid_caption_flag> the text "dog caption"

    Examples:
      | Title_Checkbox                      | Caption_Checkbox                      | img_title_flag | img_caption_flag | vid_title_flag | vid_caption_flag |
      | #edit-status-value                  | #edit-status-value                    | see            | see              | see            | see              |
      | #edit-field-show-media-titles-value | #edit-field-show-media-captions-value | not see        | not see          | not see        | not see          |
      | #edit-field-show-media-titles-value | #edit-status-value                    | not see        | see              | not see        | see              |
      | #edit-status-value                  | #edit-field-show-media-captions-value | see            | not see          | see            | not see          |

@api @javascript
Scenario Outline: Link From Video Popup To The Transcript On Related Video
  Given "gallery" content:
    | title         | body           | field_media |
    | BEHAT Gallery | This is a test | <video>     |
    And I am logged in as a user with the "Authenticated user" role
  When I visit "/gallery/behat-gallery"
    And I wait 2 seconds
    And I should see "<caption>"
    And I click on the element with css selector ".media-box-image"
  Then I should see the link "Link to Transcript"
  When I click "Link to Transcript"
  Then I should see the heading "<heading>"
    And I click the "#accordion-transcript" element
    And I wait 1 seconds
    And I should see the text "<transcript>"

    Examples:
      | video                          | caption       | heading                        | transcript       |
      | Behat Training Video           | Behat Caption | Behat Training Video           | airforce         |
      | Sign Up For Benefits By Friday | Wowza Caption | Sign Up For Benefits By Friday | wowza transcript |

@api @javascript
Scenario Outline: Video WithOut Transcript Does Not Show Link To Related Video
  Given "gallery" content:
    | title         | body            | field_media |
    | BEHAT Gallery | This is a test  | <video>     |
    And I am logged in as a user with the "Authenticated user" role
  When I visit "/gallery/behat-gallery"
    And I scroll to the bottom
  Then I should see "No Transcript"
    And I click on the element with css selector ".media-box-image"
    And I should not see the link "Link to Transcript"

    Examples:
      | video                          |
      | Behat Video With No Transcript |
      | Wowza With No Transcript       |

@api @javascript
Scenario: Gallery slideshow has a Close button
  Given "gallery" content:
    | title                | body        | field_media                          |
    | Behat Training Video | Behat Video | Behat Training Video                 |
    | BEHAT Image          | Behat Image | BEHAT Bird Image, BEHAT Rabbit Image |
    And I am logged in as a user with the "content_approver" role
  When I visit "/gallery/behat-training-video"
    And I click on the element with css selector ".media-box-image"
    And I wait 2 seconds
    And I should see the text "Link to Transcript"
    And I press the "×" button
    And I wait 2 seconds
  Then I should not see the text "Link to Transcript"
    And I visit "/gallery/behat-image"
    And I click on the element with css selector ".media-box-image"
    And I wait 2 seconds
    And I should see the text "1 of 2"
    And I press the "×" button
    And I wait 2 seconds
    And I should not see the text "1 of 2"

@api @javascript
Scenario: Create LinkIt Link to Gallery
  Given I am logged in as a user with the "content_approver" role
    And "gallery" content:
      | title                  | body            | field_media                                                 | nid      |
      | BEHAT Video and Images | Body of gallery | Behat Training Video, BEHAT Bird Image, BEHAT Rabbit Image  | 10032019 |
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "BEHAT Gallery LinkIt Article"
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
    And I fill in "URL" with "/node/10032019"
    And I click "Save" on the modal "Add Link"
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I fill in "Display Text" with "BEHAT Gallery"
    And I press the "OK" button
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Policy" from "Article Type"
    And I select "hr" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I should see the heading "BEHAT Gallery LinkIt Article"
    And I should see the link "BEHAT Gallery"
  When I click "BEHAT Gallery"
  Then I should see the heading "BEHAT Video and Images"
    And I should see the text "Behat Training Video"
    And I should see the text "BEHAT Rabbit Image"
    And I should see the text "BEHAT Bird Image"

@api @javascript
Scenario: Ordering Gallery Image Nodes
  Given I am logged in as a user with the "content_creator" role
  When I visit "/node/add/gallery"
    And I fill in "Title" with "Behat Test Gallery"
    And I scroll to the bottom
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
    And I click on the element with css selector "#edit-entity-browser-select-node1"
    And I click on the element with css selector "#edit-entity-browser-select-node2"
    And I click on the element with css selector "#edit-entity-browser-select-node3"
    And I click on the element with css selector "#edit-entity-browser-select-node4"
    And I click on the element with css selector "#edit-entity-browser-select-node5"
    And I click on the element with css selector "#edit-submit"
    And I wait 2 seconds
    And I switch to the main window
    And I drag image "BEHAT Rabbit Image" onto "BEHAT Bird Image"
    And I drag image "BEHAT Cat Image" onto "BEHAT Rabbit Image"
    And I press "Save"
  Then I should see the link "Behat Test Gallery"
    And "BEHAT Rabbit Image" should precede "BEHAT Bird Image" for the query "//div[contains(@class, 'media-box-title')]"
    And "BEHAT Cat Image" should precede "BEHAT Rabbit Image" for the query "//div[contains(@class, 'media-box-title')]"
    And "BEHAT Bird Image" should precede "BEHAT Dog Image" for the query "//div[contains(@class, 'media-box-title')]"
    And "BEHAT Dog Image" should precede "Just Puppy Image" for the query "//div[contains(@class, 'media-box-title')]"
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/gallery/behat-test-gallery"
    And I wait 2 seconds
  Then "BEHAT Rabbit Image" should precede "BEHAT Bird Image" for the query "//div[contains(@class, 'media-box-title')]"
    And "BEHAT Cat Image" should precede "BEHAT Rabbit Image" for the query "//div[contains(@class, 'media-box-title')]"
    And "BEHAT Bird Image" should precede "BEHAT Dog Image" for the query "//div[contains(@class, 'media-box-title')]"
    And "BEHAT Dog Image" should precede "Just Puppy Image" for the query "//div[contains(@class, 'media-box-title')]"
  When I click on the element with css selector "button[data-title='rabbit caption']"
  Then I should see the text "rabbit caption" in the "image_popup" region
  When I press "Next (Right arrow key)"
  Then I should see the text "bird caption" in the "image_popup" region
  When I press "Next (Right arrow key)"
  Then I should see the text "dog caption" in the "image_popup" region
  When I press "Next (Right arrow key)"
  Then I should see the text "puppy caption" in the "image_popup" region
  When I press "Next (Right arrow key)"
  Then I should see the text "cat caption" in the "image_popup" region

 @api @javascript
 Scenario: Ordering Gallery Video Nodes
  Given I am logged in as a user with the "content_creator" role
  When I visit "/node/add/gallery"
    And I fill in "Title" with "Behat Test Gallery"
    And I scroll to the bottom
    And I press the "Add existing node" button
    And I wait for AJAX to finish
    And I press the "Select Items" button
    And I wait for AJAX to finish
    And I switch to the iframe "entity_browser_iframe_gallery_browser"
    And I click on the element with css selector "#edit-entity-browser-select-node13"
    And I click on the element with css selector "#edit-entity-browser-select-node14"
    And I click on the element with css selector "#edit-entity-browser-select-node15"
    And I click on the element with css selector "#edit-entity-browser-select-node16"
    And I click on the element with css selector "#edit-submit"
    And I wait 2 seconds
    And I switch to the main window
  Then "Training Series - Part 1" should precede "Training Series - Part 2" for the query "//td[contains(@class, 'inline-entity-form-node-label')]"
    And "Training Series - Part 2" should precede "Training Series - Part 3" for the query "//td[contains(@class, 'inline-entity-form-node-label')]"
    And "Training Series - Part 3" should precede "Training Series - Part 4" for the query "//td[contains(@class, 'inline-entity-form-node-label')]"
  When I drag image "Training Series - Part 1" onto "Training Series - Part 3"
    And I drag image "Training Series - Part 3" onto "Training Series - Part 2"
    And I press "Save"
  Then I should see the link "Behat Test Gallery"
    And "Training Series - Part 2" should precede "Training Series - Part 1" for the query "//div[contains(@class, 'media-box-title')]"
    And "Training Series - Part 3" should precede "Training Series - Part 2" for the query "//div[contains(@class, 'media-box-title')]"
    And "Training Series - Part 1" should precede "Training Series - Part 4" for the query "//div[contains(@class, 'media-box-title')]"
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/gallery/behat-test-gallery"
    And I wait 2 seconds
  Then "Training Series - Part 2" should precede "Training Series - Part 1" for the query "//div[contains(@class, 'media-box-title')]"
    And "Training Series - Part 3" should precede "Training Series - Part 2" for the query "//div[contains(@class, 'media-box-title')]"
    And "Training Series - Part 1" should precede "Training Series - Part 4" for the query "//div[contains(@class, 'media-box-title')]"
  When I scroll to the top
    And I click on the element with css selector "button[mfp-alt='Training Series - Part 3']"
    And I press "Next (Right arrow key)"
  Then I should see the text "Cap Part 2" in the "image_popup" region
  When I press "Next (Right arrow key)"
  Then I should see the text "Cap Part 1" in the "image_popup" region
  When I press "Next (Right arrow key)"
  Then I should see the text "Cap Part 4" in the "image_popup" region
  When I press "Next (Right arrow key)"
  Then I should see the text "Cap Part 3" in the "image_popup" region
