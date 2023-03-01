Feature: View Announcement Content
As a Visitor to the Insider
I want to be able to view announcements
So that I can be kept up to date on the latest important content on the Insider

Background:

  Given "audiences" terms:
    | name    |
    | Insider |
    | Lawyer  |
    And "topic" terms:
      | name   |
      | techno |
      | hr     |
      | behat  |
    And "office_division" terms:
      | name        |
      | Enforcement |
      | DERA        |
    And "group_club" terms:
      | name   |
      | Poker  |
      | Soccer |
    And "top_level_group" terms:
      | name     |
      | toplevel |
      | sports   |
      | SEC.gov  |
    And "timezone" terms:
      | name    | field_abbreviation |
      | Eastern | ET                 |

  @api @javascript
  Scenario: Create an announcement
    Given I am logged in as a user with the "content_approver" role
    When I visit "/node/add/announcement"
      And I fill in the following:
        | Title           | Test Title  |
        | Home Page Title | short title |
      And I type "Testing Teaser" in the "Teaser" WYSIWYG editor
      And I type "Testing body" in the "Body" WYSIWYG editor
      And I type "Testing source" in the "Source" WYSIWYG editor
      And I scroll to the top
      And I click "Exchange Details"
      And I select "toplevel" from "Top Level Group"
      And I select "Insider" from "Audience"
      And I additionally select "Lawyer" from "Audience"
      And I select "Enforcement" from "Division / Office"
      And I additionally select "DERA" from "Division / Office"
      And I select "techno" from "Topic"
      And I additionally select "hr" from "Topic"
      And I select "Poker" from "Group/Club"
      And I additionally select "Soccer" from "Group/Club"
      And I publish it
    Then I see the heading "Test Title"
      And I should see the text "Testing body"
    But I should not see the text "short title"

#TODO Scenario: Create an Obituary Through the UI - check other types as well
#It has different required fields we should test

@api @javascript
Scenario: Teaser Text is Limited to 250 Characters
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/announcement"
    And I fill in the following:
      | Title           | BEHAT Test Title     |
      | Home Page Title | BEHAT Homepage Title |
    And I type "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla rhoncus, dolor nec mattis maximus, dui felis viverra neque, at ultrices ante purus ac augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; metus.1" in the "Teaser" WYSIWYG editor
    And I type "Testing source" in the "Source" WYSIWYG editor
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "techno" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I click secondary option "Promotion options"
    And I fill in "edit-promote-value" with "1"
    And I publish it
    And I am on the homepage
  Then I should not see the link "BEHAT Test Title"
    And I should see the link "BEHAT Homepage Title"
    But I should not see the text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla rhoncus, dolor nec mattis maximus, dui felis viverra neque, at ultrices ante purus ac augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; metus.1"

@api
Scenario: View Announcement Details on List Page
  Given I am logged in as a user with the "Authenticated user" role
    And "announcement" content:
      | title                             | field_short_title | body   | published_at | status | field_announcement_type |
      | Free Ice Cream Today              | Free today        | Test 1 | now          | 1      | Obituary                |
      | Sign Up For Benefits By Friday    |                   | Test 2 | -5 day       | 1      | Memorandum              |
      | Early Dismissal                   |                   | Test 3 | -2 day       | 1      |                         |
      | New Director of Enforcement Joins | New DOE joins     | Test 4 | +1 day       | 1      | Obituary                |
      | Impacts from the Hurricane        |                   | Test 5 | -1 month     | 1      | Memorandum              |
      | Vigil Held for 9/11               |                   | Test 6 | -1 month     | 0      |                         |
      | Pizza Party Planned               |                   | Test 7 | +1 month     | 0      | Memorandum              |
  When I visit "/announcements"
  Then I should see the heading "Announcements"
    And I should see the date "now" in the "Free Ice Cream Today" row
    And I should see "Obituary" in the "Free Ice Cream Today" row
    And I should see "Memorandum" in the "Impacts from the Hurricane" row
    And I should see the date "-5 day" in the "Sign Up For Benefits By Friday" row
    And I should see the date "-2 day" in the "Early Dismissal" row
    And I should see the date "-1 month" in the "Impacts from the Hurricane" row
    And I should see the date "+1 day" in the "New Director of Enforcement Joins" row
    And I should not see the link "Vigil Held for 9/11"
    And I should not see the link "Pizza Party Planned"
    And I should not see the text "Free today"
    And I should not see the text "New DOE joins"

@api @javascript
Scenario: Sorting And Pagination On Announcements List Page
  Given "announcement" content:
    | title                                       | body   | published_at        | status | field_announcement_type |
    | 1 Free Ice Cream Today                      | Test 1 | 2030-07-23 12:00:00 | 1      |                         |
    | 2 Detail Opportunities                      | Test 2 | 2030-01-29 12:00:00 | 1      |                         |
    | 2 New Personal Development                  | Test 3 | 2030-02-28 12:00:00 | 1      | Obituary                |
    | 2018 FINRA Annual WebCast                   | Test 4 | 2030-03-29 12:00:00 | 1      | Memorandum              |
    | 2 Reminiders: Annual Certification          | Test 5 | 2030-04-29 12:00:00 | 1      | Memorandum              |
    | All Hands Meeting                           | Test 6 | 2030-05-29 12:00:00 | 1      | Memorandum              |
    | Access to Capital                           | Test 7 | 2030-06-29 12:00:00 | 1      | Memorandum              |
    | 6th Annual Conference                       | Test 8 | 2030-07-29 12:00:00 | 1      | Memorandum              |
    | A Message from chairman                     | Test 8 | 2030-08-29 12:00:00 | 1      | Memorandum              |
    | A New Year                                  | Test 8 | 2030-09-29 12:00:00 | 1      | Memorandum              |
    | Administrative and Support professionals    | Test 8 | 2030-09-20 12:00:00 | 1      | Memorandum              |
    | Big Data Webinar Series – Intermediate      | Test 8 | 2030-05-19 12:00:00 | 1      | Memorandum              |
    | Big Data Webinar Series – Advanced          | Test 8 | 2029-06-29 12:00:00 | 1      | Memorandum              |
    | Jewish American Heritage Book Club Meeting  | Test 8 | 2029-06-29 12:00:00 | 1      | Memorandum              |
    | Detail Opportunity for Risk Officer in OCOO | Test 8 | 2029-06-09 12:00:00 | 1      | Memorandum              |
    | SEC Celebrates Women’s History Month        | Test 8 | 2029-06-01 12:00:00 | 1      | Memorandum              |
    | Voluntary Reassignment Program Update       | Test 8 | 2031-01-02 12:00:00 | 1      | Memorandum              |
    | Voluntary Reassignment Program Update2      | Test 8 | 2031-03-19 12:00:00 | 1      | Memorandum              |
    | Veterans Committee Quarterly Meeting        | Test 8 | 2031-03-29 12:00:00 | 1      | Memorandum              |
    | Get Control! of iPhone and iPad             | Test 8 | 2031-04-26 12:00:00 | 1      | Memorandum              |
    | CLD 107 – Building Emotional Intelligence   | Test 8 | 2031-05-23 12:00:00 | 1      | Memorandum              |
    | Call for Interested Applicants              | Test 8 | 2030-06-10 12:00:00 | 1      | Memorandum              |
    | Early Dismissal for Thanksgiving            | Test 8 | 2030-07-01 12:00:00 | 1      | Memorandum              |
    | Early Dismissal for Labor Day Weekend       | Test 8 | 2030-07-14 12:00:00 | 1      | Memorandum              |
    | Women’s Committee Quarterly Meeting         | Test 8 | 2029-07-29 12:00:00 | 1      | Memorandum              |
    | Yellow Dress code on July 20th              | Test 8 | 2029-03-29 12:00:00 | 1      | Memorandum              |
    | The New York City Announcement              | Test 8 | 2029-02-20 12:00:00 | 1      | Memorandum              |
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/announcements"
    And I select "10" from "Show"
    And I click "Title"
    And I wait for ajax to finish
  Then "1 Free Ice Cream Today" should precede "2 Detail Opportunities" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "2 Detail Opportunities" should precede "2 New Personal Development" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "2 New Personal Development" should precede "2 Reminiders: Annual Certification" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "2 Reminiders: Annual Certification" should precede "2018 FINRA Annual WebCast" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "All Hands Meeting" should precede "Big Data Webinar Series – Advanced" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And I scroll to the bottom
  When I click "Next"
    And I wait for ajax to finish
  Then "Big Data Webinar Series – Intermediate" should precede "Call for Interested Applicants" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Call for Interested Applicants" should precede "CLD 107 – Building Emotional Intelligence" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Early Dismissal for Thanksgiving" should precede "Get Control! of iPhone and iPad" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Jewish American Heritage Book Club Meeting" should precede "A Message from chairman" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "A Message from chairman" should precede "A New Year" for the query "//td[contains(@class, 'views-field views-field-title')]"
  When I click "Last"
    And I wait for ajax to finish
  Then "The New York City Announcement" should precede "SEC Celebrates Women’s History Month" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "SEC Celebrates Women’s History Month" should precede "Veterans Committee Quarterly Meeting" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Voluntary Reassignment Program Update" should precede "Women’s Committee Quarterly Meeting" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Women’s Committee Quarterly Meeting" should precede "Yellow Dress code on July 20th" for the query "//td[contains(@class, 'views-field views-field-title')]"
  When I click "sort by Date"
    And I wait for ajax to finish
  Then "Jun 9, 2029" should precede "Jun 1, 2029" for the query "//td[contains(@class, 'views-field views-field-field-combined-date')]"
    And "Jul 29, 2029" should precede "Jun 29, 2029" for the query "//td[contains(@class, 'views-field views-field-field-combined-date')]"
    And "Jun 1, 2029" should precede "Mar 29, 2029" for the query "//td[contains(@class, 'views-field views-field-field-combined-date')]"
  When I click "Previous"
    And I wait for ajax to finish
  Then "Feb 28, 2030" should precede "Jan 29, 2030" for the query "//td[contains(@class, 'views-field views-field-field-combined-date')]"
    And "Apr 29, 2030" should precede "Mar 29, 2030" for the query "//td[contains(@class, 'views-field views-field-field-combined-date')]"
    And "Jul 14, 2030" should precede "Jul 1, 2030" for the query "//td[contains(@class, 'views-field views-field-field-combined-date')]"
  When I click "First"
    And I wait for ajax to finish
  Then "May 23, 2031" should precede "Apr 26, 2031" for the query "//td[contains(@class, 'views-field views-field-field-combined-date')]"
    And "Jan 2, 2031" should precede "Sep 29, 2030" for the query "//td[contains(@class, 'views-field views-field-field-combined-date')]"
    And "Jul 29, 2030" should precede "Jul 23, 2030" for the query "//td[contains(@class, 'views-field views-field-field-combined-date')]"
  When I click "Announcement Type"
    And I wait for ajax to finish
  Then "1 Free Ice Cream Today" should precede "2 New Personal Development" for the query "//td[contains(@class, 'views-field views-field-title')]"
    And "Obituary" should precede "Memorandum" for the query "//td[contains(@class, 'views-field views-field-field-announcement-type')]"
  When I select "All" from "Show"
  Then I should see the text "1 to 27 of 27 items"

