Feature: Create and View Library Item Content
As a Visitor to the Insider
I want to be able to view library items
So that I can learn information about database guides

  Background:

  Given "topic" terms:
      | name            |
      | Technology      |
      | Human Resources |
    And "office_division" terms:
      | name                |
      | DERA                |
      | Corporation Finance |
    And "top_level_group" terms:
      | name     | field_abbreviation |
      | group    | grp                |
      | sports   | spt                |
      | toplevel |                    |
    And "category" terms:
       | name     |
       | tennis   |
       | baseball |

@api @javascript
Scenario: Create a library item through the UI
  Given I am logged in as a user with the "administrator" role
  When I visit "/node/add/library_item"
    And I fill in the following:
      | Title  | Library item test |
      | Vendor | Vendor field      |
      | Format | Format field      |
    And I type "This is the Description" in the "Description" WYSIWYG editor
    And I type "how to access field" in the "How to Access" WYSIWYG editor
    And I type "John at 703-123-4567" in the "Contact for Questions" WYSIWYG editor
    And I select "Corporation Finance" from "Division / Office"
    And I select "Technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I publish it
  Then I should see the heading "Library item test"
    And I should see the text "How to Access"
    And I should see the text "how to access field"
    And I should see the text "Contact For Questions"
    And I should see the text "John at 703-123-4567"

@api
Scenario: View a library item Details on detail Page
  Given I am logged in as a user with the "Authenticated user" role
  When I am viewing an "library_item" content:
    | title        | Free Ice Cream Today |
    | field_vendor | vendor 1             |
    | field_format | format field         |
  Then I should see the heading "Free Ice Cream Today"
    And I should see the text "vendor 1"
    And I should see the text "format field"

@api @javascript
Scenario: Library Description is Limited to 600 Characters
  Given I am logged in as a user with the "administrator" role
    And I am on "/admin/content"
    And I fill in "Databases and Datasets - HOLD for now" for "Title"
    And I press "Filter"
    And I check the box "edit-node-bulk-form-0"
    And I select "Set Content as Published" from "action"
    And I press "edit-submit"
  When I visit "/node/add/library_item"
    And I fill in the following:
      | Title  | BEHAT Test content |
      | Vendor | Diamond            |
      | Format | HTML               |
    And I type "Books, mails, articles, novels, poems, and short stories are likely used much lesser as past time. The modern letters we have today are still being used in selected areas, but not as much as these were before. Basically, these are now used to express one’s feelings or authority, which is partnered by monitoring the number of characters or letters. And modern technology has made it easier and simpler through using softwares and electronic counters. People can even now use popular social media sites, which include character counters for articles and letters. People can even now use popular social media sites." in the "Description" WYSIWYG editor
    And I type "John at 703-123-4567" in the "Contact for Questions" WYSIWYG editor
    And I select "Technology" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I publish it
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/research-resources/databases-and-datasets-hold-now"
  Then I should see the text "Books, mails, articles, novels, poems, and short stories are likely used much lesser as past time. The modern letters we have today are still being used in selected areas, but not as much as these were before. Basically, these are now used to express one’s feelings or authority, which is partnered by monitoring the number of characters or letters. And modern technology has made it easier and simpler through using softwares and electronic counters. People can even now use popular social media sites, which include character counters for articles and letters"
    And I should not see the text "Books, mails, articles, novels, poems, and short stories are likely used much lesser as past time. The modern letters we have today are still being used in selected areas, but not as much as these were before. Basically, these are now used to express one’s feelings or authority, which is partnered by monitoring the number of characters or letters. And modern technology has made it easier and simpler through using softwares and electronic counters. People can even now use popular social media sites, which include character counters for articles and letters. People can even now use popular social media sites."

@api
Scenario: View a library item Details on List Page
  Given I am logged in as a user with the "Authenticated user" role
    And "library_item" content:
      | title                                              | field_vendor | body          | status |
      | Free Ice Cream Today                               | vendor 1     | description 1 | 1      |
      | Sign Up For Benefits By Friday                     | vendor 2     | description 2 | 1      |
      | All Hands Meeting                                  | vendor 5     | description 5 | 0      |
      | Lorem ipsum dolor sit amet, consectetur adipiscing | vendor 6     | description 6 | 0      |
      | Aliquam sagittis turpis in malesuada mollis.       | vendor 7     | description 7 | 1      |
      | Pellentesque in ex non velit convallis varius.     | vendor 8     | description 8 | 1      |
  When I am on "/research-resources/databases-and-datasets-hold-now"
  Then I should see the link "Free Ice Cream Today"
    And I should see the text "description 1"
    And I should see the link "Sign Up For Benefits By Friday"
    And I should see the link "Aliquam sagittis turpis in malesuada mollis."
    And I should see the link "Pellentesque in ex non velit convallis varius."
    And I should not see the link "All Hands Meeting"
    And I should not see the text "description 5"
    And I should not see the link "Lorem ipsum dolor sit amet, consectetur adipiscing"

