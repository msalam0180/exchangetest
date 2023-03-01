Feature: Global items
As an end user
I want to see global things
So I can know where I am

@api @javascript
Scenario Outline: Test All Menus With Internal Links
  Given I am logged in as a user with the "administrator" role
    And "sec_article" content:
    | title         | body                   |
    | BEHAT Article | This is the test body. |
  When I visit "<Add_Link>"
    And I fill in the following:
      | Menu link title | BEHAT Test Link |
    And I select the first autocomplete option for "BEHAT Article" on the "Link" field
    And I press the "Save" button
  Then I should see the text "The menu link has been saved."
    And I visit "<Menu_Page>"
    And I should see the link "BEHAT Test Link"
    And I am on the homepage
    And I should see the link "BEHAT Test Link" in the "<Region>"

  Examples:
    | Add_Link                                      | Menu_Page                                 | Region      |
    | /admin/structure/menu/manage/footer/add       | /admin/structure/menu/manage/footer       | footer      |
    | /admin/structure/menu/manage/footer-top/add   | /admin/structure/menu/manage/footer-top   | footertop   |
    | /admin/structure/menu/manage/main/add         | /admin/structure/menu/manage/main         | menu        |
    | /admin/structure/menu/manage/header-links/add | /admin/structure/menu/manage/header-links | headerlinks |

@api @javascript
Scenario Outline: Test All Menus With External Links
  Given I am logged in as a user with the "administrator" role
    And "sec_article" content:
    | title         | body                   |
    | BEHAT Article | This is the test body. |
  When I visit "<Add_Link>"
    And I fill in the following:
      | Menu link title | BEHAT Test Link       |
      | Link            | http://www.google.com |
    And I press the "Save" button
  Then I should see the text "The menu link has been saved."
    And I visit "<Menu_Page>"
    And I should see the link "BEHAT Test Link"
    And I am on the homepage
    And I should see the link "BEHAT Test Link" in the "<Region>"

  Examples:
    | Add_Link                                      | Menu_Page                                 | Region      |
    | /admin/structure/menu/manage/footer/add       | /admin/structure/menu/manage/footer       | footer      |
    | /admin/structure/menu/manage/footer-top/add   | /admin/structure/menu/manage/footer-top   | footertop   |
    | /admin/structure/menu/manage/main/add         | /admin/structure/menu/manage/main         | menu        |
    | /admin/structure/menu/manage/header-links/add | /admin/structure/menu/manage/header-links | headerlinks |

@api @javascript
Scenario Outline: Remove Links from All Menus
  Given I am logged in as a user with the "administrator" role
  When I visit "<Add_Link>"
    And I fill in the following:
      | Menu link title | BEHAT Test Link       |
      | Link            | http://www.google.com |
    And I press the "Save" button
  Then I should see the text "The menu link has been saved."
    And I visit "<Menu_Page>"
    And I click "Edit" in the "BEHAT Test Link" row
    And I click "edit-delete"
    And I press the "Delete" button
    And I should not see the link "BEHAT Test Link"
    And I am on the homepage
    And I should not see the link "BEHAT Test Link" in the "<Region>"

  Examples:
    | Add_Link                                      | Menu_Page                                 | Region      |
    | /admin/structure/menu/manage/footer/add       | /admin/structure/menu/manage/footer       | footer      |
    | /admin/structure/menu/manage/footer-top/add   | /admin/structure/menu/manage/footer-top   | footertop   |
    | /admin/structure/menu/manage/main/add         | /admin/structure/menu/manage/main         | menu        |
    | /admin/structure/menu/manage/header-links/add | /admin/structure/menu/manage/header-links | headerlinks |

@api @javascript
Scenario Outline: Edit Links in All Menus
  Given I am logged in as a user with the "administrator" role
  When I visit "<Add_Link>"
    And I fill in the following:
      | Menu link title | BEHAT Test Link       |
      | Link            | http://www.google.com |
    And I press the "Save" button
  Then I should see the text "The menu link has been saved."
    And I visit "<Menu_Page>"
    And I click "Edit" in the "BEHAT Test Link" row
    And I fill in the following:
      | Menu link title | BEHAT Test Link Two |
    And I press the "Save" button
    And I should see the text "The menu link has been saved."
    And I visit "<Menu_Page>"
    And I should see the link "BEHAT Test Link Two"
    And I am on the homepage
    And I should see the link "BEHAT Test Link Two" in the "<Region>"

  Examples:
    | Add_Link                                      | Menu_Page                                 | Region      |
    | /admin/structure/menu/manage/footer/add       | /admin/structure/menu/manage/footer       | footer      |
    | /admin/structure/menu/manage/footer-top/add   | /admin/structure/menu/manage/footer-top   | footertop   |
    | /admin/structure/menu/manage/main/add         | /admin/structure/menu/manage/main         | menu        |
    | /admin/structure/menu/manage/header-links/add | /admin/structure/menu/manage/header-links | headerlinks |