@api @javascript
Scenario: Announcements Override Modified Date Update
  Given "announcement" content:
    | title                             | field_short_title | body   | published_at | status | field_announcement_type | changed | field_source             | field_topic   | field_top_level_group | moderation_state | nid    |
    | Free Ice Cream Today              | freeice           | Test 1 | now          | 1      | Memorandum              | -1 day  | This is the source field | hr            | sports                | published        |        |
    | Sign Up For Benefits              | open enrollment   | Test 2 | -5 day       | 1      |                         | -2 day  | This is the source field | hr            | sports                | published        | 852020 |
    | Sean Taylor                       | rip sean taylor   | Test 3 | -2 day       | 1      | Obituary                | -3 day  | This is the source field | hr            | sports                | published        |        |
    | New Director of Enforcement Joins | new director      | Test 4 | +1 day       | 1      | Memorandum              | -4 day  | This is the source field | hr            | sports                | published        |        |
    | Impacts from the Hurricane        | hurricane season  | Test 5 | -1 month     | 1      | Memorandum              | -5 day  | This is the source field | hr            | sports                | published        |        |
    | All Hands Meeting                 | allhands          | Test 6 | -3 month     | 1      |                         | -6 day  | This is the source field | hr            | sports                | published        |        |
  When I am logged in as a user with the "Content Approver" role
    And I visit "/announcements"
    # Checking for usage of published date
  Then I should see the date "now" in the "Free Ice Cream Today" row
    And I should see the date "-5 day" in the "Sign Up For Benefits" row
    And I should see the date "-2 day" in the "Sean Taylor" row
    And I should see the date "+1 day" in the "New Director of Enforcement Joins" row
    And I should see the date "-1 month" in the "Impacts from the Hurricane" row
    And I should see the date "-3 month" in the "All Hands Meeting" row
  When I visit "/node/852020/edit"
    And I fill in "Title" with "Please Sign Up For Benefits"
    And I press "Save and Create New Draft"
    And I should see the text "Announcement Please Sign Up For Benefits has been updated."
    And I visit "/announcements"
  # Checking for published date doesn't update with Save and Create New Draft
  Then I should see the date "-5 day" in the "Sign Up For Benefits" row
  When I visit "/node/852020/edit"
    And I fill in "Title" with "Please Sign Up For Benefits During Open Enrollment"
    And I press the "List additional actions" button
    And I press the "Save and Request Review" button
  Then I should see the text "Announcement Please Sign Up For Benefits During Open Enrollment has been updated."
  When I visit "/announcements"
  # Checking for published date doesn't update with Save and Request Review
  Then I should see the date "-5 day" in the "Sign Up For Benefits" row
  When I visit "/node/852020/edit"
    And I click secondary option "Override Modified Date"
    And I fill in the following:
      | edit-field-override-modified-date-0-value-date | 11/29/2021 |
      | edit-field-override-modified-date-0-value-time | 01:00:00AM |
    And I publish it
  Then I should see the text "Announcement Please Sign Up For Benefits During Open Enrollment has been updated."
    And I should see the text "Nov. 29, 2021"
  When I visit "/announcements"
  # Checking for date updated to override modified date
  Then I should see the text "Nov 29, 2021" in the "Please Sign Up For Benefits During Open Enrollment" row
  # Checking for /year-month path update
    And the hyperlink "Please Sign Up For Benefits During Open Enrollment" should match the Drupal url "/announcements/2021-11/please-sign-benefits-during-open-enrollment"
    And I scroll to the bottom
  When I click "Please Sign Up For Benefits During Open Enrollment"
  Then I should be on "/announcements/2021-11/please-sign-benefits-during-open-enrollment"
    And I should see the text "Nov. 29, 2021"
  When I visit "/announcements/2021-11/please-sign-benefits-during-open-enrollment/edit"
    And I click secondary option "Override Modified Date"
    And I fill in the following:
      | edit-field-override-modified-date-0-value-date | 12/01/2021 |
      | edit-field-override-modified-date-0-value-time | 00:01:00AM |
    And I publish it
    And I should see the text "Dec. 1, 2021"
  Then I should see the text "Announcement Please Sign Up For Benefits During Open Enrollment has been updated."
  When I am logged in as a user with the "Authenticated user" role
    And I visit "/announcements"
  # Checking for date updated for another override modified date as well as /year-month path update
  Then I should see the text "Dec 1, 2021" in the "Please Sign Up For Benefits During Open Enrollment" row
    And the hyperlink "Please Sign Up For Benefits During Open Enrollment" should match the Drupal url "/announcements/2021-12/please-sign-benefits-during-open-enrollment"
  When I click "Please Sign Up For Benefits During Open Enrollment"
  Then I should be on "/announcements/2021-12/please-sign-benefits-during-open-enrollment"
    And I should see the text "Dec. 1, 2021"

