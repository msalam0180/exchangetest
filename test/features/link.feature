Feature: Create and View Links
As a content creator
I want to be able to manage Links
So that I can easily update links across the site

Background:
  Given "topic" terms:
    | name            |
    | Technology      |
    | Human Resources |
    And "top_level_group" terms:
      | name     |
      | toplevel |
      | sports   |
    And users:
      | name         | mail           | roles            |
      | creator      | test1@test.com | content_creator  |
      | approver     | test2@test.com | content_approver |
      | sitebuilder  | test3@test.com | sitebuilder      |
      | authen_user1 | test4@test.com |                  |
      | authen_user2 | test5@test.com |                  |
      | admin        | test6@test.com | administrator    |

@api @javascript
Scenario: Create Internal Link Through UI
  Given I am logged in as a user with the "Content Creator" role
    And "sec_article" content:
      | title           | field_body | field_source | top_level_group | topic | status |
      | Behat Article-1 | testing    | testing      | anything        | fun   | 1      |
  When I visit "/node/add/link"
    And I fill in the following:
      | Title                | Behat Test Internal Link |
      | Description/Abstract | Link Description         |
      | Link text            | Click Here               |
    And I select the first autocomplete option for "BEHAT Article-1" on the "URL" field
    And I press "Save"
  Then I should see the text "Link Behat Test Internal Link has been created"
    And I should see the link "Click Here"
    And I click "Click Here"
  Then I should see the heading "Behat Article-1"

@api @javascript
Scenario: Create External Link Through UI
  Given I am logged in as a user with the "Content Creator" role
  When I visit "/node/add/link"
    And I fill in the following:
      | Title                | Behat Test External Link             |
      | Description/Abstract | External Link Description            |
      | URL                  | https://en.wikipedia.org/wiki/Drupal |
      | Link text            | Click Here                           |
    And I press "Save"
  Then I should see the text "Link Behat Test External Link has been created"
    And I should see the link "Click Here"
    And I click "Click Here"
    And the link should open in a new tab
  Then I should see the heading "Drupal"
    And I close the current window

@api @javascript
Scenario: Create Reference Mailto Link
  Given I am logged in as a user with the "content_approver" role
    And link content:
      | title                    | field_description_abstract | field_url                        | status | moderation_state | nid   |
      | Behat Email Contact Link | Mailto Link Description    | Click Me - mailto:behat@test.com | 1      | published        | 99999 |
  When I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | BEHAT Test Article 1 |
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
    And I fill in "URL" with "/node/99999"
    And I click "Save" on the modal "Add Link"
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I fill in "Display Text" with "SEC.gov Test Team"
    And I press the "OK" button
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Technology" from "Topic"
    And I select "Technology" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I should see the heading "BEHAT Test Article 1"
    And I should see the link "SEC.gov Test Team"
  When I am logged in as a user with the "Authenticated user" role
    And I am on "/search"
    And I fill in "edit-search-api-fulltext" with "BEHAT Test Article 1"
    And I press the "edit-submit-the-exchange-search" button
  Then I should see the link "BEHAT Test Article 1"
    And I click "BEHAT Test Article 1"
    And I should see the link "SEC.gov Test Team"
    And the hyperlink "SEC.gov Test Team" should match the Drupal url "mailto:behat@test.com"

@api @javascript
Scenario: Create Reference Node Link
  Given I am logged in as a user with the "content_approver" role
    And link content:
      | title           | field_description_abstract | field_url                          | status | moderation_state | nid   |
      | Behat Page Link | Site Link Description      | Click Here - http://www.google.com | 1      | published        | 88888 |
  When I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | BEHAT Test Article 2 |
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
    And I fill in "URL" with "/node/88888"
    And I click "Save" on the modal "Add Link"
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I fill in "Display Text" with "Google Homepage"
    And I press the "OK" button
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Technology" from "Topic"
    And I select "Technology" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I should see the heading "BEHAT Test Article 2"
    And I should see the link "Google Homepage"
    And the hyperlink "Google Homepage" should match the Drupal url "/node/88888"
    And I click "Google Homepage"
    And I should see the heading "Behat Page Link"
    And I should see the link "Click Here"
    And the hyperlink "Click Here" should match the Drupal url "http://www.google.com"

#Scenario: Create External Link Without Text Through UI

#@api @javascript
#Scenario: Create an External Link with Text
#  Given I am viewing a "link" content:
#    | title     | BEHAT Test Link                               |
#    | field_url | BEHAT Test Link Title - http://www.google.com |
#    | status    | 1                                             |
#  And I break
#  Then the URL should match "http://www.google.com"