@api
Scenario: Default Sorting by title ascending on Library Databases and Datasets List Page
  Given I am logged in as a user with the "Authenticated user" role
    And "library_item" content:
      | title                                              | field_vendor | body          | status |
      | Free Ice Cream Today                               | vendor 1     | description 1 | 1      |
      | Sign Up For Benefits By Friday                     | vendor 2     | description 2 | 1      |
      | Early Dismissal                                    | vendor 3     | description 3 | 1      |
      | New Director of Enforcement Joins                  | vendor 4     | description 4 | 1      |
      | All Hands Meeting                                  | vendor 5     | description 5 | 1      |
      | Lorem ipsum dolor sit amet, consectetur adipiscing | vendor 6     | description 6 | 0      |
      | Aliquam sagittis turpis in malesuada mollis.       | vendor 7     | description 7 | 1      |
      | Pellentesque in ex non velit convallis varius.     | vendor 8     | description 8 | 1      |
  When I am on "/research-resources/databases-and-datasets-hold-now"
  Then "Early Dismissal" should precede "Free Ice Cream Today" for the query "//*[@class ='media-heading']/a"
    And "All Hands Meeting" should precede "Sign Up For Benefits By Friday" for the query "//*[@class ='media-heading']/a"
    And "Aliquam sagittis turpis in malesuada mollis." should precede "Pellentesque in ex non velit convallis varius." for the query "//*[@class ='media-heading']/a"
    And "New Director of Enforcement Joins" should precede "Sign Up For Benefits By Friday" for the query "//*[@class ='media-heading']/a"

@api
Scenario: Library Databases and Datasets Pagination for 10 Items
  Given I am logged in as a user with the "Authenticated user" role
    And "library_item" content:
      | title                                              | field_vendor | body           | status |
      | Free Ice Cream Today                               | vendor 1     | description 1  | 1      |
      | Sign Up For Benefits By Friday                     | vendor 2     | description 2  | 1      |
      | Early Dismissal                                    | vendor 3     | description 3  | 1      |
      | New Director of Enforcement Joins                  | vendor 4     | description 4  | 1      |
      | All Hands Meeting                                  | vendor 5     | description 5  | 0      |
      | Lorem ipsum dolor sit amet, consectetur adipiscing | vendor 6     | description 6  | 0      |
      | Aliquam sagittis turpis in malesuada mollis.       | vendor 7     | description 7  | 1      |
      | Pellentesque in ex non velit convallis varius.     | vendor 8     | description 8  | 1      |
      | Pellentesque in ex non velit convallis varius.     | vendor 9     | description 9  | 1      |
      | Aliquam sagittis turpis in malesuada mollis.       | vendor 10    | description 10 | 1      |
      | Pellentesque in ex non velit convallis varius.     | vendor 11    | description 11 | 1      |
      | Pellentesque in ex non velit convallis varius.     | vendor 12    | description 12 | 1      |
      | Pellentesque in ex non velit convallis varius.     | vendor 13    | description 13 | 1      |
  When I visit "/research-resources/databases-and-datasets-hold-now"
  Then I should see the text "1 to 10 of 11 items"
    And I should see the link "2"

@api @javascript
Scenario: Search a library item by Title
  Given I am logged in as a user with the "Authenticated user" role
    And "library_item" content:
      | title                                              | field_vendor | body          | status |
      | Free Ice Cream Today                               | vendor 1     | description 1 | 1      |
      | Sign Up For Benefits By Friday                     | vendor 2     | description 2 | 1      |
      | Early Dismissal                                    | vendor 3     | description 3 | 1      |
      | New Director of Enforcement Joins                  | vendor 4     | description 4 | 1      |
      | All Hands Meeting                                  | vendor 5     | description 5 | 0      |
      | Lorem ipsum dolor sit amet, consectetur adipiscing | vendor 6     | description 6 | 0      |
      | Aliquam sagittis turpis in malesuada mollis.       | vendor 7     | description 7 | 1      |
      | Pellentesque in ex non velit convallis varius.     | vendor 8     | description 8 | 1      |
  When I visit "/research-resources/databases-and-datasets-hold-now"
    And I fill in "combine" with "Free Ice Cream Today"
    And I press "edit-submit-library-databases-and-datasets"
  Then the search results should show the link "Free Ice Cream Today"
    But I should not see the link "Sign Up For Benefits By Friday"
    And I should not see the link "Early Dismissal"
    And I should not see the link "New Director of Enforcement Joins"
    And I should not see the link "All Hands Meeting"