@api
Scenario: Announcement Pagination for Less than 50 Items
  Given I am logged in as a user with the "Authenticated user" role
    And "announcement" content:
      | title                                                                         | body    | published_at | status |
      | Free Ice Cream Today                                                          | Test 1  | now          | 1      |
      | Sign Up For Benefits By Friday                                                | Test 2  | -5 day       | 1      |
      | Early Dismissal                                                               | Test 3  | -2 day       | 1      |
      | New Director of Enforcement Joins                                             | Test 4  | +1 day       | 1      |
      | Impacts from the Hurricane                                                    | Test 5  | -1 month     | 1      |
      | All Hands Meeting                                                             | Test 7  | -5 month     | 1      |
      | Lorem ipsum dolor sit amet, consectetur adipiscing elit.                      | Test 8  | -2 month     | 1      |
      | Aliquam sagittis turpis in malesuada mollis.                                  | Test 9  | -6 month     | 1      |
      | Pellentesque in ex non velit convallis varius.                                | Test 10 | -7 month     | 1      |
      | Praesent maximus felis in quam pulvinar pharetra.                             | Test 11 | -8 month     | 1      |
      | Cras laoreet metus et lectus mollis sollicitudin.                             | Test 12 | -9 month     | 1      |
      | Phasellus imperdiet libero ac metus dapibus efficitur id vitae justo.         | Test 13 | -10 month    | 1      |
      | Etiam eu nunc porta, elementum sem a, interdum odio.                          | Test 14 | -2 month     | 1      |
      | Donec viverra nibh ac tincidunt pharetra.                                     | Test 15 | -3 month     | 1      |
      | Nulla sit amet tellus at urna sodales vulputate.                              | Test 16 | -4 month     | 1      |
      | Aliquam iaculis metus non ullamcorper pulvinar.                               | Test 17 | -5 month     | 1      |
      | Quisque maximus elit id velit scelerisque lobortis.                           | Test 18 | -6 month     | 1      |
      | Praesent ultrices ipsum sit amet rutrum iaculis.                              | Test 19 | -7 month     | 1      |
      | Pellentesque ut erat vel sem auctor finibus.                                  | Test 20 | -8 month     | 1      |
      | Aliquam dictum tellus vel ornare dignissim.                                   | Test 21 | -11 month    | 1      |
      | Ut eget nunc ac nunc mollis aliquet quis eget mi.                             | Test 22 | -22 month    | 1      |
      | Fusce dapibus tortor eget ipsum ultricies lacinia.                            | Test 23 | -1 month     | 1      |
      | Vestibulum nec dui facilisis, condimentum turpis ut, congue sem.              | Test 24 | -1 month     | 1      |
      | In pharetra justo ac turpis bibendum, quis suscipit elit ullamcorper.         | Test 25 | -1 month     | 1      |
      | Curabitur molestie metus ut mauris venenatis, quis tincidunt lectus volutpat. | Test 26 | -2 month     | 1      |
      | Curabitur maximus tellus ac feugiat gravida.                                  | Test 27 | -2 month     | 1      |
      | Integer venenatis leo quis ante blandit, sit amet porttitor nunc dapibus.     | Test 28 | -2 month     | 1      |
      | Suspendisse id justo ornare, euismod odio eget, mattis quam.                  | Test 29 | -3 month     | 1      |
      | Vivamus finibus purus id maximus elementum.                                   | Test 30 | -3 month     | 1      |
      | Praesent ornare erat id metus gravida, sed efficitur eros commodo.            | Test 31 | -3 month     | 1      |
      | Nullam sit amet lorem vel arcu condimentum posuere in ut dui.                 | Test 32 | -4 month     | 1      |
      | Nulla efficitur leo vitae velit aliquet, nec consectetur ex tempor.           | Test 33 | -4 month     | 1      |
      | Etiam aliquet est vel tempor efficitur.                                       | Test 34 | -4 month     | 1      |
      | Fusce tincidunt ligula in leo pharetra, id mollis felis egestas.              | Test 35 | -4 month     | 1      |
      | Pellentesque porttitor dui ut vehicula consectetur.                           | Test 36 | -15 month    | 1      |
      | Suspendisse luctus nunc at nisl dictum, vel dignissim diam vehicula.          | Test 37 | -15 month    | 1      |
      | Aenean mollis turpis a risus facilisis, at feugiat dolor vehicula.            | Test 38 | -31 month    | 1      |
      | Sed et ipsum bibendum, malesuada neque at, fermentum nibh.                    | Test 39 | -15 month    | 1      |
      | Vivamus dapibus dui nec neque gravida, a vulputate libero vulputate.          | Test 40 | -22 month    | 1      |
      | Suspendisse egestas ex a quam dapibus, sed venenatis purus consequat.         | Test 41 | -23 month    | 1      |
      | Suspendisse eget massa sit amet magna vulputate semper.                       | Test 42 | -24 month    | 1      |
      | In non urna non odio molestie facilisis.                                      | Test 43 | -17 month    | 1      |
      | Mauris aliquet elit auctor ante tincidunt cursus.                             | Test 44 | -18 month    | 1      |
      | Aliquam fringilla mi id nibh vestibulum cursus.                               | Test 45 | -19 month    | 1      |
      | Vivamus sit amet purus vel urna hendrerit gravida.                            | Test 46 | -20 month    | 1      |
      | Nulla ac elit ac augue bibendum consequat pellentesque id est.                | Test 47 | -1 month     | 1      |
      | Nulla malesuada mi vel suscipit auctor.                                       | Test 48 | -2 month     | 1      |
      | Morbi vel libero eget nunc mollis hendrerit.                                  | Test 49 | -3 month     | 1      |
      | Vestibulum at odio viverra, tempus odio nec, dapibus lacus.                   | Test 50 | -4 month     | 1      |
  When I visit "/announcements"
  Then I should see the text "1 to 49 of 49"
    And I should not see the link "Page 2"

