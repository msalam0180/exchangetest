Feature: Create and View Image Content
  As a Content Creator to the Insider
  I want to be able to add images
  So that I can add visual interest to information on Insider

@api @javascript
Scenario Outline: Test valid image formats
  Given I am logged in as a user with the "Content Creator" role
  When I visit "/node/add/image"
    And I fill in the following:
      | Title | BEHAT Testing Image |
    And I attach the file "<File>" to "Image Upload"
    And I wait for AJAX to finish
  Then I should see the "img" element with the "src" attribute set to "/system/files/styles/thumbnail/private/filefield_paths/<File>" in the "image_preview" region
    And I should see the "a" element with the "href" attribute set to "/system/files/filefield_paths/<File>" in the "image_widget" region
  When I fill in "Alternative text" with "<Alternative>"
    And I press "Save"
  Then the image src in the "image" region should match the Drupal url "<Upload>"
    And I should see the "img" element with the "alt" attribute set to "<Alternative>" in the "image" region
  When I am on "/admin/content"
    And I click "Edit" in the "BEHAT Testing Image" row
  Then I should see the "img" element with the "src" attribute set to "/files/exchange/styles/thumbnail/public/images/<File>" in the "image_preview" region
    And I should see the "a" element with the "href" attribute set to "/files/exchange/images/<File>" in the "image_widget" region

  Examples:
    | File             | Alternative       | Upload                                  |
    | behat-rabbit.jpg | This is a rabbit. | /files/exchange/images/behat-rabbit.jpg |
    | behat-dog.jpeg   | This is a dog.    | /files/exchange/images/behat-dog.jpeg   |
    | behat-cat.png    | This is a cat.    | /files/exchange/images/behat-cat.png    |
    | behat-bird.gif   | This is a bird.   | /files/exchange/images/behat-bird.gif   |

@api @javascript
Scenario: Delete an Image
  Given I am logged in as a user with the "content_approver" role
    And "image" content:
      | title            | field_alt_text             | field_image_upload   |
      | BEHAT Image Test | This is a picure of a bird | image;behat-bird.gif |
  When I visit "/admin/content"
    And I click "Edit" in the "BEHAT Image Test" row
    And I click "edit-delete"
    And I press the "Delete" button
  Then I should not see the link "BEHAT Image Test"

@api @javascript
Scenario Outline: Image Thumbnail Preview
  Given I am logged in as a user with the "administrator" role
    And "image" content:
      | title                    | field_alt_text   | field_image_upload     |
      | BEHAT Image Preview GIF  | This is a picure | image;behat-bird.gif   |
      | BEHAT Image Preview JPG  | This is a picure | image;behat-rabbit.jpg |
      | BEHAT Image Preview PNG  | This is a picure | image;behat-cat.png    |
      | BEHAT Image Preview JPEG | This is a picure | image;behat-dog.jpeg   |
  When I visit "/admin/content"
    And I fill in "Title" with "<title>"
    And I press "Filter"
    And I click on the element with css selector "<selector>"
  Then I should see the heading "<heading>"

  Examples:
    | title                    | selector                         | heading                  |
    | BEHAT Image Preview GIF  | .image-style-thumbnail-sm-square | BEHAT Image Preview GIF  |
    | BEHAT Image Preview JPG  | .image-style-thumbnail-sm-square | BEHAT Image Preview JPG  |
    | BEHAT Image Preview PNG  | .image-style-thumbnail-sm-square | BEHAT Image Preview PNG  |
    | BEHAT Image Preview JPEG | .image-style-thumbnail-sm-square | BEHAT Image Preview JPEG |

@api
Scenario: Create Image As Content Creator
  Given I am logged in as a user with the "content_creator" role
  When I visit "/node/add/image"
  Then I should see the "Save" button
    And the "Published" checkbox should be checked
    And I should not see the "Save and Create New Draft" button
    And I should not see the "Save and Publish" button

@api @javascript
Scenario: Alt Text For Image Content Type
  Given I am logged in as a user with the "Content Creator" role
  When I visit "/node/add/image"
    And I fill in the following:
      | Title | BEHAT Testing Image |
    And I attach the file "behat-rabbit.jpg" to "Image Upload"
    And I wait for AJAX to finish
  Then I should see the text "Short description of the image used by screen readers and displayed when the image is not loaded. This is important for accessibility. The optimal size for alternative text is 125 characters or less, but if needed you can type up to 512 characters."
  When I fill in "Alternative text" with "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet I feel that I never was a greater artist than now. When, while the lov"
    And I press "Save"
  Then I should see the "img" element with the "alt" attribute set to "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet I feel that I never was a greater artist than now. When, while the lo" in the "image" region
