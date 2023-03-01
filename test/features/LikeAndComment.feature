Feature: Likes and Comments
  As a User I should be able to like and comment on the following content types
  Announcements, Events, Form, Gallery, Landing Page, Library Items, Operating Procedure, Basic Page, Article, SECR, Video

  Background:

    Given "topic" terms:
      | name   |
      | hr     |
      And "top_level_group" terms:
        | name     |
        | sports   |

  @api @javascript
  Scenario Outline: Content Type With Comment And Like Settings Enabled
    Given I am logged in as a user with the "Authenticated user" role
    When I am viewing an "<content>" content:
      | title               | <title>             |
      | moderation_state    | published           |
      | status              | 1                   |
      | body                | This is the body    |
      | field_comments      | 2                   |
      | field_enable_likes  | 1                   |
    Then I should see the link "Like"
      And I should see "0" in the "like_count" region
      And I should see the text "Comment"
      And I should see the text "Please adhere to the Rules of the Road when posting a comment."
      And I should see the link "Rules of the Road"
      And I should see the "Save" button

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

  @api
  Scenario Outline: Content Type With Comment And Like Settings Disabled
    Given I am logged in as a user with the "Authenticated user" role
    When I am viewing an "<content>" content:
      | title               | <title>             |
      | moderation_state    | published           |
      | status              | 1                   |
      | body                | This is the body    |
      | field_comments      | 1                   |
      | field_enable_likes  | 0                   |
    Then I should not see the link "Like"
      And I should not see the text "Comment"

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

  @api @javascript
  Scenario Outline: Authorized Users Can Like The Content Page
    Given I am logged in as a user with the "Authenticated user" role
    When I am viewing an "<content>" content:
      | title               | <title>             |
      | moderation_state    | published           |
      | status              | 1                   |
      | body                | This is the body    |
      | field_comments      | 2                   |
      | field_enable_likes  | 1                   |
    Then I should see the heading "<page_title>"
      And I should see the link "Like"
      And I should see "0" in the "like_count" region
    When I click "Like"
      And I wait 2 seconds
    Then I should see the text "1" in the "like_count" region
      And I should see the link "Unlike"
      And I wait 2 seconds
      And I should not see "0" in the "like_count" region
      And I should not see the link "Like"
    When I click "Unlike"
      And I wait 2 seconds
    Then I should not see the text "1" in the "like_count" region
      And I should see the text "0" in the "like_count" region
      And I should see "Please adhere to the Rules of the Road when posting a comment."
      And I should see the link "Rules of the Road"

    Examples:
      | content             | title              | page_title         |
      | announcement        | BEHAT Announcement | BEHAT Announcement |
      | event               | BEHAT Events       | BEHAT Events       |
      | form                | BEHAT Form         | BEHAT Form         |
      | gallery             | BEHAT Gallery      | BEHAT Gallery      |
      | landing_page        | BEHAT Landing Page | BEHAT Landing Page |
      | library_item        | BEHAT Library      | BEHAT Library      |
      | operating_procedure | BEHAT OP           | - BEHAT OP         |
      | sec_article         | BEHAT Article      | BEHAT Article      |
      | secr                | BEHAT SECR         | - BEHAT SECR       |
      | video               | BEHAT Video        | BEHAT Video        |

  @api @javascript
  Scenario Outline: Authenticated User Can Like And UnLike An Existing Comment
    Given I am logged in as a user with the "content_creator" role
    When I am viewing an "<content>" content:
      | title               | <title>             |
      | moderation_state    | published           |
      | status              | 1                   |
      | body                | This is the body    |
      | field_comments      | 2                   |
      | nid                 | <nid>               |
      And I scroll to the bottom
      And I type "This is the First Reply" in the "Comment" WYSIWYG editor
      And I scroll to the bottom
      And I press "Save"
      And I wait 2 seconds
    Then I should see the text "Your comment has been posted."
      And I should see the text "new" in the "insider_content" region
      And I should see the text "Submitted by"
      And I should see the text "This is the First Reply"
      And I click "Like" in the "like_reply_section" region
    When I am logged in as a user with the "Authenticated user" role
      And I visit "/node/<nid>"
      And I wait 2 seconds
      And I should see the text "new" in the "insider_content" region
      And I should see the link "Like" in the "like_reply_section" region
      And I should not see the link "Delete" in the "comments_section" region
      And I should not see the link "Edit" in the "comments_section" region
      And I should see the text "1" in the "like_reply_section" region
    When I click "Like" in the "like_reply_section" region
      And I wait 2 seconds
    Then I should see the text "2" in the "like_reply_section" region
    When I click "Unlike" in the "like_reply_section" region
      And I wait 2 seconds
    Then I should see the text "1" in the "like_reply_section" region

    Examples:
      | content             | title               | nid   |
      | announcement        | BEHAT Announcement  | 98769 |
      | event               | BEHAT Events        | 98768 |
      | form                | BEHAT Form          | 98767 |
      | gallery             | BEHAT Gallery       | 98766 |
      | landing_page        | BEHAT Landing Page  | 98765 |
      | library_item        | BEHAT Library       | 98764 |
      | operating_procedure | BEHAT OP            | 98763 |
      | sec_article         | BEHAT Article       | 98762 |
      | secr                | BEHAT SECR          | 98761 |
      | video               | BEHAT Video         | 98760 |

  @api @javascript
  Scenario Outline: Verify Comments Helptext And Default Settings
  # By default when you create a new page, the Comments radio button should be set to Closed
    Given I am logged in as a user with the "content_approver" role
    When I visit "<link>"
      And I click secondary option "Comment settings"
    Then I should see "Please adhere to the Rules of the Road when posting a comment."
      And I should see the link "Rules of the Road"
      And I should see the text "Open"
      And I should see the text 'Users with the "Post comments" permission can post comments.'
      And I should see the text "Closed"
      And I should see the text "Users cannot post comments."
      And Radio button with id "edit-field-comments-0-status-1" should be checked

    Examples:
      | link                          |
      | /node/add/announcement        |
      | /node/add/event               |
      | /node/add/form                |
      | /node/add/gallery             |
      | /node/add/landing_page        |
      | /node/add/library_item        |
      | /node/add/operating_procedure |
      | /node/add/secr                |
      | /node/add/video               |
      | /node/add/sec_article         |

  @api @javascript
  Scenario Outline: Permissions to Like Settings And Adding Comment Moderator
  # Content Approver and Sitebuilder should see like settings with content add/edit page
  # Content Creators do not have ability to see the like settings field
  # By default like functionality should not be enabled on the page
    Given I am logged in as a user with the "content_approver" role
    When I visit "<link>"
    Then I should see the text "Like Settings"
      And the "Enable Likes" checkbox should not be checked
      And I should see the text "Comment Moderator"
    When I press "Comment Moderator"
    Then I should see the text "Enter one or more email addresses for the employee or group mailbox that should receive email notices when comments are added, updated, or deleted on this page. Separate multiple email addresses with a comma."
    When I am logged in as a user with the "sitebuilder" role
      And I visit "<link>"
    Then I should see the text "Like Settings"
      And I should see the text "Comment Moderator"
      And the "Enable Likes" checkbox should not be checked
    When I am logged in as a user with the "content_creator" role
      And I visit "<link>"
    Then I should not see the text "Like Settings"
      And I should not see the text "Comment Moderator"

    Examples:
      | link                          |
      | /node/add/announcement        |
      | /node/add/event               |
      | /node/add/form                |
      | /node/add/gallery             |
      | /node/add/landing_page        |
      | /node/add/library_item        |
      | /node/add/operating_procedure |
      | /node/add/secr                |
      | /node/add/video               |
      | /node/add/sec_article         |

  @api @javascript
  Scenario: Previous Comments Before Closing Are Visible And Can Be Liked/Unliked
    #Create an announcement with comments enabled
    Given "announcement" content:
      | title       | field_short_title | body   | field_source | published_at | status | field_announcement_type | field_topic   | field_top_level_group | moderation_state | nid    |
      | Used Carpet | Free Dirty Carpet | Test 1 | craigslist   | now          | 1      | Detail                  | hr            | sports                | published        | 852020 |
      And I am logged in as a user with the "content_approver" role
    When I visit "/node/852020/edit"
      And I press "Comment settings"
      And I select the radio button "Open" with the id "edit-field-comments-0-status-2"
      And I publish it
    Then I see the heading "Used Carpet"
      And I scroll to the bottom
      And I type "This is my first comment" in the "Comment" WYSIWYG editor
      And I scroll to the bottom
      And I press "Save"
      And I wait 2 seconds
    Then I should see the text "This is my first comment"
    #Disable comments
    When I visit "/node/852020/edit"
      And I select the radio button "Closed" with the id "edit-field-comments-0-status-1"
      And I publish it
    #Verify previous comments before comments are closed are still visible to another user and can be liked/unliked
      And I am logged in as a user with the "Authenticated user" role
      And I visit "/node/852020"
    Then I should not see the text "Add new comment"
      And I should see the text "Comments on this page are closed."
      And I should see the text "This is my first comment"
      And I should see the link "Like" in the "like_reply_section" region
      And I should see the text "0" in the "like_reply_section" region
    When I click "Like" in the "like_reply_section" region
      And I wait 2 seconds
    Then I should see the text "1" in the "like_reply_section" region
    When I click "Unlike" in the "like_reply_section" region
      And I wait 2 seconds
    Then I should see the text "0" in the "like_reply_section" region

  @api @javascript
  Scenario: Verify Email Notification Is Sent When a User Submits Or Edit Or Deletes a Comment
    Given users:
      | uid   | name         | mail               | roles            | status |
      | 99995 | bh_creator1  | pageowner@test.com | Content Creator  | 1      |
      | 99997 | authen_user1 | comment@test.com   |                  | 1      |
      | 99996 | bh_approver1 | delete@test.com    | Content Approver | 1      |
      And I am logged in as a user with the "administrator" role
      And I visit "/admin/config/development/maillog"
      And I check the box "Allow the e-mails to be sent."
      And I press "Save configuration"
    When I am logged in as "authen_user1"
      And I am viewing an "announcement" content:
        | title                   | BEHAT Announcement |
        | moderation_state        | published          |
        | status                  | 1                  |
        | body                    | This is the body   |
        | field_comments          | 2                  |
        | nid                     | 12345              |
        | field_comment_moderator | bh_commod@test.com |
        | uid                     | 99995              |
      And I fill in "Comment" with "This is the First Reply"
      And I scroll to the bottom
      And I press "Save"
    Then I should see the text "This is the First Reply"
      And I should see the text "Your message has been sent."
    When I visit "/node/12345"
      And I click "Edit" in the "comments_section" region
      And I fill in "Comment" with "This is the First Edit"
      And I press "Save"
    Then I should see the text "This is the First Edit"
      And I should see the text "Your message has been sent."
    When I am logged in as "bh_approver1"
      And I visit "/node/12345"
      And I click the ".flag.flag-mark-comment-as-inappropriate" element
    Then I should see the text "Your message has been sent."
    # Undo Allow the e-mails to be sent setting
    When I am logged in as a user with the "administrator" role
      And I visit "/admin/config/development/maillog"
      And I uncheck the box "Allow the e-mails to be sent."
      And I press "Save configuration"
    Then I should see the text "The configuration options have been saved."

  @api @javascript
  Scenario Outline: Ability To Block User From Making Future Comments
     # Setup users and roles through dB injection - setup same enduser that later gets blocked
    Given users:
      | name        | mail              | roles | status |
      | authen_user | comment@test.com  |       | 1      |
    When I am logged in as "authen_user"
      And I am viewing an "<content>" content:
        | title                   | <title>            |
        | moderation_state        | published          |
        | status                  | 1                  |
        | body                    | This is the body   |
        | field_comments          | 2                  |
        | nid                     | 12345              |
        | field_comment_moderator | bh_commod@test.com |
      And I fill in "Comment" with "This is an inappropriate comment before I am blocked"
      And I press "Save"
    Then I should see the text "This is an inappropriate comment before I am blocked"
      And I should see the text "Your comment has been posted."
    # content approver removes commenting privileges
    When I am logged in as a user with the "content_approver" role
      And I visit "/node/12345"
    Then I should see the text "This is an inappropriate comment before I am blocked"
      And I should see the link "Remove Commenting Privileges"
      And I click "Remove Commenting Privileges"
      And I wait for AJAX to finish
    Then I should see the link "Add Commenting Privileges"
    # enduser is now blocked from commenting and replying
    When I am logged in as "authen_user"
      And I visit "/node/12345"
    Then I should see the text "This is an inappropriate comment before I am blocked"
      And I should not see the link "Reply" in the "like_reply_section" region
      And I should not see an "#edit-comment-body-0-value" element
      But I should see the link "Like"

    Examples:
      | content      | title              |
      | sec_article  | BEHAT Article      |
      | announcement | BEHAT Announcement |

  @api @javascript
  Scenario Outline: DI-5896-Comment Display Clean Up
    Given I am logged in as a user with the "Authenticated user" role
    When I am viewing an "<content>" content:
      | title                   | <title>             |
      | moderation_state        | published           |
      | status                  | 1                   |
      | body                    | This is the body    |
      | field_comments          | 2                   |
      | nid                     | 12345               |
      | field_comment_moderator | behat@behat.org     |
    # Create comment and verify UI cleanup items:
      And I fill in "Comment" with "This is comment 1"
      And I scroll to the bottom
      And I should not see the "edit-preview" button
      And I should not see the text "About text formats"
      And I press "Save"
    Then I should see the text "This is comment 1"
      And I should see the text "Your comment has been posted."
      And I should see the heading "Comments"
      And I should see the text "Submitted by"
      And I should not see the link "Permalink"
      And I should not see the text "About text formats"
    # CA does not see homepage field
    When I am logged in as a user with the "content_approver" role
      And I visit "/node/12345"
      And I scroll to the bottom
      And I scroll ".comment-edit" into view
      And I click "Edit" in the "comments_section" region
      And I should not see the text "About text formats"
      And I should not see the text "Administration"
      And I should not see the text "Homepage"
      And I scroll to the bottom
      And I should not see the "edit-preview" button
      And I press "Save"
      And I wait 2 seconds
    # CA soft-deletion feature - delete/restore
    # toggle-delete
    When I click the ".flag.flag-mark-comment-as-inappropriate" element
    Then I should see the text "This comment has been deleted"
      And I should not see "Edit" in the "comments_section" region
    # toggle-restore
    When I click the ".flag.flag-mark-comment-as-inappropriate" element
    Then I should see the text "This is comment 1"
      And I should see "Edit" in the "comments_section" region
    # SB does not see homepage field
    When I am logged in as a user with the "sitebuilder" role
      And I visit "/node/12345"
      And I scroll to the bottom
      And I click "Edit" in the "comments_section" region
      And I should not see the text "About text formats"
      And I should not see the text "Administration"
      And I should not see the text "Homepage"
      And I scroll to the bottom
      And I should not see the "edit-preview" button
      And I press "Save"
      And I wait 2 seconds
    # SB soft-deletion feature - delete/restore
    # toggle-delete
    When I click the ".flag.flag-mark-comment-as-inappropriate" element
    Then I should see the text "This comment has been deleted"
      And I should not see "Edit" in the "comments_section" region
    # toggle-restore
    When I click the ".flag.flag-mark-comment-as-inappropriate" element
    Then I should see the text "This is comment 1"
      And I should see "Edit" in the "comments_section" region

    Examples:
      | content      | title              |
      | announcement | BEHAT Announcement |
      | event        | BEHAT Events       |

  @api
  Scenario: Default Comments Pagination Set To 50 Comments For Events
    # Pagination is set to 50 per page by default
    Given I am logged in as a user with the "administrator" role
    When I visit "/admin/structure/types/manage/event/fields/node.event.field_comments"
    Then the "edit-settings-per-page" field should contain "50"

  @api @javascript
  Scenario: Pagination With 50 Comments
    # Creating paginated comments - 51 comments with 5 replies on last comment
    Given I am logged in as a user with the "administrator" role
    When I visit "/admin/structure/types/manage/sec_article/fields/node.sec_article.field_comments"
    Then the "edit-settings-per-page" field should contain "50"
    When I am logged in as a user with the "Authenticated user" role
      And I am viewing an "sec_article" content:
       | title                   | BEHAT Article    |
       | moderation_state        | published        |
       | status                  | 1                |
       | body                    | This is the body |
       | field_comments          | 2                |
       | field_comment_moderator | behat@behat.org  |
    When I fill in "Comment" with "Comment 1"
      And I press "Save"
    Then I should see the text "Comment 1"
    When I fill in "Comment" with "Comment 2"
      And I press "Save"
    Then I should see the text "Comment 2"
    When I fill in "Comment" with "Comment 3"
      And I press "Save"
    Then I should see the text "Comment 3"
    When I fill in "Comment" with "Comment 4"
      And I press "Save"
    Then I should see the text "Comment 4"
    When I fill in "Comment" with "Comment 5"
      And I press "Save"
    Then I should see the text "Comment 5"
    When I fill in "Comment" with "Comment 6"
      And I press "Save"
      Then I should see the text "Comment 6"
    When I fill in "Comment" with "Comment 7"
      And I press "Save"
    Then I should see the text "Comment 7"
    When I fill in "Comment" with "Comment 8"
      And I press "Save"
    Then I should see the text "Comment 8"
    When I fill in "Comment" with "Comment 9"
      And I press "Save"
    Then I should see the text "Comment 9"
    When I fill in "Comment" with "Comment 10"
      And I press "Save"
    Then I should see the text "Comment 10"
    When I fill in "Comment" with "Comment 11"
      And I press "Save"
    Then I should see the text "Comment 11"
    When I fill in "Comment" with "Comment 12"
      And I press "Save"
    Then I should see the text "Comment 12"
    When I fill in "Comment" with "Comment 13"
      And I press "Save"
    Then I should see the text "Comment 13"
    When I fill in "Comment" with "Comment 14"
      And I press "Save"
    Then I should see the text "Comment 14"
    When I fill in "Comment" with "Comment 15"
      And I press "Save"
    Then I should see the text "Comment 15"
    When I fill in "Comment" with "Comment 16"
      And I press "Save"
    Then I should see the text "Comment 16"
    When I fill in "Comment" with "Comment 17"
      And I press "Save"
    Then I should see the text "Comment 17"
    When I fill in "Comment" with "Comment 18"
      And I press "Save"
    Then I should see the text "Comment 18"
    When I fill in "Comment" with "Comment 19"
      And I press "Save"
    Then I should see the text "Comment 19"
    When I fill in "Comment" with "Comment 20"
      And I press "Save"
    Then I should see the text "Comment 20"
    When I fill in "Comment" with "Comment 21"
      And I press "Save"
    Then I should see the text "Comment 21"
    When I fill in "Comment" with "Comment 22"
      And I press "Save"
    Then I should see the text "Comment 22"
    When I fill in "Comment" with "Comment 23"
      And I press "Save"
    Then I should see the text "Comment 23"
    When I fill in "Comment" with "Comment 24"
      And I press "Save"
    Then I should see the text "Comment 24"
    When I fill in "Comment" with "Comment 25"
      And I press "Save"
    Then I should see the text "Comment 25"
    When I fill in "Comment" with "Comment 26"
      And I press "Save"
    Then I should see the text "Comment 26"
    When I fill in "Comment" with "Comment 27"
      And I press "Save"
    Then I should see the text "Comment 27"
    When I fill in "Comment" with "Comment 28"
      And I press "Save"
    Then I should see the text "Comment 28"
    When I fill in "Comment" with "Comment 29"
      And I press "Save"
    Then I should see the text "Comment 29"
    When I fill in "Comment" with "Comment 30"
      And I press "Save"
    Then I should see the text "Comment 30"
    When I fill in "Comment" with "Comment 31"
      And I press "Save"
    Then I should see the text "Comment 31"
    When I fill in "Comment" with "Comment 32"
      And I press "Save"
    Then I should see the text "Comment 32"
    When I fill in "Comment" with "Comment 33"
      And I press "Save"
    Then I should see the text "Comment 33"
    When I fill in "Comment" with "Comment 34"
      And I press "Save"
    Then I should see the text "Comment 34"
    When I fill in "Comment" with "Comment 35"
      And I press "Save"
    Then I should see the text "Comment 35"
    When I fill in "Comment" with "Comment 36"
      And I press "Save"
    Then I should see the text "Comment 36"
    When I fill in "Comment" with "Comment 37"
      And I press "Save"
    Then I should see the text "Comment 37"
    When I fill in "Comment" with "Comment 38"
      And I press "Save"
    Then I should see the text "Comment 38"
    When I fill in "Comment" with "Comment 39"
      And I press "Save"
    Then I should see the text "Comment 39"
    When I fill in "Comment" with "Comment 40"
      And I press "Save"
    Then I should see the text "Comment 40"
    When I fill in "Comment" with "Comment 41"
      And I press "Save"
    Then I should see the text "Comment 41"
    When I fill in "Comment" with "Comment 42"
      And I press "Save"
    Then I should see the text "Comment 42"
    When I fill in "Comment" with "Comment 43"
      And I press "Save"
    Then I should see the text "Comment 43"
    When I fill in "Comment" with "Comment 44"
      And I press "Save"
    Then I should see the text "Comment 44"
    When I fill in "Comment" with "Comment 45"
      And I press "Save"
    Then I should see the text "Comment 45"
    When I fill in "Comment" with "Comment 46"
      And I press "Save"
    Then I should see the text "Comment 46"
    When I fill in "Comment" with "Comment 47"
      And I press "Save"
    Then I should see the text "Comment 47"
    When I fill in "Comment" with "Comment 48"
      And I press "Save"
    Then I should see the text "Comment 48"
    When I fill in "Comment" with "Comment 49"
      And I press "Save"
    Then I should see the text "Comment 49"
    When I fill in "Comment" with "Comment 50"
      And I press "Save"
    Then I should see the text "Comment 50"
    When I fill in "Comment" with "Comment 51"
      And I press "Save"
    Then I should see the text "Comment 51"
      And I click "Reply" in the "comments_section" region
      And I fill in "Comment" with "Reply 1"
      And I press "Save"
    Then I should see the text "Reply 1"
    When I click "Reply" in the "comments_section" region
      And I fill in "Comment" with "Reply 2"
      And I press "Save"
    Then I should see the text "Reply 2"
    When I click "Reply" in the "comments_section" region
      And I fill in "Comment" with "Reply 3"
      And I press "Save"
    Then I should see the text "Reply 3"
    When I click "Reply" in the "comments_section" region
      And I fill in "Comment" with "Reply 4"
      And I press "Save"
    Then I should see the text "Reply 4"
    When I click "Reply" in the "comments_section" region
      And I fill in "Comment" with "Reply 5"
      And I press "Save"
    Then I should see the text "Reply 5"
     # Testing pagination from created comments
    When I click "Go to page 1"
    Then I should see the text "Comment 1"
    When I scroll to the bottom
      And I click "Go to page 2"
    Then I should see the text "Comment 51"
      And I should see the text "Reply 1"
      And I should see the text "Reply 2"
      And I should see the text "Reply 3"
      And I should see the text "Reply 4"
      And I should see the text "Reply 5"

  @api @javascript
  Scenario: Comments Pagination
    # Setup pagingation to 5 per page
    Given I am logged in as a user with the "administrator" role
    When I visit "/admin/structure/types/manage/announcement/fields/node.announcement.field_comments"
    Then the "edit-settings-per-page" field should contain "50"
    When I enter "5" for "Comments per page"
      And I press "Save settings"
    Then I should see the text "Saved Comments configuration."
    # Creating paginated comments - 6 sets comments with 5 replies on last comment
    When I am logged in as a user with the "Authenticated user" role
      And I am viewing an "announcement" content:
        | title                   | BEHAT Announcement |
        | moderation_state        | published          |
        | status                  | 1                  |
        | body                    | This is the body   |
        | field_comments          | 2                  |
        | nid                     | 12345              |
        | field_comment_moderator | behat@behat.org    |
      And I fill in "Comment" with "Comment 1"
      And I press "Save"
    Then I should see the text "Comment 1"
      And I should see the text "Submitted by"
      And I should see the link "Like" in the "like_reply_section" region
    When I fill in "Comment" with "Comment 2"
      And I press "Save"
    Then I should see the text "Comment 2"
    When I fill in "Comment" with "Comment 3"
      And I press "Save"
    Then I should see the text "Comment 3"
    When I fill in "Comment" with "Comment 4"
      And I press "Save"
    Then I should see the text "Comment 4"
    When I fill in "Comment" with "Comment 5"
      And I press "Save"
    Then I should see the text "Comment 5"
    When I fill in "Comment" with "Comment 6"
      And I press "Save"
    Then I should see the text "Comment 6"
    When I click "Reply" in the "comments_section" region
      And I fill in "Comment" with "Reply 1"
      And I press "Save"
    Then I should see the text "Reply 1"
    When I click "Reply" in the "comments_section" region
      And I fill in "Comment" with "Reply 2"
      And I press "Save"
    Then I should see the text "Reply 2"
    When I click "Reply" in the "comments_section" region
      And I fill in "Comment" with "Reply 3"
      And I press "Save"
    Then I should see the text "Reply 3"
    When I click "Reply" in the "comments_section" region
      And I fill in "Comment" with "Reply 4"
      And I press "Save"
    Then I should see the text "Reply 4"
    When I click "Reply" in the "comments_section" region
      And I fill in "Comment" with "Reply 5"
      And I press "Save"
    Then I should see the text "Reply 5"
    # Testing pagination from created comments
    When I scroll to the bottom
      And I click "Go to first page"
    Then I should see the text "Comment 1"
    When I scroll to the bottom
      And I click "Go to next page"
    Then I should see the text "Comment 6"
    When I scroll to the bottom
      And I click "Go to previous page"
    Then I should see the text "Comment 1"
    When I scroll to the bottom
      And I click "Go to last page"
    Then I should see the text "Reply 5"
    # Validating replies are also counted in per page limit count
    When I scroll to the bottom
      And I click "Go to page 2"
    Then I should see the text "Reply 1"
      And I should see the text "Reply 2"
      And I should see the text "Reply 3"
      And I should see the text "Reply 4"
      And I should not see the text "Reply 5"
    # Validating limited to 5 comments per page
    When I scroll to the bottom
      And I click "Go to page 1"
    Then I should see the text "Comment 1"
      And I should see the text "Comment 2"
      And I should see the text "Comment 3"
      And I should see the text "Comment 4"
      And I should see the text "Comment 5"
      And I should not see the text "Comment 6"
    # Cleanup comments per page setting
    When I am logged in as a user with the "administrator" role
      And I visit "/admin/structure/types/manage/announcement/fields/node.announcement.field_comments"
      And the "edit-settings-per-page" field should contain "5"
      And I enter "50" for "Comments per page"
      And I press "Save settings"
    Then I should see the text "Saved Comments configuration."

  @api
  Scenario: Filter Content To View Pages With Likes Enabled And Comments Open
  	Given I am logged in as a user with the "content_creator" role
      And I am viewing an "announcement" content:
        | title              | Announcement-Comments open & likes enabled |
        | moderation_state   | published                                  |
        | status             | 1                                          |
        | body               | This is the body                           |
        | field_comments     | 2                                          |
        | field_enable_likes | 1                                          |
    # Filtering:
  	When I visit "/admin/content"
      And I select "Published" from "Published status"
      And I select "Announcement" from "Content type"
      And I select "Enabled" from "Likes"
  	  And I select "Open" from "Comments"
  	  And I press "Filter"
  	  And I wait 2 seconds
    # Filter settings don't revert
      And the "#edit-field-enable-likes-value option[selected='selected']" element should contain "Enabled"
      And the "#edit-field-comments-status option[selected='selected']" element should contain "Open"
  	# Assertions:
  	Then I should see "Announcement-Comments open & likes enabled"

  @api
  Scenario: Filter Content To View Pages With Likes Enabled And Comments Closed
  	Given I am logged in as a user with the "content_creator" role
      And I am viewing an "sec_article" content:
        | title              | Article-Comments closed & likes enabled |
        | moderation_state   | published                               |
        | status             | 1                                       |
        | body               | This is the body                        |
        | field_comments     | 1                                       |
        | field_enable_likes | 1                                       |
    # Filtering:
  	When I visit "/admin/content"
      And I select "Published" from "Published status"
      And I select "Article" from "Content type"
      And I select "Enabled" from "Likes"
  	  And I select "Closed" from "Comments"
  	  And I press "Filter"
  	  And I wait 2 seconds
    # Filter settings don't revert
      And the "#edit-field-enable-likes-value option[selected='selected']" element should contain "Enabled"
      And the "#edit-field-comments-status option[selected='selected']" element should contain "Closed"
  	# Assertions:
  	Then I should see "Article-Comments closed & likes enabled"

  @api
  Scenario: Filter Content To View Pages With Likes Enabled And Comments Hidden
   Given I am logged in as a user with the "content_approver" role
      And I am viewing an "event" content:
        | title              | Event-Comments hidden & likes enabled |
        | moderation_state   | published                             |
        | status             | 1                                     |
        | body               | This is the body                      |
        | field_comments     | 0                                     |
        | field_enable_likes | 1                                     |
    # Filtering:
  	When I visit "/admin/content"
      And I select "Published" from "Published status"
      And I select "Event" from "Content type"
      And I select "Enabled" from "Likes"
  	  And I select "Hidden" from "Comments"
  	  And I press "Filter"
  	  And I wait 2 seconds
    # Filter settings don't revert
      And the "#edit-field-enable-likes-value option[selected='selected']" element should contain "Enabled"
      And the "#edit-field-comments-status option[selected='selected']" element should contain "Hidden"
  	# Assertions:
  	Then I should see "Event-Comments hidden & likes enabled"

  @api
  Scenario: Filter Content To View Pages With Likes Disabled And Comments Open
    Given I am logged in as a user with the "content_approver" role
      And I am viewing an "landing_page" content:
        | title              | Landing Page-Comments open & likes disabled |
        | moderation_state   | published                                   |
        | status             | 1                                           |
        | body               | This is the body                            |
        | field_comments     | 2                                           |
        | field_enable_likes | 0                                           |
      # Filtering:
    When I visit "/admin/content"
      And  I select "Published" from "Published status"
      And I select "Landing Page" from "Content type"
      And I select "Disabled" from "Likes"
  	  And I select "Open" from "Comments"
  	  And I press "Filter"
  	  And I wait 2 seconds
      # Filter settings dont revert
      And the "#edit-field-enable-likes-value option[selected='selected']" element should contain "Disabled"
      And the "#edit-field-comments-status option[selected='selected']" element should contain "Open"
  	  # Assertions:
  	Then I should see "Landing Page-Comments open & likes disabled"

  @api
  Scenario: Filter Content To View Pages With Likes Disabled And Comments Closed
    Given I am logged in as a user with the "content_approver" role
      And I am viewing an "landing_page" content:
        | title              | Landing Page-Comments closed & likes disabled |
        | moderation_state   | published                                     |
        | status             | 1                                             |
        | body               | This is the body                              |
        | field_comments     | 1                                             |
        | field_enable_likes | 0                                             |
      # Filtering:
  	When I visit "/admin/content"
      And I select "Published" from "Published status"
      And I select "Landing Page" from "Content type"
      And I select "Disabled" from "Likes"
  	  And I select "Closed" from "Comments"
  	  And I press "Filter"
  	  And I wait 2 seconds
      # Filter settings dont revert
      And the "#edit-field-enable-likes-value option[selected='selected']" element should contain "Disabled"
      And the "#edit-field-comments-status option[selected='selected']" element should contain "Closed"
  	  # Assertions:
  	Then I should see "Landing Page-Comments closed & likes disabled"

  @api
  Scenario: Filter Content To View Pages With Likes Disabled And Comments Hidden
    Given I am logged in as a user with the "sitebuilder" role
      And I am viewing an "event" content:
        | title              | Event-Comments hidden & likes disabled |
        | moderation_state   | published                              |
        | status             | 1                                      |
        | body               | This is the body                       |
        | field_comments     | 0                                      |
        | field_enable_likes | 0                                      |
      # Filtering:
    When I visit "/admin/content"
      And I select "Published" from "Published status"
      And I select "Event" from "Content type"
      And I select "Disabled" from "Likes"
  	  And I select "Hidden" from "Comments"
  	  And I press "Filter"
  	  And I wait 2 seconds
      # Filter settings dont revert
      And the "#edit-field-enable-likes-value option[selected='selected']" element should contain "Disabled"
      And the "#edit-field-comments-status option[selected='selected']" element should contain "Hidden"
  	  # Assertions:
    Then I should see "Event-Comments hidden & likes disabled"

  @api @javascript
  Scenario Outline: Saving Node Comment Delete Configs
    Given I am logged in as a user with the "sitebuilder" role
    When I visit "<link>"
      And I press "Save settings"
    Then I should see the text "Saved Comments configuration."
      And I should not see the text "Comment delete default selected operation must be on of the allowed operations."
  
    Examples:
      | link                                                                                             |
      | /admin/structure/types/manage/announcement/fields/node.announcement.field_comments               |
      | /admin/structure/types/manage/event/fields/node.event.field_comments                             |
      | /admin/structure/types/manage/form/fields/node.form.field_comments                               |
      | /admin/structure/types/manage/gallery/fields/node.gallery.field_comments                         |
      | /admin/structure/types/manage/landing_page/fields/node.landing_page.field_comments               |
      | /admin/structure/types/manage/library_item/fields/node.library_item.field_comments               |
      | /admin/structure/types/manage/operating_procedure/fields/node.operating_procedure.field_comments |
      | /admin/structure/types/manage/page/fields/node.page.field_comments                               |
      | /admin/structure/types/manage/secr/fields/node.secr.field_comments                               |
      | /admin/structure/types/manage/video/fields/node.video.field_comments                             |
      | /admin/structure/types/manage/sec_article/fields/node.sec_article.field_comments                 |

  @api
  Scenario: Warning message about database entry deletion in Comment View
   Given I am logged in as a user with the "content_approver" role
   When I visit "/admin/content/comment"
   Then I should see the text "STOP!"
     And I should see the text "Using this page to delete comments is permanent."
     And I should see the text "Comments deleted using this page cannot be restored."

  @api @javascript
  Scenario: Soft Deleting a comment shows confirmation message
    Given I am logged in as a user with the "Authenticated user" role
      And "announcement" content:
        | title                            | field_short_title | body | published_at | promote | status | field_comments |
        | Comment and Reply Delete Testing | Delete testing    | test | 2022-11      | 1       | 1      | 2              |
    When I visit "/announcements/2022-11/comment-and-reply-delete-testing"
      And I fill in "Comment" with "This is my first comment"
      And I press "Save"
      And I click "Reply"
      And I fill in "Comment" with "This is a reply to my first comment"
      And I press "Save"
    Then I should see the text "This is a reply to my first comment"
    When I am logged in as a user with the "content_approver" role
      And I visit "/admin/content/comment"
      And I fill in "Subject" with "This is"
      And I press the "Apply" button
      And I click the sort filter "Updated"
      And I wait 2 seconds
      And I click on the element with css selector ".dropbutton-arrow"
      And I click "Delete"
      And I press the "Delete" button
      And I visit "/announcements/2022-11/comment-and-reply-delete-testing"
    Then I should not see the text "This is my first comment"
      And I should see the text "This comment has been deleted"
      And I should see the text "This is a reply to my first comment"

  @api @javascript
  Scenario: Hard deleting a comment removes it and its replies from the database
    Given I am logged in as a user with the "Authenticated user" role
      And "announcement" content:
        | title                            | field_short_title | body | published_at | promote | status | field_comments |
        | Comment and Reply Delete Testing | Delete testing    | test | 2022-11      | 1       | 1      | 2              |
    When I visit "/announcements/2022-11/comment-and-reply-delete-testing"
      And I fill in "Comment" with "This is my first comment"
      And I press "Save"
      And I click "Reply"
      And I fill in "Comment" with "This is a reply to my first comment"
      And I press "Save"
    Then I should see the text "This is a reply to my first comment"
    When I am logged in as a user with the "content_approver" role
      And I visit "/admin/content/comment"
      And I fill in "Subject" with "This is"
      And I press the "Apply" button
      And I click the sort filter "Updated"
      And I wait 2 seconds
      And I click on the element with css selector ".dropbutton-arrow"
      And I click "Delete"
      And I click the input with the value "hard"
      And I press the "Delete" button
      And I wait 2 seconds
    Then I should not see the text "This is my first comment"
      And I should not see the text "This is a reply to my first comment"