@api @javascript
Scenario: Validate Announcements Search Pager
  Given I am logged in as a user with the "Authenticated user" role
    And "announcement" content:
      | title                                                                         | body    | published_at | status |
      | Free Ice Cream Today                                                          | Test 1  | now          | 1      |
      | Sign Up For Benefits By Friday                                                | Test 2  | -5 day       | 1      |
      | Early Dismissal                                                               | Test 3  | -2 day       | 1      |
      | New Director of Enforcement Joins                                             | Test 4  | +1 day       | 1      |
      | Impacts from the Hurricane                                                    | Test 5  | -1 month     | 1      |
      | All Hands Meeting                                                             | Test 7  | -5 month     | 1      |
      | Lorem ipsum dolor sit amet, consectetur adipiscing elit.                      | Test 8  | -2 month     | 1      |
      | Aliquam sagittis turpis in malesuada mollis.                                  | Test 9  | -6 month     | 1      |
      | Pellentesque in ex non velit convallis varius.                                | Test 10 | -7 month     | 1      |
      | Praesent maximus felis in quam pulvinar pharetra.                             | Test 11 | -8 month     | 1      |
      | Cras laoreet metus et lectus mollis sollicitudin.                             | Test 12 | -9 month     | 1      |
      | Phasellus imperdiet libero ac metus dapibus efficitur id vitae justo.         | Test 13 | -10 month    | 1      |
      | Etiam eu nunc porta, elementum sem a, interdum odio.                          | Test 14 | -2 month     | 1      |
      | Donec viverra nibh ac tincidunt pharetra.                                     | Test 15 | -3 month     | 1      |
      | Nulla sit amet tellus at urna sodales vulputate.                              | Test 16 | -4 month     | 1      |
      | Aliquam iaculis metus non ullamcorper pulvinar.                               | Test 17 | -5 month     | 1      |
      | Quisque maximus elit id velit scelerisque lobortis.                           | Test 18 | -6 month     | 1      |
      | Praesent ultrices ipsum sit amet rutrum iaculis.                              | Test 19 | -7 month     | 1      |
      | Pellentesque ut erat vel sem auctor finibus.                                  | Test 20 | -8 month     | 1      |
      | Aliquam dictum tellus vel ornare dignissim.                                   | Test 21 | -11 month    | 1      |
      | Ut eget nunc ac nunc mollis aliquet quis eget mi.                             | Test 22 | -22 month    | 1      |
      | Fusce dapibus tortor eget ipsum ultricies lacinia.                            | Test 23 | -1 month     | 1      |
      | Vestibulum nec dui facilisis, condimentum turpis ut, congue sem.              | Test 24 | -1 month     | 1      |
      | In pharetra justo ac turpis bibendum, quis suscipit elit ullamcorper.         | Test 25 | -1 month     | 1      |
      | Curabitur molestie metus ut mauris venenatis, quis tincidunt lectus volutpat. | Test 26 | -2 month     | 1      |
      | Curabitur maximus tellus ac feugiat gravida.                                  | Test 27 | -2 month     | 1      |
      | Integer venenatis leo quis ante blandit, sit amet porttitor nunc dapibus.     | Test 28 | -2 month     | 1      |
      | Suspendisse id justo ornare, euismod odio eget, mattis quam.                  | Test 29 | -3 month     | 1      |
      | Vivamus finibus purus id maximus elementum.                                   | Test 30 | -3 month     | 1      |
      | Praesent ornare erat id metus gravida, sed efficitur eros commodo.            | Test 31 | -3 month     | 1      |
      | Nullam sit amet lorem vel arcu condimentum posuere in ut dui.                 | Test 32 | -4 month     | 1      |
      | Nulla efficitur leo vitae velit aliquet, nec consectetur ex tempor.           | Test 33 | -4 month     | 1      |
      | Etiam aliquet est vel tempor efficitur.                                       | Test 34 | -4 month     | 1      |
      | Fusce tincidunt ligula in leo pharetra, id mollis felis egestas.              | Test 35 | -4 month     | 1      |
      | Pellentesque porttitor dui ut vehicula consectetur.                           | Test 36 | -15 month    | 1      |
      | Suspendisse luctus nunc at nisl dictum, vel dignissim diam vehicula.          | Test 37 | -15 month    | 1      |
      | Aenean mollis turpis a risus facilisis, at feugiat dolor vehicula.            | Test 38 | -51 month    | 1      |
      | Sed et ipsum bibendum, malesuada neque at, fermentum nibh.                    | Test 39 | -15 month    | 1      |
      | Vivamus dapibus dui nec neque gravida, a vulputate libero vulputate.          | Test 40 | -22 month    | 1      |
      | Suspendisse egestas ex a quam dapibus, sed venenatis purus consequat.         | Test 41 | -23 month    | 1      |
      | Suspendisse eget massa sit amet magna vulputate semper.                       | Test 42 | -24 month    | 1      |
      | In non urna non odio molestie facilisis.                                      | Test 43 | -17 month    | 1      |
      | Mauris aliquet elit auctor ante tincidunt cursus.                             | Test 44 | -18 month    | 1      |
      | Aliquam fringilla mi id nibh vestibulum cursus.                               | Test 45 | -19 month    | 1      |
      | Vivamus sit amet purus vel urna hendrerit gravida.                            | Test 46 | -20 month    | 1      |
      | Nulla ac elit ac augue bibendum consequat pellentesque id est.                | Test 47 | -1 month     | 1      |
      | Nulla malesuada mi vel suscipit auctor.                                       | Test 48 | -2 month     | 1      |
      | Morbi vel libero eget nunc mollis hendrerit.                                  | Test 49 | -3 month     | 1      |
      | Vestibulum at odio viverra, tempus odio nec, dapibus lacus.                   | Test 50 | -4 month     | 1      |
      | Sed id leo sed neque pretium mattis.                                          | Test 51 | -5 month     | 1      |
      | Praesent nec arcu pharetra, condimentum felis nec, facilisis nunc.            | Test 52 | -6 month     | 1      |
      | Donec ac tortor sit amet purus sollicitudin semper quis vel augue.            | Test 53 | -7 month     | 1      |
      | Nunc nec lacus ac diam maximus venenatis.                                     | Test 54 | -8 month     | 1      |
  When I visit "/announcements"
  Then I should see the text "1 to 50 of 52"
    And I should see the link "Page 2"
  When I click "Page 2"
    And I wait for ajax to finish
  Then I should see the link "Suspendisse egestas ex a quam dapibus, sed venenatis purus consequat."
    And I should not see the link "New Director of Enforcements Joins"
  When I select "5" from "Show items per page"
    And I should see the text "6 to 10 of 52 items"
  When I click "Next ›"
    And I wait for ajax to finish
  Then I should see the text "11 to 15 of 52 items"
  When I visit "/announcements"
  When I fill in "Search" with "Free Ice Cream Today" in the "filters" region
    And I press "Search" in the "filters" region
  Then I should see the text "1 to 1 of 1 items"
  When I press the "Reset" button
  Then I should see the text "1 to 50 of 52"
  When I select "5" from "Show items per page"
    And I click "Page 2"
    And I wait for ajax to finish
  Then I should see the link "Impacts from the Hurricane"
    And I should see the text "6 to 10 of 52 items"
    And I should not see the link "New Director of Enforcements Joins"

@api @javascript
Scenario: Search Announcements by Title
  Given I am logged in as a user with the "Authenticated user" role
    And "announcement" content:
      | title                                                                         | body    | published_at | status |
      | Free Ice Cream Today                                                          | Test 1  | -1 year      | 1      |
      | Sign Up For Benefits By Friday                                                | Test 2  | -5 day       | 1      |
      | Early Dismissal                                                               | Test 3  | -2 day       | 1      |
      | New Director of Enforcement Joins                                             | Test 4  | +1 day       | 1      |
      | Impacts from the Hurricane                                                    | Test 5  | -1 month     | 1      |
      | All Hands Meeting                                                             | Test 7  | -5 month     | 1      |
      | Lorem ipsum dolor sit amet, consectetur adipiscing elit.                      | Test 8  | -2 month     | 1      |
      | Aliquam sagittis turpis in malesuada mollis.                                  | Test 9  | -6 month     | 1      |
      | Pellentesque in ex non velit convallis varius.                                | Test 10 | -7 month     | 1      |
      | Praesent maximus felis in quam pulvinar pharetra.                             | Test 11 | -8 month     | 1      |
      | Cras laoreet metus et lectus mollis sollicitudin.                             | Test 12 | -9 month     | 1      |
      | Phasellus imperdiet libero ac metus dapibus efficitur id vitae justo.         | Test 13 | -10 month    | 1      |
      | Etiam eu nunc porta, elementum sem a, interdum odio.                          | Test 14 | -2 month     | 1      |
      | Donec viverra nibh ac tincidunt pharetra.                                     | Test 15 | -3 month     | 1      |
      | Nulla sit amet tellus at urna sodales vulputate.                              | Test 16 | -4 month     | 1      |
      | Aliquam iaculis metus non ullamcorper pulvinar.                               | Test 17 | -5 month     | 1      |
      | Quisque maximus elit id velit scelerisque lobortis.                           | Test 18 | -6 month     | 1      |
      | Praesent ultrices ipsum sit amet rutrum iaculis.                              | Test 19 | -7 month     | 1      |
      | Pellentesque ut erat vel sem auctor finibus.                                  | Test 20 | -8 month     | 1      |
      | Aliquam dictum tellus vel ornare dignissim.                                   | Test 21 | -11 month    | 1      |
      | Ut eget nunc ac nunc mollis aliquet quis eget mi.                             | Test 22 | -22 month    | 1      |
      | Fusce dapibus tortor eget ipsum ultricies lacinia.                            | Test 23 | -1 month     | 1      |
      | Vestibulum nec dui facilisis, condimentum turpis ut, congue sem.              | Test 24 | -1 month     | 1      |
      | In pharetra justo ac turpis bibendum, quis suscipit elit ullamcorper.         | Test 25 | -1 month     | 1      |
      | Curabitur molestie metus ut mauris venenatis, quis tincidunt lectus volutpat. | Test 26 | -2 month     | 1      |
      | Curabitur maximus tellus ac feugiat gravida.                                  | Test 27 | -2 month     | 1      |
      | Integer venenatis leo quis ante blandit, sit amet porttitor nunc dapibus.     | Test 28 | -2 month     | 1      |
      | Suspendisse id justo ornare, euismod odio eget, mattis quam.                  | Test 29 | -3 month     | 1      |
      | Vivamus finibus purus id maximus elementum.                                   | Test 30 | -3 month     | 1      |
      | Praesent ornare erat id metus gravida, sed efficitur eros commodo.            | Test 31 | -3 month     | 1      |
      | Nullam sit amet lorem vel arcu condimentum posuere in ut dui.                 | Test 32 | -4 month     | 1      |
      | Nulla efficitur leo vitae velit aliquet, nec consectetur ex tempor.           | Test 33 | -4 month     | 1      |
      | Etiam aliquet est vel tempor efficitur.                                       | Test 34 | -4 month     | 1      |
      | Fusce tincidunt ligula in leo pharetra, id mollis felis egestas.              | Test 35 | -4 month     | 1      |
      | Pellentesque porttitor dui ut vehicula consectetur.                           | Test 36 | -15 month    | 1      |
      | Suspendisse luctus nunc at nisl dictum, vel dignissim diam vehicula.          | Test 37 | -15 month    | 1      |
      | Aenean mollis turpis a risus facilisis, at feugiat dolor vehicula.            | Test 38 | -51 month    | 1      |
      | Sed et ipsum bibendum, malesuada neque at, fermentum nibh.                    | Test 39 | -15 month    | 1      |
      | Vivamus dapibus dui nec neque gravida, a vulputate libero vulputate.          | Test 40 | -22 month    | 1      |
      | Suspendisse egestas ex a quam dapibus, sed venenatis purus consequat.         | Test 41 | -23 month    | 1      |
      | Suspendisse eget massa sit amet magna vulputate semper.                       | Test 42 | -24 month    | 1      |
      | In non urna non odio molestie facilisis.                                      | Test 43 | -17 month    | 1      |
      | Mauris aliquet elit auctor ante tincidunt cursus.                             | Test 44 | -18 month    | 1      |
      | Aliquam fringilla mi id nibh vestibulum cursus.                               | Test 45 | -19 month    | 1      |
      | Vivamus sit amet purus vel urna hendrerit gravida.                            | Test 46 | -20 month    | 1      |
      | Nulla ac elit ac augue bibendum consequat pellentesque id est.                | Test 47 | -1 month     | 1      |
      | Nulla malesuada mi vel suscipit auctor.                                       | Test 48 | -2 month     | 1      |
      | Morbi vel libero eget nunc mollis hendrerit.                                  | Test 49 | -3 month     | 1      |
      | Vestibulum at odio viverra, tempus odio nec, dapibus lacus.                   | Test 50 | -4 month     | 1      |
  When I visit "/announcements"
    And I fill in "Search" with "Free Ice Cream Today" in the "filters" region
    And I press "Search" in the "filters" region
  Then the search results should show the link "Free Ice Cream Today"
  When I fill in "Search" with "ABCD1234" in the "filters" region
    And I press "Search" in the "filters" region
  Then I should see the text "No announcements."