@api @javascript
Scenario: Reorder Links
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/structure/menu/manage/footer/add"
    And I fill in the following:
      | Menu link title | BEHAT Test Link       |
      | Link            | http://www.google.com |
    And I press the "Save" button
    And I visit "/admin/structure/menu/manage/footer/add"
    And I fill in the following:
      | Menu link title | BEHAT Test Link Two  |
      | Link            | http://www.yahoo.com |
    And I press the "Save" button
    And I visit "/admin/structure/menu/manage/footer/add"
    And I fill in the following:
      | Menu link title | BEHAT Test Link Three    |
      | Link            | http://www.altavista.com |
    And I press the "Save" button
    And I visit "/admin/structure/menu/manage/footer"
    And I wait 1 seconds
    And I drag menu link "BEHAT Test Link Two" onto "BEHAT Test Link"
    And I press the "Save" button
    Then "BEHAT Test Link" should precede "BEHAT Test Link Two" for the query "//a[@class='menu-item__link']"

@api
Scenario: Check Login Page
  Given I am on "/user/login"
  Then I should see the heading "Login to the Exchange" in the "login" region
    And I should see the text "Enter your The Exchange username." in the "login" region
    And I should see the "img" element with the "alt" attribute set to "The Exchange Logo" in the "headerbranding" region

@api @javascript
Scenario: Add Page Variant
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/structure/page_manager/manage/home/general"
    And I click "Add variant"
    And I should see the modal "Page variant type"
    And I fill in "label" with "Behat Home"
    And I select "Panels" from "Type"
    And I press "Next"
    And I press "Next"
    And I press "Next"
    And I press "Next"
    And I fill in "Page title" with "The Behat - Home"
    And I press "Finish"
    And I reload the page
  Then I should see the text "Behat Home"
    # Expanding and checking for the submenus links.
    And I click on the element with css selector "li.page__section_item__1:nth-child(2) > label:nth-child(1)"
    And I should see the text "General"
    And I should see the text "Contexts"
    And I should see the text "Selection criteria"
    And I should see the text "Layout"
    And I should see the text "Content"
    # Clicking on the General link
    And I click on the element with css selector "ul.active > li:nth-child(1) > label:nth-child(1)"
    And I click on the element with css selector "#edit-delete"
    And I should see the modal "Are you sure you want to delete this variant?"
    # Confirming deletion
    And I click on the element with css selector "button.button:nth-child(1)"
    And I wait for AJAX to finish
    And I should see the text "The variant Behat Home has been removed."
    And I reload the page
    And I should not see the text "Behat Home"

@api @javascript
Scenario: Order of Content Types On Add Content Page
  Given I am logged in as a user with the "administrator" role
  When I visit "/node/add"
  Then "Announcement" should precede "Article" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Article" should precede "Basic page" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Basic page" should precede "Event" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Event" should precede "Featured" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Featured" should precede "Form" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Form" should precede "Gallery" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Gallery" should precede "Image" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Image" should precede "Landing Page" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Landing Page" should precede "Library Item" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Library Item" should precede "Link" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Link" should precede "Operating Procedure" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Operating Procedure" should precede "SECR" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "SECR" should precede "Site Alert" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"
    And "Site Alert" should precede "Video" for the query "//ul[@class='admin-list']//li[@class='clearfix']//a//span[@class='label']"

@api @javascript
Scenario Outline: Check Environment Indicator
  Given I am logged in as a user with the "<role>" role
  When I visit "/"
  Then I should see the text "LOCAL LNDO" in the "env_indicator" region
    And I should see the "div" element with the "style" attribute set to "cursor:  pointer; background-color: #f9c642; color: #212121" in the "env_indicator" region
    And I should see the "div" element with the "style" attribute set to "background-color: rgb(249, 198, 66); color: rgb(33, 33, 33);" in the "env_indicator" region
  When I click on the element with css selector "#environment-indicator"
  Then I should see the link "Open in: Prod" in the "env_indicator" region
    And I should see the link "Open in: Train" in the "env_indicator" region
    And the hyperlink "Open in: Prod" should match the Drupal url "https://theexchange.sec.gov/home"
    And the hyperlink "Open in: Train" should match the Drupal url "https://training.intranet.sec.gov/home"

  Examples:
    | role               |
    | Authenticated user |
    | administrator      |
    | sitebuilder        |
    | content_creator    |
    | content_approver   |
    | microsite_creator  |
    | microsite_approver |