#@api
#Issue with Drupal Extension -- can't make external links without text right now.
#Scenario: Create an External Link without Text
#  Given I am viewing a "link" content:
#    | title              | BEHAT Test Link       |
#    | field_url          | http://www.google.com |
#    | field_publish_date | 2017-08-11 12:00:00   |
#  Then I should see the link "http://www.google.com"

@api @javascript
Scenario: Open External Link In A New Tab
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | Searching |
    And I scroll "#edit-body-wrapper" into view
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
  Then I fill in "Display Text" with "Google Search"
    And I select "https://" from "Protocol"
    And I fill in "URL*" with "www.google.com"
    And I press the "OK" button
    And I type "Source Material" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Technology" from "Topic"
    And I select "Technology" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
    And I should see the link "Google Search"
    And I click "Google Search"
    And the link should open in a new tab
    And I close the current window

@api @javascript
Scenario Outline: Role Access To Link Node Page From Content
  Given I am logged in as a user with the "content_approver" role
    And link content:
      | title               | field_description_abstract | field_url                               | status | moderation_state | nid    |
      | IDEA Public Schools | The Search Engine          | IDEA - http://www.ideapublicschools.org | 1      | published        | 999999 |
    And "sec_article" content:
      | title                    | field_source  | field_top_level_group | field_topic | status | moderation_state | nid    |
      | Happy 19th Birthday IDEA | The Interwebs | news                  | news        | 1      | published        | 888888 |
  When I visit "/node/888888/edit"
    And I wait 1 seconds
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
    And I fill in "URL" with "/node/999999"
    And I click "Save" on the modal "Add Link"
    And I publish it
  When I am not logged in
  When I am logged in as "<user>"
    And I visit "/news/happy-19th-birthday-idea"
    And I should see the link "node/999999"
    And I click "/node/999999"
    And I should see the text "<Result1>"
    And I close the current window

  Examples:
    | user         | Result1             |
    | admin        | IDEA Public Schools |
    | sitebuilder  | IDEA Public Schools |
    | creator      | IDEA Public Schools |
    | authen_user1 |                     |

@api
Scenario: Create Link As Content Creator
  Given I am logged in as a user with the "content_creator" role
  When I visit "/node/add/link"
  Then I should see the "Save" button
    And the "Published" checkbox should be checked
    And I should not see the "Save and Create New Draft" button
    And I should not see the "Save and Publish" button

#To Do - Check for authen_user1 url link is directed to the listed link

@api @javascript
Scenario: Verify Link Is Not Broken When The Maximum Characters Are Provided For Quick Links View
  Given I am logged in as a user with the "content_approver" role
    And "sec_article" content:
      | title                                                                                                                                                                                                                                                           | body                   | status |
      | A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy | This is a test article | 1      |
    And I visit "/node/add/link"
    And I fill in the following:
      | Title                | Behat Test Internal Link |
      | Description/Abstract | Link Description         |
      | Link text            | BEHAT Link3              |
    And I select the first autocomplete option for "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy" on the "URL" field
    And I check "Add to Available QuickLinks"
    And I press "Save"
  When I am logged in as a user with the "Authenticated user" role
    And I visit "user/profile/quicklinks"
    And I scroll to the bottom
  Then I should see the link "BEHAT Link3"
  When I click "BEHAT Link3"
    And I wait 1 seconds
    And the link should open in a new tab
  Then I should be on "/wonderful-serenity-has-taken-possession-my-entire-soul-these-sweet-mornings-spring-which-i-enjoy-my"
    And I should see the text "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy"

@api @javascript
Scenario: Verify Link Is Not Broken When The Maximum Characters Are Provided For Forms View
  Given I am logged in as a user with the "content_approver" role
    And "sec_article" content:
      | title                                                                                                                                                                                                                                                           | body                   | status |
      | A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy | This is a test article | 1      |
    And I visit "/node/add/link"
    And I fill in the following:
      | Title                | A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy |
      | Description/Abstract | Link Description                                                                                                                                                                                                                                                |
      | Link text            | BEHAT Link3                                                                                                                                                                                                                                                     |
    And I select the first autocomplete option for "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy" on the "URL" field
    And I check "Add to Available QuickLinks"
    And I press "Save"
    And I visit "/node/add/form"
    And I fill in "Title" with "A wonderful serenity"
    And I select "Link" from "Link/Media Type"
    And I fill in "Link Reference" with "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy"
    And I select "sports" from "Top Level Group"
    And I select "Technology" from "Topic"
    And I publish it
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/forms"
  Then I should see the link "A wonderful serenity"
  When I click "A wonderful serenity"
  Then I should see the link "BEHAT Link3"
  When I click "BEHAT Link3"
  Then I should be on "/wonderful-serenity-has-taken-possession-my-entire-soul-these-sweet-mornings-spring-which-i-enjoy-my"
    And I should see the text "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy"