@api
Scenario: Promote Announcement to the Homepage
  Given I am logged in as a user with the "Authenticated user" role
    And "announcement" content:
      | title                          | field_short_title  | body   | published_at | promote | status |
      | Free Ice Cream Today           | Free today         | Test 1 | now          | 1       | 1      |
      | Sign Up For Benefits By Friday | Benefits by friday | Test 2 | -5 day       | 0       | 1      |
  When I am on the homepage
  Then I should not see the link "Free Ice Cream Today"
    And I should not see the link "Sign Up For Benefits By Friday"
    And I should see the link "Free today"
    And I should not see the link "Benefits by friday"

@api @javascript
Scenario Outline: Change Order of Announcements on Homepage
  Given "announcement" content:
    | title                             | field_short_title | body   | published_at | promote | status |
    | Free Ice Cream Today              | short title 1     | Test 1 | now          | 1       | 1      |
    | Another Announcement              | short title 2     | Test 2 | -5 day       | 1       | 1      |
    | Early Dismissal                   | short title 3     | Test 3 | -2 day       | 1       | 1      |
    | New Director of Enforcement Joins | short title 4     | Test 4 | +1 day       | 1       | 1      |
    | Impacts from the Hurricane        | short title 5     | Test 5 | -1 month     | 1       | 1      |
    | All Hands Meeting                 | short title 6     | Test 6 | -5 month     | 1       | 1      |
  When I am logged in as a user with the "<role>" role
    And I visit "/admin/content/announcements"
    And I drag announcement "<title1>" onto "<title2>"
    And I press "Save order"
    And I am on the homepage
  Then "<title3>" should precede "<title4>" for the query "//div[contains(@class, 'announcements')]//h3[@class='media-heading']/a"

  Examples:
    | role             | title1                            | title2               | title3        | title4        |
    | administrator    | Early Dismissal                   | Free Ice Cream Today | short title 3 | short title 1 |
    | sitebuilder      | New Director of Enforcement Joins | Another Announcement | short title 4 | short title 2 |
    | content_approver | All Hands Meeting                 | Early Dismissal      | short title 6 | short title 3 |
    | content_creator  | Impacts from the Hurricane        | Another Announcement | short title 5 | short title 2 |

@api
Scenario: All promoted announcements should appear on the homepage
  Given I am logged in as a user with the "Authenticated user" role
    And "announcement" content:
      | title                             | field_short_title | body   | published_at | promote | status |
      | Free Ice Cream Today              | short title 1     | Test 1 | now          | 1       | 1      |
      | Sign Up For Benefits By Friday    | short title 2     | Test 2 | -5 day       | 0       | 1      |
      | Early Dismissal                   | short title 3     | Test 3 | -2 day       | 1       | 1      |
      | New Director of Enforcement Joins | short title 4     | Test 4 | +1 day       | 1       | 1      |
      | Impacts from the Hurricane        | short title 5     | Test 5 | -1 month     | 1       | 1      |
      | All Hands Meeting                 | short title 6     | Test 6 | -5 month     | 1       | 1      |
  When I am on the homepage
  Then I should not see the link "Free Ice Cream Today"
    And I should not see the link "short title 2"
    But I should see the link "short title 3"
    And I should see the link "short title 4"
    And I should see the link "short title 5"
    And I should see the link "short title 6"

@api @javascript
Scenario: Homepage Announcement Display with Internal Link and Image
  Given I am logged in as a user with the "content_approver" role
    And "sec_article" content:
      | title        | body                   | status |
      | Test Article | This is a test article | 1      |
    And I visit "/node/add/image"
    And I fill in "Title" with "BEHAT Image Test"
    And I attach the file "behat-bird.gif" to "Image Upload"
    And I wait for ajax to finish
    And I fill in "Alternative text" with "bird image"
    And I press "Save"
    # Creating this way does not work, added a workaround. Notice: tempnam(): file created in the system's temporary directory in C:\Users\carlo.q.buenaventura\Sites\devdesktop\insidergov-dev\docroot\core\lib\Drupal\Core\File\FileSystem.php line 269.
    #  And "image" content:
    #    | title                      | field_alt_text             | field_image_upload |
    #    | BEHAT Image Test           | This is a picure of a bird | image;bird.gif     |
    And I visit "/node/add/announcement"
    And I fill in the following:
      | Title              | BEHAT Test Announcement |
      | Home Page Title    | BEHAT Homepage Title    |
      | field_link_display | contentURL              |
    And I select the first autocomplete option for "Test Article" on the "Content/Link URL" field
    And I type "Testing source" in the "Source" WYSIWYG editor
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select the first autocomplete option for "BEHAT Image Test" on the "Image Reference" field
    And I select "techno" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I click secondary option "Promotion options"
    And I fill in "edit-promote-value" with "1"
    And I publish it
  When I am on the homepage
  Then I should see the link "BEHAT Homepage Title"
    And I should see the "img" element with the "alt" attribute set to "bird image" in the "announcements" region
  Then I click "BEHAT Homepage Title"
    And I should see the heading "Test Article"

@api @javascript
Scenario: Homepage Announcement Display with External Link
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/announcement"
    And I fill in the following:
      | Title              | BEHAT Test Announcement |
      | Home Page Title    | New Tab                 |
      | field_link_display | contentURL              |
      | Content/Link URL   | http://www.google.com   |
    And I type "Testing source" in the "Source" WYSIWYG editor
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "techno" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I click secondary option "Promotion options"
    And I fill in "edit-promote-value" with "1"
    And I publish it
  When I am on the homepage
  Then I should see the link "New Tab"
    And the hyperlink "New Tab" should match the Drupal url "http://www.google.com"
    And I click "New Tab"
    And the link should open in a new tab
    And I should see the "Google Search" button
    And I close the current window

