Feature: Create and View Article Content
  As a Visitor to the Insider
  I want to be able to view articles
  So that I can learn information about the SEC

Background:
  Given "audiences" terms:
    | name    |
    | Insider |
    | Lawyer  |
    And "topic" terms:
      | name       |
      | technology |
      | hr         |
    And "office_division" terms:
      | name                |
      | DERA                |
      | Corporation Finance |
    And "group_club" terms:
      | name    |
      | Running |
      | Cooking |
    And "top_level_group" terms:
      | name     |
      | toplevel |
      | sports   |

@api
Scenario: Validate Help Text
  Given I am logged in as a user with the "administrator" role
  When I visit "/node/add/sec_article"
  Then I should see the text "Federal employee responsible for providing the information for publishing."

@api @javascript
Scenario: Create an Article through the UI
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | BEHAT Test Article |
    # | edit-field-retain-disposal-date-0-value-date      | 09/11/2017         |
    And I type "This is a test body" in the "Body" WYSIWYG editor
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Lawyer" from "Audience"
    And I additionally select "Insider" from "Audience"
    And I select "Running" from "Group/Club"
    And I additionally select "Cooking" from "Group/Club"
    And I select "Corporation Finance" from "Division/Office"
    And I additionally select "DERA" from "Division/Office"
    And I select "technology" from "Topic"
    And I additionally select "hr" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I should see the heading "BEHAT Test Article"
    And I should see the text "This is a test body"
    And I should see the text "Source"
    And I should see the text "This is a source"

#@api
#Scenario: Schedule an Article for Publishing
#  Given I am viewing an "sec_article" content:
#  | body         | This is the body    |
#  | title        | BEHAT Test Article  |
#  | changed      | 2017-07-11 12:00:00 |
#  | published_at | 2017-08-11 12:00:00 |
#  | publish_on   | 222                 |
#  | status       |                     |
#    And the response status code should be 403
#    And I wait 62 seconds
#    And I run drupal cron
#    And I move backward one page
#    And I reload the page
#  Then the response status code should be 200

@api
Scenario: View an Article
  Given I am logged in as a user with the "Authenticated user" role
    And I am viewing an "sec_article" content:
      | body         | This is the body    |
      | title        | My test article     |
      | changed      | 2017-07-11 12:00:00 |
      | published_at | 2017-08-11 12:00:00 |
      | status       | 1                   |
  Then I should see the text "This is the body"
    And I should see the text "July 11, 2017"

@api
Scenario Outline: If last updated date is null show published date
  Given I am logged in as a user with the "Authenticated user" role
    And I am viewing an "sec_article" content:
      | body         | This is the body    |
      | title        | My test article     |
      | changed      | <Last_Updated_Date> |
      | published_at | <Published_Date>    |
      | status       | 1                   |
  Then I should see the text "<Date_Text>"

  Examples:
    | Last_Updated_Date   | Published_Date      | Date_Text               |
    | 2017-07-11 12:00:00 | 2017-08-11 12:00:00 | Modified: July 11, 2017 |
    | 2017-08-11 12:00:00 | 2017-08-11 12:00:00 | Created: Aug. 11, 2017  |

@api
Scenario Outline: Test AP Date Format for Article Last Update Date Display
  Given I am logged in as a user with the "Authenticated user" role
    And I am viewing an "sec_article" content:
      | body    | This is the body    |
      | title   | My test article     |
      | changed | <Last_Updated_Date> |
      | status  | 1                   |
  Then I should see the text "<Date_Text>"

  Examples:
    | Last_Updated_Date   | Date_Text      |
    | 2017-01-11 12:00:00 | Jan. 11, 2017  |
    | 2017-02-11 12:00:00 | Feb. 11, 2017  |
    | 2017-03-11 12:00:00 | March 11, 2017 |
    | 2017-04-11 12:00:00 | April 11, 2017 |
    | 2017-05-11 12:00:00 | May 11, 2017   |
    | 2017-06-11 12:00:00 | June 11, 2017  |
    | 2017-07-11 12:00:00 | July 11, 2017  |
    | 2017-08-11 12:00:00 | Aug. 11, 2017  |
    | 2017-09-11 12:00:00 | Sept. 11, 2017 |
    | 2017-10-11 12:00:00 | Oct. 11, 2017  |
    | 2017-11-11 12:00:00 | Nov. 11, 2017  |
    | 2017-12-11 12:00:00 | Dec. 11, 2017  |