@api
Scenario: Verify AutoLogin
  Given "top_level_group" terms:
    | name       |
    | group      |
    | sports     |
    | procedures |
    And "topic" terms:
      | name    |
      | fun     |
      | not fun |
    And "form_topic" terms:
      | name           |
      | Altruists      |
      | Boondoggle     |
      | Man of War     |
      | Foreign Travel |
    And "sec_article" content:
      | title        | body      | field_source | field_top_level_group | field_topic | status | moderation_state |
      | behatarticle | test body | test source  | sports                | fun         | 1      | published        |
    And "sec_alert" content:
      | title      | body                     | status | moderation_state |
      | behatalert | This is an active alert. | 1      | published        |
    And "announcement" content:
      | title             | field_short_title | body   | status | field_announcement_type | moderation_state |
      | behatannouncement | Free today        | Test 1 | 1      | Obituary                | published        |
    And "event" content:
      | title      | field_short_title | body               | field_source | field_topic | field_top_level_group | status | moderation_state |
      | behatevent | Home Page Title 1 | This is an Event 1 | Minnie Mouse | fun         | sports                | 1      | published        |
    And "file" content:
      | title     | field_description_abstract                          | field_retain_disposal_date | field_file_upload    | moderation_state | status |
      | behatfile | This is a description and abstract about this file. | +1 day                     | file;behat-form1.pdf | published        | 1      |
    And "form" content:
      | body             | title     | field_form_topic | field_form_number | status | moderation_state |
      | This is the body | behatform | Altruists        | Test              | 1      | published        |
    And "image" content:
      | title      | field_alt_text             | field_image_upload   | status | moderation_state |
      | behatimage | This is a picure of a bird | image;behat-bird.gif | 1      | published        |
    And "library_item" content:
      | title        | field_vendor | field_format | body                  | field_contact_for_questions | field_topic | field_top_level_group | status | moderation_state |
      | behatlibitem | Bloomberg    | web-based    | Bloomberg description | John Smith                  | fun         | sports                | 1      | published        |
    And "link" content:
      | title     | field_description_abstract | field_url                        | status | moderation_state |
      | behatlink | Mailto Link Description    | Click Me - mailto:behat@test.com | 1      | published        |
    And "operating_procedure" content:
      | title   | field_release_number | field_publish_date | field_series | status | field_link_reference | moderation_state |
      | behatop | OP 12345             | now                | 1            | 1      | behatlink            | published        |
    And "secr" content:
      | title     | field_secr_number | field_publish_date | field_series | field_related_op | status | moderation_state |
      | behatsecr | R1-2              | now                | 1            | behatop          | 1      | published        |
    And "video" content:
      | title      | field_video_type | field_video_origin | field_video                                 | field_media_id | body        | field_transcript | status | moderation_state |
      | behatvideo | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc |                | Body text 1 | Transcript 1     | 1      | published        |
    And "featured" content:
      | title         | field_featured_type | field_teaser        | field_image_reference | field_url                      | promote | status | moderation_state |
      | behatfeatured | highlighted_item    | This is not a bird. | behatimage            | Link 1 - http://www.google.com | 0       | 1      | published        |
    And "landing_page" content:
      | title     | field_description_abstract | field_landing_page_subtype | field_top_level_group | status | moderation_state |
      | behatland | Bloomberg                  | web-based                  | sports                | 1      | published        |
  When I am on "/"
  Then I should see the text "You are not authorized to access this page."
  When I am on "/behatarticle"
  Then I should see the text "You are not authorized to access this page."
  When I am on "/forms/test-behatform"
  Then I should see the text "You are not authorized to access this page."
  When I am on "/op-12345-behatop"
  Then I should see the text "You are not authorized to access this page."
  When I am on "/r1-2-behatsecr"
  Then I should see the text "You are not authorized to access this page."
  When I am on "/videos/behatvideo"
  Then I should see the text "You are not authorized to access this page."
  When I am on "/events/behatevent"
  Then I should see the text "You are not authorized to access this page."

@api
Scenario Outline: Change <container> Tag To A Proper HTML Element
  Given I am logged in as a user with the "Authenticated user" role
  When I am viewing an "<content>" content:
    | title            | <title>          |
    | moderation_state | published        |
    | status           | 1                |
    | body             | This is the body |
  Then I should not see the html element "container" on the page

  Examples:
    | content             | title              |
    | announcement        | BEHAT Announcement |
    | event               | BEHAT Events       |
    | form                | BEHAT Form         |
    | gallery             | BEHAT Gallery      |
    | landing_page        | BEHAT Landing Page |
    | library_item        | BEHAT Library      |
    | operating_procedure | BEHAT OP           |
    | sec_article         | BEHAT Article      |
    | secr                | BEHAT SECR         |
    | video               | BEHAT Video        |