@api @javascript
Scenario: Homepage Announcement Display with Self Reference Link
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/announcement"
    And I fill in the following:
      | Title           | BEHAT Test Announcement     |
      | Home Page Title | Self Reference Announcement |
    And I type "This is the body." in the "Body" WYSIWYG editor
    And I type "This is the teaser." in the "Teaser" WYSIWYG editor
    And I type "Testing source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "techno" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I click secondary option "Promotion options"
    And I fill in "edit-promote-value" with "1"
    And I publish it
  When I am on the homepage
  Then I should see the link "Self Reference Announcement"
    And I should see the text "This is the teaser."
    And I click "Self Reference Announcement"
    And I should see the text "This is the body."

@api @javascript
Scenario: Announcement type filter validation
  Given I am logged in as a user with the "Authenticated user" role
    And "announcement" content:
      | title                             | body   | changed  | field_announcement_type | status |
      | Free Ice Cream Today              | Test 1 | now      | Obituary                | 1      |
      | Sign Up For Benefits By Friday    | Test 2 | -5 day   | Memorandum              | 1      |
      | Early Dismissal                   | Test 3 | -2 day   |                         | 1      |
      | New Director of Enforcement Joins | Test 4 | +1 day   | Obituary                | 1      |
      | Impacts from the Hurricane        | Test 5 | -1 month | Memorandum              | 1      |
      | Vigil Held for 9/11               | Test 6 | -1 month |                         | 0      |
      | Pizza Party Planned               | Test 7 | +1 month | Memorandum              | 0      |
  When I visit "/announcements"
    And I select "Memorandum" from "field_announcement_type_target_id"
    And I press "Search" in the "filters" region
  Then I should see the link "Sign Up For Benefits By Friday"
    And I should see the link "Impacts from the Hurricane"
    And I should not see the link "Pizza Party Planned"
    And I should not see the link "New Director of Enforcement Joins"
    And I should not see the link "Early Dismissal"
    And I should not see the link "Free Ice Cream Today"
    And I should not see the link "Vigil Held for 9/11"
  When I select "Obituary" from "field_announcement_type_target_id"
    And I press "Search" in the "filters" region
  Then I should see the link "New Director of Enforcement Joins"
    And I should see the link "Free Ice Cream Today"
    And I should not see the link "Sign Up For Benefits By Friday"
    And I should not see the link "Impacts from the Hurricane"
    And I should not see the link "Pizza Party Planned"
    And I should not see the link "Early Dismissal"
    And I should not see the link "Vigil Held for 9/11"
  When I select "- Any -" from "field_announcement_type_target_id"
    And I press "Search" in the "filters" region
  Then I should see the link "Sign Up For Benefits By Friday"
    And I should see the link "Free Ice Cream Today"
    And I should not see the link "Pizza Party Planned"

#Need some test cases that cover the different date possibilities created, changed, published_at, publish_on.

@api
Scenario Outline: Date Format Validation for Announcements
  Given I am logged in as a user with the "Authenticated user" role
    And I am viewing an "announcement" content:
      | body                         | This is the body    |
      | title                        | My test article     |
      | published_at                 | <Last_Updated_Date> |
      | field_override_modified_date | <Last_Updated_Date> |
      | field_announcement_type      | <type>              |
      | status                       | 1                   |

  Examples:
    | type       | Last_Updated_Date   | Date_Text      |
    | Memorandum | 2029-01-01 12:00:00 | Jan. 1, 2029   |
    | Detail     | 2029-02-11 12:00:00 | Feb. 11, 2029  |
    | Obituary   | 2029-03-11 12:00:00 | March 11, 2029 |
    | Memorandum | 2029-04-11 12:00:00 | April 11, 2029 |
    | Detail     | 2029-05-11 12:00:00 | May 11, 2029   |
    | Training   | 2029-06-11 12:00:00 | June 11, 2029  |
    | Obituary   | 2029-07-11 12:00:00 | July 11, 2029  |
    |            | 2029-08-11 12:00:00 | Aug. 11, 2029  |
    |            | 2029-09-11 12:00:00 | Sept. 11, 2029 |
    |            | 2029-10-11 12:00:00 | Oct. 11, 2029  |
    |            | 2029-11-11 12:00:00 | Nov. 11, 2029  |
    | Training   | 2028-12-11 12:00:00 | Dec. 11, 2028  |
  Then I should see the text "Modified: <Date_Text>"
  When I visit "/announcements"
  Then I should see the date "<Date_Text>" in the "My test article" row
    And I should not see the text "<Last_Updated_Date>"

@api @javascript
Scenario: Memorandum Announcement With Embedded Event
  Given I am logged in as a user with the "content_approver" role
    And I create "paragraph" of type "paragraph_session":
      | KEY | field_location | field_start_date    | field_end_date      | type              |
      | 100 | Main Lobby     | 2019-10-17T12:00:00 | 2019-10-17T15:00:00 | paragraph_session |
    And I create "node" of type "event":
      | title                | field_short_title | body                            | field_session | field_event_type | status | field_timezone_select |
      | Free Starbucks Today | Home Page Title 0 | Starbucks coffee will be served | 100           | General          | 1      | Eastern               |
  When I visit "/node/add/announcement"
    And I fill in the following:
      | Title           | Behat Test For Event Embedded Memorandum Announcement |
      | Home Page Title | Behat Test short title                                |
    And I scroll "#edit-body-wrapper" into view
    And I press "Node" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Free Starbucks Today" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Memorandum" from "Announcement Type"
    And I fill in the following:
      | To   | SEC.gov Contractors |
      | From | Your Boss           |
    And I select "behat" from "Topic"
    And I select "SEC.gov" from "Top Level Group"
    And I publish it
  Then I see the heading "Behat Test For Event Embedded Memorandum Announcement"
    And I should see the heading "Memorandum"
    And I should see the text "Free Starbucks Today"
    And I should see the text "Main Lobby"
    And I should see the text "Starbucks coffee will be served"
    And I should see the text "Oct. 17, 2019"
    And I should see the text "12:00 pm – 3:00 pm ET"

@api @javascript
Scenario: Obituary Announcement With Embedded Event
  Given I am logged in as a user with the "content_approver" role
    And I create "paragraph" of type "paragraph_session":
      | KEY | field_location | field_start_date    | field_end_date      | type              |
      | 101 | Room SP1 6000  | 2019-10-23T21:00:00 | 2019-10-25T23:00:00 | paragraph_session |
    And I create "node" of type "event":
      | title                               | field_short_title | body                                             | field_session | field_event_type | status | field_timezone_select |
      | Vigil Will Be Held Starting Tonight | Home Page Title 0 | Vigil Will Be Held for John Doe Starting Tonight | 101           | General          | 1      | Eastern               |
  When I visit "/node/add/announcement"
    And I fill in the following:
      | Title           | Behat Test For Event Embedded Obituary Announcement |
      | Home Page Title | Behat Test short title                              |
    And I scroll "#edit-body-wrapper" into view
    And I press "Node" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Vigil Will Be Held Starting Tonight" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Obituary" from "Announcement Type"
    And I fill in the following:
      | To   | SEC.gov Contractors |
      | From | The Boss            |
    And I select "behat" from "Topic"
    And I select "SEC.gov" from "Top Level Group"
    And I publish it
  Then I see the heading "Behat Test For Event Embedded Obituary Announcement"
    And I should see the heading "In Memoriam"
    And I should see the text "Vigil Will Be Held Starting Tonight"
    And I should see the text "Room SP1 6000"
    And I should see the text "Vigil Will Be Held for John Doe Starting Tonight"
    And I should see the text "Oct. 23, 2019 – Oct. 25, 2019"
    And I should see the text "9:00 pm – 11:00 pm ET"