@api @javascript
Scenario: Review tab when the content has been edited for article
  Given "sec_article" content:
    | title                | moderation_state | status | body                 | edit-field-source-wrapper | field_source             | field_topic   | field_top_level_group |
    | This is the BEHAT v1 | published        | 1      | This is the body     | This is the source field  | This is the source field | About the SEC | My SEC                |
    And I am logged in as a user with the "Content Approver" role
  When I am on "/admin/content"
    And I select "Article" from "type"
    And I wait for ajax to finish
    And I press "Filter"
    And I wait for ajax to finish
    And I click "Edit" in the "This is the BEHAT v1" row
    And I fill in "This is the BEHAT v2" for "Title"
    And I publish it
    And I am on "/admin/content"
    And I select "Article" from "type"
    And I wait for ajax to finish
    And I press "Filter"
    And I wait for ajax to finish
    And I click "Edit" in the "This is the BEHAT v2" row
  Then I should see the link "Revisions"
    And I click "Revisions"
    And I click "Revert"
    And I press the "Revert" button
    And I click "View"
  Then I should see the text "This is the BEHAT v1"
    And I am on "/admin/content"
    And I select "Article" from "type"
    And I wait for ajax to finish
    And I press "Filter"
    And I wait for ajax to finish
    And I click "Edit" in the "This is the BEHAT v1" row
    And I fill in "This is the BEHAT v3" for "Title"
    And I publish it
    And I am on "/admin/content"
    And I select "Article" from "type"
    And I wait for ajax to finish
    And I press "Filter"
    And I wait for ajax to finish
    And I click "Edit" in the "This is the BEHAT v3" row
    And I click "Revisions"
    And I click on the element with css selector ".node-revision-table > tbody > tr:nth-child(1) > td:nth-child(1) > a:nth-child(1)"
    And I should see the text "This is the BEHAT v3"
    And I am on "/admin/content"
    And I select "Article" from "type"
    And I wait for ajax to finish
    And I press "Filter"
    And I wait for ajax to finish
    And I click "Edit" in the "This is the BEHAT v3" row
    And I click "Revisions"
    And I click on the element with css selector ".node-revision-table > tbody > tr:nth-child(3) > td:nth-child(1) > a:nth-child(1)"
    And I should see the text "This is the BEHAT v2"

@api @javascript
Scenario: Articles Override Modified Date Update
  Given "sec_article" content:
    | title                 | moderation_state | status | body                 | field_source             | field_topic   | field_top_level_group | published_at        | changed |
    | Article Mod Date Test | published        | 1      | This is the body     | This is the source field | About the SEC | My SEC                | 2020-07-03T16:00:05 | -5 day  |
  When I am logged in as a user with the "Administrator" role
    And I am on "/my-sec/article-mod-date-test/edit"
    # Checking for usage of published date
  Then I should see the "input" element with the "value" attribute set to "2020-07-03" in the "published_on" region
  When I click secondary option "Override Modified Date"
    And I fill in the following:
      | edit-field-override-modified-date-0-value-date | 11/29/2021 |
      | edit-field-override-modified-date-0-value-time | 01:00:00AM |
    And I publish it
  Then I should see the text "Article Article Mod Date Test has been updated."
    And I should see the text "Modified: Nov. 29, 2021"
  When I visit "/my-sec/article-mod-date-test/edit"
    And I click secondary option "Override Modified Date"
    And I fill in the following:
      | edit-field-override-modified-date-0-value-date | 12/01/2021 |
      | edit-field-override-modified-date-0-value-time | 00:01:00AM |
    And I publish it
  Then I should see the text "Modified: Dec. 1, 2021"

@api @javascript
Scenario: Articles Published Date Doesn't Update When Republish
  Given "sec_article" content:
    | title                  | moderation_state | status | body             | field_source             | field_topic   | field_top_level_group | published_at        | changed |
    | Published Article Test | published        | 1      | This is the body | This is the source field | hr            | sports                | 2020-07-03T16:00:05 | -5 day  |
  When I am logged in as a user with the "administrator" role
    And I am on "/published-article-test/edit"
  # Checking for usage of published date
  Then I should see the "input" element with the "value" attribute set to "2020-07-03" in the "published_on" region
  When I fill in "Title" with "Published Article Test Again"
    And I publish it
  Then I should see the text "Article Published Article Test Again has been updated."
  When I am on "/published-article-test-again/edit"
  # Checking for no date updating when republish
  Then I should see the "input" element with the "value" attribute set to "2020-07-03" in the "published_on" region