@api @javascript
Scenario: Search a library item by Description
  Given I am logged in as a user with the "Authenticated user" role
    And "library_item" content:
      | title                                              | field_vendor | body                    | status |
      | Free Ice Cream Today                               | magnis       | Lorem ipsum             | 1      |
      | Sign Up For Benefits By Friday                     | parturient   | dolor sit amet          | 1      |
      | Early Dismissal                                    | montes       | consectetuer adipiscing | 1      |
      | New Director of Enforcement Joins                  | nascetur     | Aenean commodo          | 1      |
      | All Hands Meeting                                  | ridiculus    | ligula eget dolor       | 0      |
      | Lorem ipsum dolor sit amet, consectetur adipiscing | consequat    | Aenean massa            | 0      |
      | Aliquam sagittis turpis in malesuada mollis.       | venenatis    | Cum sociis              | 1      |
      | Pellentesque in ex non velit convallis varius.     | vulputate    | natoque penatibus       | 1      |
  When I visit "/research-resources/databases-and-datasets-hold-now"
    And I fill in "combine" with "consectetuer adipiscing"
    And I press "edit-submit-library-databases-and-datasets"
  Then the search results should show the link "Early Dismissal"
    But I should not see the link "Free Ice Cream Today"
    And I should not see the link "Sign Up For Benefits By Friday"
    And I should not see the link "New Director of Enforcement Joins"
    And I should not see the link "All Hands Meeting"

@api @javascript
Scenario: Search a library item by Vendor
  Given I am logged in as a user with the "Authenticated user" role
    And "library_item" content:
      | title                                              | field_vendor | body                    | status |
      | Free Ice Cream Today                               | magnis       | Lorem ipsum             | 1      |
      | Sign Up For Benefits By Friday                     | parturient   | dolor sit amet          | 1      |
      | Early Dismissal                                    | montes       | consectetuer adipiscing | 1      |
      | New Director of Enforcement Joins                  | nascetur     | Aenean commodo          | 1      |
      | All Hands Meeting                                  | ridiculus    | ligula eget dolor       | 0      |
      | Lorem ipsum dolor sit amet, consectetur adipiscing | consequat    | Aenean massa            | 0      |
      | Aliquam sagittis turpis in malesuada mollis.       | venenatis    | Cum sociis              | 1      |
      | Pellentesque in ex non velit convallis varius.     | vulputate    | natoque penatibus       | 1      |
  When I visit "/research-resources/databases-and-datasets-hold-now"
    And I fill in "combine" with "nascetur"
    And I press "edit-submit-library-databases-and-datasets"
  Then the search results should show the link "New Director of Enforcement Joins"
    And I should see the text "Aenean commodo"
    But I should not see the link "Free Ice Cream Today"
    And I should not see the link "Sign Up For Benefits By Friday"
    And I should not see the link "Early Dismissal"
    And I should not see the link "All Hands Meeting"

@api @javascript
Scenario: Create LinkIt Link to Library Item
  Given I am logged in as a user with the "content_approver" role
    And "library_item" content:
      | title             | field_vendor | field_format | body                  | field_contact_for_questions | field_topic | field_top_level_group | status | nid     |
      | Bloomberg Service | Bloomberg    | web-based    | Bloomberg description | John Smith                  | Technology  | Sports                | 1      | 6666666 |
  When I visit "/node/add/sec_article"
    And I fill in the following:
        | Title                                             | BEHAT Library Item LinkIt Link  |
        #| edit-field-retain-disposal-date-0-value-date      | 09/11/2020                      |
    And I type "This is a source" in the "Source" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the WYSIWYG Toolbar
    And I fill in "URL" with "/node/6666666"
    And I click "Save" on the modal "Add Link"
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I fill in "Display Text" with "Bloomberg External Service"
    And I press the "OK" button
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Policy" from "Article Type"
    And I select "Technology" from "Topic"
    And I select "sports" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I should see the heading "BEHAT Library Item LinkIt Link"
    And I should see the link "Bloomberg External Service"
    And I click "Bloomberg External Service"
    And I should see the heading "Bloomberg Service"