@api @javascript
Scenario: Announcement With Embedded Link Event
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/event"
    And I fill in the following:
      | Title           | Movie Night at the SEC     |
      | Home Page Title | Behat Test Home Page Title |
    And I fill in "edit-field-session-0-subform-field-start-date-0-value" field with "2019-10-31 10:00:00 AM"
    And I fill in "edit-field-session-0-subform-field-end-date-0-value" field with "2019-11-01 12:00:00 PM"
    And I type "Room SP1 4000" in the "1" session "Location" WYSIWYG editor
    And I type "Test Behat Source" in the "Source" WYSIWYG editor
    And I type "Halloween movies will be shown and popcorn will be served" in the "Body" WYSIWYG editor
    And I scroll "#edit-body-wrapper" into view
    And I press "Insert Horizontal Line" in the "Body" WYSIWYG Toolbar
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I fill in "Display Text" with "The Nightmare Before Christmas"
    And I select "Eastern" from "Timezone"
    And I select "URL" from "Link Type"
    And I select "https://" from "Protocol"
    And I fill in "URL*" with "en.wikipedia.org/wiki/The_Nightmare_Before_Christmas"
    And I press the "OK" button
    And I select "General" from "Event Type"
    And I click "Exchange Details"
    And I select "behat" from "Topic"
    And I select "SEC.gov" from "Top Level Group"
    And I publish it
  When I visit "/node/add/announcement"
    And I fill in the following:
      | Title           | Behat Test For Event with Link Embedded Announcement |
      | Home Page Title | Behat Test Short title                               |
    And I scroll "#edit-body-wrapper" into view
    And I press "Node" in the "Body" WYSIWYG Toolbar
    And I select the first autocomplete option for "Movie Night at the SEC" on the "Title" field on a modal
    And I click "Next" on the modal "Select content item to embed"
    And I click "Embed" on the modal "Embed content item"
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Memorandum" from "Announcement Type"
    And I fill in the following:
      | To   | SEC.gov Contractors |
      | From | The Boss            |
    And I select "behat" from "Topic"
    And I select "SEC.gov" from "Top Level Group"
    And I publish it
  Then I see the heading "Behat Test For Event with Link Embedded Announcement"
    And I should see the text "Memorandum"
    And I should see the link "Movie Night at the SEC"
    And I should see the text "Room SP1 4000"
    And I should see the text "Halloween movies will be shown and popcorn will be served"
    And I should see the text "Oct. 31, 2019 – Nov. 1, 2019"
    And I should see the text "10:00 am – 12:00 pm ET"
    And I scroll ".field--name-body" into view
    And I should see the link "The Nightmare Before Christmas"
    And I click "The Nightmare Before Christmas"
    And the link should open in a new tab
    And I should see the text "Tim Burton's The Nightmare Before Christmas"
    And I close the current window

@api @javascript @TODO
Scenario: Announcement With LinkIt
  Given I am logged in as a user with the "content_approver" role
    And I create "paragraph" of type "paragraph_session":
      | KEY | field_location | field_start_date    | field_end_date      | type              |
      | 102 | Main Lobby     | 2019-10-17T12:00:00 | 2019-10-17T15:00:00 | paragraph_session |
    And I create "node" of type "event":
      | title             | field_short_title | body                                 | field_session | field_event_type | status | nid      | field_timezone_select |
      | Free Bagels Today | Home Page Title 0 | Bagels and croissants will be served | 102           | General          | 1      | 77777777 | Eastern               |
  When I visit "/node/add/announcement"
    And I fill in the following:
      | Title           | Behat Test For Event LinkIt Embedded Announcement |
      | Home Page Title | Behat Test short title                            |
    And I scroll "#edit-body-wrapper" into view
    And I press "LinkIt (Ctrl+K)" in the "Body" WYSIWYG Toolbar
    And I fill in "URL" with "/node/77777777"
    #Due to the autocomplete field for LinkIt is more customized, the following step to "select the first autocomplete option" will fail as it won't find the first selection.  Tagging as #TODO as will need developer's help to create a new function for it to work with LinkIt autocomplete Add Link modal dialog.
    #And I select the first autocomplete option for "Free Bagels Today" on the "URL" field on a modal
    #For now, will use a workaround by passing the node id (nid)
    And I click "Save" on the modal "Add Link"
    And I wait for ajax to finish
    And I scroll "#edit-body-wrapper" into view
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I fill in "Display Text" with "Free Bagels Today"
    And I press the "OK" button
    And I wait for ajax to finish
    And I type "Behat Test Source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Memorandum" from "Announcement Type"
    And I fill in the following:
      | To   | SEC.gov Contractors |
      | From | Your Boss           |
    And I select "behat" from "Topic"
    And I select "SEC.gov" from "Top Level Group"
    And I publish it
  Then I see the heading "Behat Test For Event LinkIt Embedded Announcement"
    And I should see the text "Memorandum"
    And I should see the link "Free Bagels Today"
    And I click "Free Bagels Today"
    And I should see the heading "Free Bagels Today"
    And I should see the text "Bagels and croissants will be served"

@api @javascript
Scenario: Search External Link Announcement from Announcements List Page
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/announcement"
    And I fill in the following:
      | Title              | BEHAT Test Announcement |
      | Home Page Title    | External Platform Link  |
      | field_link_display | contentURL              |
      | Content/Link URL   | http://www.google.com   |
    And I type "Testing source" in the "Source" WYSIWYG editor
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "techno" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I publish it
    And I run drush "cr"
    And I am logged in as a user with the "Authenticated user" role
  When I visit "/news/announcements"
  Then I should see the link "BEHAT Test Announcement"
    And the hyperlink "BEHAT Test Announcement" should match the Drupal url "http://www.google.com"
    And I click "BEHAT Test Announcement"
    And the link should open in a new tab
    And I should see the "Google Search" button
    And I close the current window

@api @javascript
Scenario: Search External Link Announcement from Global Search
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/announcement"
    And I fill in the following:
      | Title              | BEHAT Test Announcement |
      | Home Page Title    | External Platform Link  |
      | field_link_display | contentURL              |
      | Content/Link URL   | http://www.google.com   |
    And I type "Testing source" in the "Source" WYSIWYG editor
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "techno" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I publish it
    And I am logged in as a user with the "Authenticated user" role
    And I am on "/search"
    And I fill in "edit-search-api-fulltext" with "BEHAT Test Announcement"
    And I press the "edit-submit-the-exchange-search" button
  Then I should see the link "BEHAT Test Announcement"
    And the hyperlink "BEHAT Test Announcement" should match the Drupal url "http://www.google.com"
  When I wait 2 seconds
    And I click "BEHAT Test Announcement"
  Then the link should open in a new tab
    And I should see the "Google Search" button
    And I close the current window

@api @javascript
Scenario: Search Announcement with Internal Link
  Given I am logged in as a user with the "content_approver" role
    And "sec_article" content:
      | title        | body                   | status |
      | Test Article | This is a test article | 1      |
    And I visit "/node/add/announcement"
    And I fill in the following:
      | Title              | BEHAT Test Announcement |
      | Home Page Title    | BEHAT Homepage Title    |
      | field_link_display | contentURL              |
    And I select the first autocomplete option for "Test Article" on the "Content/Link URL" field
    And I type "Testing source" in the "Source" WYSIWYG editor
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "techno" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I publish it
    And I am logged in as a user with the "Authenticated user" role
  When I visit "/news/announcements"
  Then I should see the link "BEHAT Test Announcement"
    And I click "BEHAT Test Announcement"
    And I should see the heading "Test Article"
  When I am on "/search"
    And I fill in "edit-search-api-fulltext" with "BEHAT Test Announcement"
    And I press the "edit-submit-the-exchange-search" button
  Then I should see the link "BEHAT Test Announcement"
    And I click "BEHAT Test Announcement"
    And I should see the heading "Test Article"

@api @javascript
Scenario: Review tab when the content has been edited for announcement
  Given "announcement" content:
    | title                | field_short_title             | moderation_state | status | body             | field_source             | field_topic   | field_top_level_group |
    | This is the BEHAT v1 | This is home page title field | published        | 1      | This is the body | This is the source field | About the SEC | My SEC                |
    And I am logged in as a user with the "Content Approver" role
  When I am on "/admin/content"
    And I select "Announcement" from "type"
    And I wait for ajax to finish
    And I press "Filter"
    And I wait for ajax to finish
    And I click "Edit" in the "This is the BEHAT v1" row
    And I fill in "This is the BEHAT v2" for "Title"
    And I publish it
    And I am on "/admin/content"
    And I select "Announcement" from "type"
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
    And I select "Announcement" from "type"
    And I wait for ajax to finish
    And I press "Filter"
    And I wait for ajax to finish
    And I click "Edit" in the "This is the BEHAT v1" row
    And I fill in "This is the BEHAT v3" for "Title"
    And I publish it
    And I am on "/admin/content"
    And I select "Announcement" from "type"
    And I wait for ajax to finish
    And I press "Filter"
    And I wait for ajax to finish
    And I click "Edit" in the "This is the BEHAT v3" row
    And I click "Revisions"
    And I click on the element with css selector ".node-revision-table > tbody > tr:nth-child(1) > td:nth-child(1) > a:nth-child(1)"
    And I should see the text "This is the BEHAT v3"
    And I am on "/admin/content"
    And I select "Announcement" from "type"
    And I wait for ajax to finish
    And I press "Filter"
    And I wait for ajax to finish
    And I click "Edit" in the "This is the BEHAT v3" row
    And I click "Revisions"
    And I click on the element with css selector ".node-revision-table > tbody > tr:nth-child(3) > td:nth-child(1) > a:nth-child(1)"
    And I should see the text "This is the BEHAT v2"

