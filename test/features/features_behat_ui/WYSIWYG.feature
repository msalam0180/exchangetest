Feature: WDIO View Use WYSIWYG editor
  As a content creator
  I need to be able to Embed Images using a WYSIWYG editor
  So I can display images as part of content

Background:
  Given "image" content:
    | title       | field_alt_text   | field_image_upload     |
    | Poor Bird   | This is a bird   | image;behat-bird.gif   |
    | Poor Rabbit | This is a rabbit | image;behat-rabbit.jpg |
    | Poor Cat    | This is a cat    | image;behat-cat.png    |
    | Poor Dog    | This is a dog    | image;behat-dog.jpeg   |
    And "topic" terms:
      | name       |
      | technology |
    And "top_level_group" terms:
      | name     |
      | toplevel |

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Default Embed No Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Default Embed No Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Dog" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Default Embed" from "Display as"
    And I select the radio button "None"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_default_no_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Default Embed Left Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Default Embed Left Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Dog" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Default Embed" from "Display as"
    And I select the radio button "Left"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_default_left_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Default Embed Center Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Default Embed Center Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Dog" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Default Embed" from "Display as"
    And I select the radio button "Center"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_default_center_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Default Embed Right Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Default Embed Right Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Dog" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Default Embed" from "Display as"
    And I select the radio button "Right"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_default_right_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Full Width Embed No Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Full Width Embed No Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Bird" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Full Width Embed" from "Display as"
    And I select the radio button "None"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_fw_no_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Full Width Embed Left Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Full Width Embed Left Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Bird" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Full Width Embed" from "Display as"
    And I select the radio button "Left"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_fw_left_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Full Width Embed Center Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Full Width Embed Center Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Bird" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Full Width Embed" from "Display as"
    And I select the radio button "Center"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_fw_center_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Full Width Embed Right Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Full Width Embed Right Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Bird" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Full Width Embed" from "Display as"
    And I select the radio button "Right"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_fw_right_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Original Size Embed No Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Original Size Embed No Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Cat" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Original size" from "Display as"
    And I select the radio button "None"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_org_no_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Original Size Embed Left Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Original Size Embed Left Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Cat" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Original size" from "Display as"
    And I select the radio button "Left"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_org_left_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Original Size Embed Center Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Original Size Embed Center Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Cat" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Original size" from "Display as"
    And I select the radio button "Center"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_org_center_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Original Size Embed Right Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Original Size Embed Right Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Cat" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Original size" from "Display as"
    And I select the radio button "Right"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_org_right_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Teaser Embed No Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Teaser Embed No Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Rabbit" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Teaser" from "Display as"
    And I select the radio button "None"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_teaser_no_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Teaser Embed Left Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Teaser Embed Left Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Rabbit" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Teaser" from "Display as"
    And I select the radio button "Left"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_teaser_left_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Teaser Embed Center Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Teaser Embed Center Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Rabbit" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Teaser" from "Display as"
    And I select the radio button "Center"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_teaser_center_alignment" tag

@api @javascript @ui @wdio @image_embed
Scenario: WDIO Image Teaser Embed Right Alignment
  Given I am logged in as a user with the "Content Approver" role
  When I visit "/node/add/sec_article"
    And I fill in "Title" with "WDIO Image Teaser Embed Right Alignment"
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Image Embed" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Poor Rabbit" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I select "Teaser" from "Display as"
    And I select the radio button "Right"
    And I click "Embed" on the modal "Embed content item"
    And I click "Exchange Details"
    And I select "technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I take a screenshot using "wysiwyg.feature" file with "@image_teaser_right_alignment" tag
