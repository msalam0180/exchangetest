Feature: Use WYSIWYG editor
  As a content creator
  I need to be able to use a WYSIWYG editor
  So I can format the content of my pages

  Background:
    Given "image" content:
      | title        | field_alt_text   | field_image_upload     |
      | Default Bird | This is a bird.  | image;behat-bird.gif   |
      | Left Rabbit  | This is a rabbit | image;behat-rabbit.jpg |
      | Center Cat   | This is a cat    | image;behat-cat.png    |
      | Right Dog    | This is a dog    | image;behat-dog.jpeg   |
      And "topic" terms:
        | name       |
        | technology |
        | hr         |
      And "top_level_group" terms:
        | name     |
        | toplevel |
        | sports   |

  @api @javascript
  Scenario Outline: Basic Formatting in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Testing WYSIWYG"
      And I scroll "#edit-body-wrapper" into view
      And I press "<Action>" in the "Body" WYSIWYG Toolbar
      And I type "Testing body" in the "Body" WYSIWYG editor
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
    Then I should see "Testing body" in the "<Element>" element

    Examples:
      | Action    | Element |
      | Bold      | strong  |
      | Underline | u       |
      | Italic    | p > em  |

  @api @javascript
  Scenario: Add Link in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Testing WYSIWYG"
      And I scroll "#edit-body-wrapper" into view
      And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I fill in "URL*" with "http://www.google.com"
      And I click "OK"
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
    Then I should see the link "http://www.google.com"

  @api @javascript
  Scenario: Add Non Existing Node via LinkIt in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Testing WYSIWYG"
      And I scroll "#edit-body-wrapper" into view
      And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
      And I fill in "URL" with "/node/987654321"
      And I click "Save" on the modal "Add Link"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
    Then I should see the heading "BEHAT Testing WYSIWYG"
      And I should see the link "/node/987654321"
      But I should not see the text "The website encountered an unexpected error. Please try again later."

  @api @javascript
  Scenario: Embed Content Image in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
      And I visit "/node/add/image"
      And I fill in "Title" with "BEHAT Image Test"
      And I attach the file "behat-bird.gif" to "Image Upload"
      And I wait 2 seconds
      And I wait for ajax to finish
      And I fill in "Alternative text" with "bird image"
      And I press "Save"
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Testing Image Embed"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Image Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "BEHAT Image Test" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I click "Embed" on the modal "Embed content item"
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
    Then I should see the "img" element with the "alt" attribute set to "bird image" in the "image" region

  @api @javascript
  Scenario: Embed Youtube Content Video in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
      And "video" content:
      | title            | field_video                                | status |
      | BEHAT Test Video | http://www.youtube.com/watch?v=xf9BpXOtMcc | 1      |
    When  I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Testing Video Embed"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Video Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "BEHAT Test Video" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I click "Embed" on the modal "Embed content item"
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
      And I should see a video player
    Then I should see the "http://www.youtube.com/watch?v=xf9BpXOtMcc" in the "YouTube" player

  @api @javascript
  Scenario: Embed Vimeo Content Video in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
      And "video" content:
      | title               | field_video_type | field_video_origin | field_video                 | field_media_id | body        | field_transcript | status | created |
      | Vigil Held for 9/11 | guest_speaker    | youtubevimeo       | https://vimeo.com/159251193 |                | Body text 6 | Transcript 6     | 1      | -4 day  |
    When  I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Testing Video Embed"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Video Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "Vigil Held for 9/11" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I click "Embed" on the modal "Embed content item"
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
      And I should see a video player
    Then I should see the "https://vimeo.com/159251193" in the "Vimeo" player

  @api @javascript
  Scenario: Embed Wowza Content Video in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
      And "video" content:
      | title                          | field_video_type | field_video_origin | field_media_id                             | body            | field_transcript | status | created |
      | Sign Up For Benefits By Friday | instructional    | Wowza              | https://www.w3schools.com/html/mov_bbb.mp4 | Behat Mogadishu | Transcript 2     | 1      | now     |
      | Impacts from the Hurricane     | town_hall        | Wowza              | https://www.w3schools.com/html/mov_bbb.mp4 | Body text 5     | Transcript 5     | 1      | -2 day  |
    When  I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Testing Wowza Video Embed"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Video Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "Impacts from the Hurricane " on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I click "Embed" on the modal "Embed content item"
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
    Then I should see the heading "BEHAT Testing Wowza Video Embed"
      And I should see a video player
      # commenting out the below steps for now as wowza video doesn't work outside network current but will once we move into sec network
      # And I play the video
      # And I should see the video playing

  @api @javascript
  Scenario: Embed Content Static File in WYSIWYG
    Given I am logged in as a user with the "content_creator" role
      And "file" content:
      | title           | field_description_abstract                          | field_retain_disposal_date | field_file_upload    | nid      |
      | BEHAT File Test | This is a description and abstract about this file. | +1 day                     | file;behat-form1.pdf | 98765432 |
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Testing WYSIWYG"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Node" in the "Body" WYSIWYG Toolbar
      And I should see the modal "Select content item to embed"
      And I fill in "BEHAT File Test" for "Title" in the "modal" region
      And I click "Next" on the modal "Select content item to embed"
    Then I should see the text 'There are no content items matching "BEHAT File Test".'
    When I fill in "/node/98765432" for "Title" in the "modal" region
      And I click "Next" on the modal "Select content item to embed"
    Then I should see the text 'There are no content items matching "/node/98765432".'

  @api @javascript
  Scenario: Embed Large Image Size Test in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
      And "image" content:
      | title                       | field_alt_text             | field_image_upload              |
      | BEHAT Large Image Size Test | This is a picture of a dog | image;behat-test_shiba_snow.jpg |
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Testing Large Image Size Embed"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Image Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "BEHAT Large Image Size Test" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Original size" from "Display as"
      And I wait 2 seconds
      And I click "Embed" on the modal "Embed content item"
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
    Then I should see the "img" element with the "width" attribute set to "700" in the "image" region
      And I should see the "img" element with the "height" attribute set to "875" in the "image" region

  @api @javascript
  Scenario: Embed Small Image Size Test in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
      And "image" content:
      | title                       | field_alt_text               | field_image_upload               |
      | BEHAT Small Image Size Test | This is a picture of a puppy | image;behat-test_shiba_puppy.jpg |
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Testing Small Image Size Embed"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Image Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "BEHAT Small Image Size Test" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Original size" from "Display as"
      And I wait 2 seconds
      And I click "Embed" on the modal "Embed content item"
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
    Then I should see the "img" element with the "width" attribute set to "200" in the "image" region
      And I should see the "img" element with the "height" attribute set to "250" in the "image" region

  @api @javascript
  Scenario: Embed Small Video Size Test in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
    When I visit "/node/add/video"
      And I fill in "Title" with "The $20 Billion Dollar Holiday"
      And I select "YouTube or Vimeo" from "Video Origin"
      And I fill in "YouTube/Vimeo Link" with "https://www.youtube.com/watch?v=mdD4tw5AXOE"
      And I type "A Look at Valentines Day" in the "Body" WYSIWYG editor
      And I fill in "Video Running Time" with "00:08:47"
      And I select "sports" from "Top Level Group"
      And I select "hr" from "Topic"
      And I publish it
      And I visit "/node/add/sec_article"
      And I fill in "Title" with "$20 Billion Dollars?!?"
      And I type "Valentines Day" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Video Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "The $20 Billion Dollar Holiday" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Small Embed" from "Display as"
      And I wait for ajax to finish
      And I click "Embed" on the modal "Embed content item"
      And I scroll to the top
      And I click "Exchange Details"
      And I select "hr" from "Topic"
      And I select "sports" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
    Then I should see the "div" element with the "data-entity-embed-display" attribute set to "view_mode:node.small_embed" in the "content" region
      And I should see the "div" element with the "class" attribute set to "node--view-mode-small-embed" in the "content" region

  @api @javascript
  Scenario: Embed Medium Video Size Test in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
    When I visit "/node/add/video"
      And I fill in "Title" with "The $20 Billion Dollar Holiday"
      And I select "YouTube or Vimeo" from "Video Origin"
      And I fill in "YouTube/Vimeo Link" with "https://www.youtube.com/watch?v=mdD4tw5AXOE"
      And I type "A Look at Valentines Day" in the "Body" WYSIWYG editor
      And I fill in "Video Running Time" with "00:08:47"
      And I select "toplevel" from "Top Level Group"
      And I select "technology" from "Topic"
      And I publish it
      And I visit "/node/add/sec_article"
      And I fill in "Title" with "$20 Billion Dollars?!?"
      And I type "Valentines Day" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Video Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "The $20 Billion Dollar Holiday" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Medium Embed" from "Display as"
      And I wait for ajax to finish
      And I click "Embed" on the modal "Embed content item"
      And I scroll to the top
      And I click "Exchange Details"
      And I select "hr" from "Topic"
      And I select "sports" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
    Then I should see the "div" element with the "class" attribute set to "node--view-mode-medium-embed" in the "content" region
      And I should see the "div" element with the "data-entity-embed-display" attribute set to "view_mode:node.medium_embed" in the "content" region

  @api @javascript
  Scenario: Embed Large Video Size Test in WYSIWYG
    Given I am logged in as a user with the "content_approver" role
    When I visit "/node/add/video"
      And I fill in "Title" with "The $20 Billion Dollar Holiday"
      And I select "YouTube or Vimeo" from "Video Origin"
      And I fill in "YouTube/Vimeo Link" with "https://www.youtube.com/watch?v=mdD4tw5AXOE"
      And I type "A Look at Valentines Day" in the "Body" WYSIWYG editor
      And I fill in "Video Running Time" with "00:08:47"
      And I select "toplevel" from "Top Level Group"
      And I select "technology" from "Topic"
      And I publish it
      And I am logged in as a user with the "content_approver" role
      And I visit "/node/add/sec_article"
      And I fill in "Title" with "$20 Billion Dollars?!?"
      And I type "Valentines Day" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Video Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "The $20 Billion Dollar Holiday" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Large Embed" from "Display as"
      And I wait for ajax to finish
      And I click "Embed" on the modal "Embed content item"
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
    Then I should see the "div" element with the "class" attribute set to "node--view-mode-large-embed" in the "content" region
      And I should see the "div" element with the "data-entity-embed-display" attribute set to "view_mode:node.large_embed" in the "content" region

  @api @javascript
  Scenario Outline: WYSIWYG Bold Formatting In Maximize Mode
    Given I am logged in as a user with the "<Roles>" role
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "Testing if bold button works in full screen mode"
      And I scroll "#edit-body-wrapper" into view
      And I press "Maximize" in the "Body" WYSIWYG Toolbar
      And I wait 1 seconds
      And I press "Bold" in the "Body" WYSIWYG Toolbar
      And I type "Bold Text in Full Screen Mode " in the "Body" WYSIWYG editor
      And I press "Bold" in the "Body" WYSIWYG Toolbar
      And I type "Unbold Text " in the "Body" WYSIWYG editor
      And I press "Maximize" in the "Body" WYSIWYG Toolbar
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll to the top
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I press "Save and Create New Draft"
    Then I should see the text "Testing if bold button works in full screen mode"
      And I should see "Bold Text in Full Screen Mode" in the "strong" element
      And I should see "Unbold Text" in the "div > p" element

    Examples:
      | Roles            |
      | content_creator  |
      | content_approver |

  @api @javascript
  Scenario: Image Embed To Be Non-clickable On Published Content
    # Create Image file & Embed Image in Article
    Given "image" content:
      | title               | field_alt_text             | field_image_upload  |
      | BEHAT Testing Image | This is a picture of a cat | image;behat-cat.png |
      And "sec_article" content:
        | title                | moderation_state | status | body             | edit-field-source-wrapper | field_source             | field_topic | field_top_level_group |
        | This is the BEHAT v1 | published        | 1      | This is the body | This is the source field  | This is the source field | hr          | toplevel              |
    When I am logged in as a user with the "content_approver" role
      And I visit "/behat-v1/edit"
      And I wait 1 seconds
      And I scroll "#edit-body-wrapper" into view
      And I press "Image Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "BEHAT Testing Image" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Original size" from "Display as"
      And I wait for ajax to finish
      And I click "Embed" on the modal "Embed content item"
      And I scroll to the bottom
      And I publish it
    # Assert html attributes to allow clickabilty of Image link no longer present on page/region
    Then I should see the "img" element with the "alt" attribute set to "Behat test image" in the "content" region
      And I should not see the "a" element in the "image" region

  @api @javascript
  Scenario: Image Embed With LinkIt - Validate Image Does Not Link To Itself
    Given "image" content:
      | title               | field_alt_text              | field_image_upload   |
      | BEHAT Testing Image | This is a picture of a bird | image;behat-bird.gif |
      And "sec_article" content:
        | title                        | moderation_state | status | body             | edit-field-source-wrapper | field_source             | field_topic | field_top_level_group |
        | This is main Article BEHAT   | published        | 1      | This is the body | This is the source field  | This is the source field | hr          | toplevel              |
        | This is linked Article BEHAT | published        | 1      | This is the body | This is the source field  | This is the source field | hr          | toplevel              |
    When I am logged in as a user with the "content_approver" role
      And I visit "/main-article-behat/edit"
      And I wait 1 seconds
      And I scroll "#edit-body-wrapper" into view
      And I press "Image Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "BEHAT Testing Image" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Original size" from "Display as"
      And I wait 1 seconds
      And I click "Embed" on the modal "Embed content item"
      And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
      And I fill in "URL" with "/linked-article-behat"
      And I click "Save" on the modal "Add Link"
      And I wait for ajax to finish
      And I publish it
      And I click "Behat test image"
    Then I should see the heading "This is linked Article BEHAT"

  @api @javascript
  Scenario: Image Embed With External Link - Validate Image Does Not Link To Itself
    Given "image" content:
      | title               | field_alt_text              | field_image_upload   |
      | BEHAT Testing Image | This is a picture of a bird | image;behat-bird.gif |
      And "sec_article" content:
        | title                        | moderation_state | status | body             | edit-field-source-wrapper | field_source             | field_topic | field_top_level_group |
        | This is main Article BEHAT   | published        | 1      | This is the body | This is the source field  | This is the source field | hr          | toplevel              |
        | This is linked Article BEHAT | published        | 1      | This is the body | This is the source field  | This is the source field | hr          | toplevel              |
    When I am logged in as a user with the "content_approver" role
      And I visit "/main-article-behat/edit"
      And I wait 1 seconds
      And I scroll "#edit-body-wrapper" into view
      And I press "Image Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "BEHAT Testing Image" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Original size" from "Display as"
      And I wait 1 seconds
      And I click "Embed" on the modal "Embed content item"
      And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
      And I fill in "URL*" with "https://www.google.com"
      And I press "OK"
      And I publish it
      And I click "Behat test image"
    Then the link should open in a new tab
      And I should see the "Google Search" button
      And I close the current window

  @api @javascript
  Scenario Outline: Image Default Embed Alignments
    Given I am logged in as a user with the "Content Approver" role
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Image Default Embed Alignment"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Image Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "<Title>" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Default Embed" from "Display as"
      And I select the radio button "<Location>"
      And I click "Embed" on the modal "Embed content item"
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
      And I am logged in as a user with the "authenticated" role
      And I visit "/behat-image-default-embed-alignment"
    Then I should see the "div" element with the "data-entity-embed-display" attribute set to "view_mode:node.default_embed" in the "content" region
      And I should see the "div" element with the "class" attribute set to "<Alignment>" in the "content" region

    Examples:
      | Title        | Location | Alignment                    |
      | Left Rabbit  | Left     | embedded-entity align-left   |
      | Right Dog    | Right    | embedded-entity align-right  |
      | Center Cat   | Center   | embedded-entity align-center |
      | Default Bird | None     | embedded-entity              |

  @api @javascript
  Scenario Outline: Image Full Width Embed Alignments
    Given I am logged in as a user with the "Content Approver" role
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Image Full Width Embed Alignment"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Image Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "<Title>" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Full Width Embed" from "Display as"
      And I select the radio button "<Location>"
      And I click "Embed" on the modal "Embed content item"
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
      And I am logged in as a user with the "authenticated" role
      And I visit "/behat-image-full-width-embed-alignment"
    Then I should see the "div" element with the "data-entity-embed-display" attribute set to "view_mode:node.full_width_embed" in the "content" region
      And I should see the "div" element with the "class" attribute set to "<Alignment>" in the "content" region

    Examples:
      | Title        | Location | Alignment                    |
      | Left Rabbit  | Left     | embedded-entity align-left   |
      | Right Dog    | Right    | embedded-entity align-right  |
      | Center Cat   | Center   | embedded-entity align-center |
      | Default Bird | None     | embedded-entity              |

  @api @javascript
  Scenario Outline: Image Original Size Embed Alignments
    Given I am logged in as a user with the "Content Approver" role
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Image Original Size Embed Alignment"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Image Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "<Title>" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Original size" from "Display as"
      And I select the radio button "<Location>"
      And I click "Embed" on the modal "Embed content item"
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
      And I am logged in as a user with the "authenticated" role
      And I visit "/behat-image-original-size-embed-alignment"
    Then I should see the "div" element with the "data-entity-embed-display" attribute set to "view_mode:node.original_size" in the "content" region
      And I should see the "div" element with the "class" attribute set to "<Alignment>" in the "content" region

    Examples:
      | Title        | Location | Alignment                    |
      | Left Rabbit  | Left     | embedded-entity align-left   |
      | Right Dog    | Right    | embedded-entity align-right  |
      | Center Cat   | Center   | embedded-entity align-center |
      | Default Bird | None     | embedded-entity              |

  @api @javascript
  Scenario Outline: Image Teaser Embed Alignments
    Given I am logged in as a user with the "Content Approver" role
    When I visit "/node/add/sec_article"
      And I fill in "Title" with "BEHAT Image Teaser Embed Alignment"
      And I type "This is a source" in the "Source" WYSIWYG editor
      And I scroll "#edit-body-wrapper" into view
      And I press "Image Embed" in the "Body" WYSIWYG Toolbar
      And I select the first autocomplete option for "<Title>" on the "Title" field on a modal
      And I click "Next" on the modal "Select content item to embed"
      And I select "Teaser" from "Display as"
      And I select the radio button "<Location>"
      And I click "Embed" on the modal "Embed content item"
      And I click "Exchange Details"
      And I select "technology" from "Topic"
      And I select "toplevel" from "Top Level Group"
      And I scroll to the bottom
      And I publish it
      And I am logged in as a user with the "authenticated" role
      And I visit "/behat-image-teaser-embed-alignment"
    Then I should see the "div" element with the "data-entity-embed-display" attribute set to "view_mode:node.teaser" in the "content" region
      And I should see the "div" element with the "class" attribute set to "<Alignment>" in the "content" region

    Examples:
      | Title        | Location | Alignment                    |
      | Left Rabbit  | Left     | embedded-entity align-left   |
      | Right Dog    | Right    | embedded-entity align-right  |
      | Center Cat   | Center   | embedded-entity align-center |
      | Default Bird | None     | embedded-entity              |

  @api @javascript
  Scenario: LinkIt With Unpublished Nodes
    Given "sec_article" content:
      | title         | body   | status | Published_Date      | moderation_state | field_source             | field_topic | field_top_level_group |
      | SEC Article 1 | Body 1 | 0      |                     | draft            |                          |             |                       |
      | SEC Article 2 | Body 2 | 1      | 2017-08-11 12:00:00 | published        |                          |             |                       |
      | SEC Article 3 | Body 3 | 0      | 2017-08-11 12:00:00 | archived         |                          |             |                       |
      | SEC Article 4 | Body 4 | 0      |                     | draft            | This is the source field | hr          | sports                |
    When I am logged in as a user with the "Content Creator" role
    # Changing moderation state of SEC Article 4 from draft status to needs_review
      And I am on "/sec-article-4/edit"
      And I press the "List additional actions" button
      And I press "Save and Request Review"
    # Checking for published nodes for LinkIt
      And I am on "/node/add/sec_article"
      And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
      And I wait for ajax to finish
      And I view the linkit autocomplete option for "SEC Article" on the "URL" field in the "modal" region
      And I wait for ajax to finish
    Then I should see the text "SEC Article 2" in the "modal" region
      And I should see the text "/sec-article-2" in the "modal" region
      And I should not see the text "SEC Article 1" in the "modal" region
      And I should not see the text "SEC Article 3" in the "modal" region
      And I should not see the text "SEC Article 4" in the "modal" region