@api @javascript
Scenario: Verify Announcement Link Is Not Broken When The Maximum Characters Are Provided
  Given I am logged in as a user with the "content_approver" role
    And "sec_article" content:
      | title                                                                                                                                                                                                                                                           | body                   | status |
      | Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eu nulla ac sem condimentum luctus non posuere ante. Donec est erat, sagittis in ipsum ac, malesuada tincidunt leo. In eget augue lectus. Aliquam tempor ac lacus a laoreet. Nulla pulvinar t | This is a test article | 1      |
    And I visit "/node/add/announcement"
    And I fill in the following:
      | Title              | BEHAT Test Announcement |
      | Home Page Title    | BEHAT Homepage Title    |
      | field_link_display | contentURL              |
    And I select the first autocomplete option for "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eu nulla ac sem condimentum luctus non posuere ante. Donec est erat, sagittis in ipsum ac, malesuada tincidunt leo. In eget augue lectus. Aliquam tempor ac lacus a laoreet. Nulla pulvinar t" on the "Content/Link URL" field
    And I type "Testing source" in the "Source" WYSIWYG editor
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "techno" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I publish it
    And I am logged in as a user with the "Authenticated user" role
  When I visit "/news/announcements"
  Then I should see the link "BEHAT Test Announcement"
  When I click "BEHAT Test Announcement"
  Then I should be on "/lorem-ipsum-dolor-sit-amet-consectetur-adipiscing-elit-maecenas-eu-nulla-ac-sem-condimentum-luctus"
    And I should see the heading "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eu nulla ac sem condimentum luctus non posuere ante. Donec est erat, sagittis in ipsum ac, malesuada tincidunt leo. In eget augue lectus. Aliquam tempor ac lacus a laoreet. Nulla pulvinar t"
    And I should see the text "This is a test article"

@api @javascript
Scenario: Announcement Published Date Doesn't Update When Republish
  Given "announcement" content:
    | title                      | field_short_title | body   | published_at | status | field_announcement_type | changed | field_source             | field_topic   | field_top_level_group | moderation_state | field_to | field_from | nid    |
    | Impacts from the Hurricane | hurricane season  | Test 5 | -1 month     | 1      | Memorandum              | -5 day  | This is the source field | hr            | sports                | published        | Jeff     | George     | 862020 |
  When I am logged in as a user with the "Content Approver" role
    And I visit "/announcements"
    # Checking for usage of published date
  Then I should see the date "-1 month" in the "Impacts from the Hurricane" row
  When I visit "/node/862020/edit"
    And I fill in "Title" with "The Aftermath Of Hurricane Henry"
    And I publish it
  Then I should see the text "Announcement The Aftermath Of Hurricane Henry has been updated."
  When I visit "/announcements"
  # Checking for no date updating when republish
  Then I should see the date "-1 month" in the "The Aftermath Of Hurricane Henry" row
    And I should not see the text "Impacts from the Hurricane"

  @api
  Scenario: Verify Required Fields
    Given I am logged in as a user with the "content_creator" role
    When I visit "/node/add/announcement"
      And I press "Save and Create New Draft"
    Then I should see the text "Title field is required."
      And I should see the text "Home Page Title field is required."
      And I should see the text "Source field is required."
      And I should see the text "Top Level Group field is required."
      And I should see the text "Topic field is required."
      And I should see the text "Please enter a body."
      And I should see the text "*Fields marked with an asterisk(*) are required."
      And I should not see the text "Content/Link URL is required."
    When I select the radio button "Content or URL"
      And I press "Save and Create New Draft"
    Then I should see the text "Title field is required."
      And I should see the text "Home Page Title field is required."
      And I should see the text "Content/Link URL is required."
      And I should see the text "Source field is required."
      And I should see the text "Top Level Group field is required."
      And I should see the text "Topic field is required."
      And I should not see the text "Please enter a body."

@api @javascript
Scenario: Announcement With External Links Should Open In New Tab
  Given I am logged in as a user with the "content_approver" role
    And link content:
      | title           | field_description_abstract | field_url                          | status | moderation_state | nid   |
      | Behat Page Link | Site Link Description      | Click Here - http://www.google.com | 1      | published        | 10101 |
  When I visit "/node/add/announcement"
    And I fill in the following:
      | Title              | BEHAT Test Announcement |
      | Home Page Title    | BEHAT Homepage Title    |
      | field_link_display | contentURL              |
    And I select the first autocomplete option for "Behat Page Link" on the "Content/Link URL" field
    And I type "Testing source" in the "Source" WYSIWYG editor
    And I type "Testing body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "techno" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I publish it
  When I visit "/news/announcements"
    And I click "BEHAT Test Announcement"
    And the link should open in a new tab
  Then I should see the "Google Search" button

@api
Scenario: 3-Year Limit For Announcement List Page
  Given I am logged in as a user with the "Authenticated user" role
    And I am viewing an "announcement" content:
      | body                         | This is the body     |
      | title                        | My test announcement |
      | published_at                 | 2018-01-01 12:00:00  |
      | field_override_modified_date | 2018-01-01 12:00:00  |
      | status                       | 1                    |
  Then I should see the text "Modified: Jan. 1, 2018"
  When I visit "/announcements"
  Then I should not see the text "My test announcement"

@api @javascript
Scenario: Change Order of Announcements on Homepage Using Row Weights
  Given "announcement" content:
    | title                             | field_short_title | body   | published_at | promote | status |
    | Free Ice Cream Today              | short title 1     | Test 1 | now          | 1       | 1      |
    | Another Announcement              | short title 2     | Test 2 | -2 day       | 1       | 1      |
    | Early Dismissal                   | short title 3     | Test 3 | -5 day       | 1       | 1      |
    | New Director of Enforcement Joins | short title 4     | Test 4 | -6 day       | 1       | 1      |
    | Impacts from the Hurricane        | short title 5     | Test 5 | -7 day       | 1       | 1      |
    And I am logged in as a user with the "Authenticated user" role
  When I am on the homepage
  Then "short title 1" should precede "short title 2" for the query "//div[contains(@class, 'announcements')]//h3[@class='media-heading']/a"
    And "short title 2" should precede "short title 3" for the query "//div[contains(@class, 'announcements')]//h3[@class='media-heading']/a"
    And "short title 3" should precede "short title 4" for the query "//div[contains(@class, 'announcements')]//h3[@class='media-heading']/a"
    And "short title 4" should precede "short title 5" for the query "//div[contains(@class, 'announcements')]//h3[@class='media-heading']/a"
  When I am logged in as a user with the "content_approver" role
    And I visit "/admin/content/announcements"
    And I reload the page
    And I press "Show row weights"
    And I fill in "edit-draggableviews-0-weight" with "5"
    And I fill in "edit-draggableviews-1-weight" with "4"
    And I fill in "edit-draggableviews-2-weight" with "3"
    And I fill in "edit-draggableviews-3-weight" with "2"
    And I fill in "edit-draggableviews-4-weight" with "1"
    And I press "Save order"
    And I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I run drush "cr"
    And I reload the page
  Then "short title 5" should precede "short title 4" for the query "//div[contains(@class, 'announcements')]//h3[@class='media-heading']/a"
    And "short title 4" should precede "short title 3" for the query "//div[contains(@class, 'announcements')]//h3[@class='media-heading']/a"
    And "short title 3" should precede "short title 2" for the query "//div[contains(@class, 'announcements')]//h3[@class='media-heading']/a"
    And "short title 2" should precede "short title 1" for the query "//div[contains(@class, 'announcements')]//h3[@class='media-heading']/a"
