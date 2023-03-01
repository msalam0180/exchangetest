Feature: Return To Top
  As a user, when scrolling a page after a certain length I should see the Return to Top link that would scroll me back up the top most point of the page.

  Background:
    Given "topic" terms:
        | name       |
        | technology |
        | hr         |
        | data feeds |
      And "top_level_group" terms:
        | name     | field_abbreviation |
        | toplevel | toplevel           |
        | sports   |                    |
        | news     | news               |

@api @javascript
Scenario: User Can Click On Return To Top From Articles Page
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | BEHAT Test Article |
    And I type "This is a large test body This is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test bodyThis is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test bodyThis is a large test body This is a large test bodyThis is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test body This is a large test body This is a large test body  This is a large test bodyThis is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body This is a large test bodyThis is a large test body This is a large test body  This is a large test bodyThis is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body This is a large test body" in the "Body" WYSIWYG editor
    And I type "This is a large source    This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source   This is a large source" in the "Source" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "hr" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  Then I should not visibly see the link "Return to Top"
  When I scroll to the bottom
  Then I should see the link "Return to Top"
  When I click "Return to Top"
    And I wait 4 seconds
  Then I should not visibly see the link "Return to Top"

@api @javascript
Scenario: User Can Click On Return To Top From Events Page
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/event"
    And I fill in the following:
      | Title           | BEHAT Test Event |
      | Home Page Title | Short Title      |
    And I select "Eastern" from "Timezone"
    And I fill in "2020-05-15 10:00:00 AM" in the "1" event start date
    And I fill in "2020-05-15 10:30:00 AM" in the "1" event end date
    And I type "Test Location" in the "1" session "Location" WYSIWYG editor
    And I type "Test Source" in the "Source" WYSIWYG editor
    And I type "This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test BodyThis is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  This is a large Test Body  " in the "Body" WYSIWYG editor
    And I select "General" from "Event Type"
    And I scroll to the top
    And I click "Exchange Details"
    And I select "data feeds" from "Topic"
    And I select "toplevel" from "Top Level Group"
    And I publish it
  Then I should not visibly see the link "Return to Top"
  When I scroll to the bottom
  Then I should see the link "Return to Top"
  When I click "Return to Top"
    And I wait 4 seconds
  Then I should not visibly see the link "Return to Top"

@api @javascript
Scenario: User Can Click On Return To Top From Homepage
  Given I am logged in as a user with the "Authenticated user" role
  When I visit "/"
    And I wait 5 seconds
  Then I should not visibly see the link "Return to Top"
  When I scroll to the bottom
  Then I should see the link "Return to Top"
  When I click "Return to Top"
    And I wait 2 seconds
  Then I should not visibly see the link "Return to Top"

@api @javascript
Scenario: User Can Click On Return To Top From Announcements Page
  Given "announcement" content:
    | title          | body             | field_source | field_topic  | field_top_level_group   | changed             | status |
    | Announcement1  | This is the body | Source       | Technology   | sports                  | 2019-06-29 12:00:00 | 1      |
    | Announcement2  | This is the body | Source       | Technology   | sports                  | 2019-05-29 12:00:00 | 1      |
    | Announcement3  | This is the body | Source       | Technology   | sports                  | 2019-04-25 12:00:00 | 1      |
    | Announcement4  | This is the body | Source       | Technology   | sports                  | 2019-03-03 12:00:00 | 1      |
    | Announcement5  | This is the body | Source       | Technology   | sports                  | 2019-02-28 12:00:00 | 1      |
    | Announcement6  | This is the body | Source       | Technology   | sports                  | 2019-01-01 12:00:00 | 1      |
    | Announcement7  | This is the body | Source       | Technology   | sports                  | 2018-12-30 12:00:00 | 1      |
    | Announcement8  | This is the body | Source       | Technology   | sports                  | 2018-11-29 12:00:00 | 1      |
    | Announcement9  | This is the body | Source       | Technology   | sports                  | 2018-10-19 12:00:00 | 1      |
    | Announcement10 | This is the body | Source       | Technology   | sports                  | 2018-09-20 12:00:00 | 1      |
    | Announcement11 | This is the body | Source       | Technology   | sports                  | 2018-08-12 12:00:00 | 1      |
    | Announcement12 | This is the body | Source       | Technology   | sports                  | 2018-07-10 12:00:00 | 1      |
    | Announcement13 | This is the body | Source       | Technology   | sports                  | 2018-04-11 12:00:00 | 1      |
    | Announcement14 | This is the body | Source       | Technology   | sports                  | 2018-02-19 12:00:00 | 1      |
    | Announcement15 | This is the body | Source       | Technology   | sports                  | 2018-01-29 12:00:00 | 1      |
    | Announcement16 | This is the body | Source       | Technology   | sports                  | 2017-09-05 12:00:00 | 1      |
    | Announcement17 | This is the body | Source       | Technology   | sports                  | 2017-07-19 12:00:00 | 1      |
    | Announcement18 | This is the body | Source       | Technology   | sports                  | 2017-06-12 12:00:00 | 1      |
    | Announcement19 | This is the body | Source       | Technology   | sports                  | 2017-05-15 12:00:00 | 1      |
    | Announcement20 | This is the body | Source       | Technology   | sports                  | 2017-04-30 12:00:00 | 1      |
    | Announcement21 | This is the body | Source       | Technology   | sports                  | 2017-02-16 12:00:00 | 1      |
    | Announcement22 | This is the body | Source       | Technology   | sports                  | 2017-01-02 12:00:00 | 1      |
    | Announcement23 | This is the body | Source       | Technology   | sports                  | 2016-10-29 12:00:00 | 1      |
    | Announcement24 | This is the body | Source       | Technology   | sports                  | 2016-09-19 12:00:00 | 1      |
    | Announcement25 | This is the body | Source       | Technology   | sports                  | 2016-07-18 12:00:00 | 1      |
    And I am logged in as a user with the "Authenticated user" role
  When I visit "/announcements"
  Then I should not visibly see the link "Return to Top"
  When I scroll to the bottom
  Then I should see the link "Return to Top"
  When I click "Return to Top"
    And I wait 4 seconds
  Then I should not visibly see the link "Return to Top"

@api @javascript
Scenario: User Can Click On Return To Top From Calendar Page
  Given I create "paragraph" of type "paragraph_session":
    | KEY | field_location | field_start_date | field_end_date  | type              |
    | 100 | Alaska         | +1 hour          | +5 day          | paragraph_session |
    | 101 | Texas          | +2 hour          | +1 day          | paragraph_session |
    | 102 | Michigan       | +1 day           | +1 day +1 hour  | paragraph_session |
    | 103 | Colorado       | +1 week          | +1 week +1 hour | paragraph_session |
    | 104 | Virginia       | +1 week          | +1 week +1 hour | paragraph_session |
    | 105 | DC             | +1 hour          | +1 week +1 hour | paragraph_session |
    | 106 | California     | +1 hour          | +1.5 hour       | paragraph_session |
    | 107 | Hawaii         | +1 week          | +1 week +1 hour | paragraph_session |
    | 108 | Oregon         | +1 day           | +2 day          | paragraph_session |
    | 109 | New York       | +1 hour          | +2 hour         | paragraph_session |
    And I create "node" of type "event":
      | title               | field_short_title  | body                 | status | field_session |
      | BEHAT Timezone Test | Timezone Test      | Timezone test.       | 1      | 100           |
      | BEHAT Event Test 0  | Home Page Title 0  | This is an Event 0.  | 1      | 101           |
      | BEHAT Event Test 1  | Home Page Title 1  | This is an Event 1.  | 1      | 102           |
      | BEHAT Event Test 2  | Home Page Title 2  | This is an Event 2.  | 1      | 103           |
      | BEHAT Event Test 3  | Home Page Title 3  | This is an Event 3.  | 1      | 104           |
      | BEHAT Event Test 4  | Home Page Title 4  | This is an Event 4.  | 1      | 105           |
      | BEHAT Event Test 5  | Home Page Title 5  | This is an Event 5.  | 1      | 106           |
      | BEHAT Event Test 6  | Home Page Title 6  | This is an Event 6.  | 1      | 107           |
      | BEHAT Event Test 7  | Home Page Title 7  | This is an Event 7.  | 1      | 108           |
      | BEHAT Event Test 8  | Home Page Title 8  | This is an Event 8.  | 1      | 109           |
      | BEHAT Event Test 9  | Home Page Title 9  | This is an Event 9.  | 1      | 101           |
      | BEHAT Event Test 10 | Home Page Title 10 | This is an Event 10. | 1      | 102           |
      | BEHAT Event Test 11 | Home Page Title 11 | This is an Event 11. | 1      | 103           |
      | BEHAT Event Test 12 | Home Page Title 12 | This is an Event 12. | 1      | 104           |
      | BEHAT Event Test 13 | Home Page Title 13 | This is an Event 13. | 1      | 105           |
      | BEHAT Event Test 14 | Home Page Title 14 | This is an Event 14. | 1      | 106           |
      | BEHAT Event Test 15 | Home Page Title 15 | This is an Event 15. | 1      | 107           |
      | BEHAT Event Test 16 | Home Page Title 16 | This is an Event 16. | 1      | 108           |
      | BEHAT Event Test 17 | Home Page Title 17 | This is an Event 17. | 1      | 109           |
      | BEHAT Event Test 18 | Home Page Title 18 | This is an Event 18. | 1      | 101           |
      | BEHAT Event Test 19 | Home Page Title 19 | This is an Event 19. | 1      | 102           |
      | BEHAT Event Test 20 | Home Page Title 20 | This is an Event 20. | 1      | 103           |
      | BEHAT Event Test 21 | Home Page Title 21 | This is an Event 21. | 1      | 104           |
      | BEHAT Event Test 22 | Home Page Title 22 | This is an Event 22. | 1      | 105           |
      | BEHAT Event Test 23 | Home Page Title 23 | This is an Event 23. | 1      | 106           |
      | BEHAT Event Test 24 | Home Page Title 24 | This is an Event 24. | 1      | 107           |
      | BEHAT Event Test 25 | Home Page Title 25 | This is an Event 25. | 1      | 108           |
      | BEHAT Event Test 26 | Home Page Title 26 | This is an Event 26. | 1      | 109           |
    And I am logged in as a user with the "Authenticated user" role
  When I visit "/events"
  Then I should not visibly see the link "Return to Top"
  When I scroll to the bottom
  Then I should see the link "Return to Top"
  When I click "Return to Top"
    And I wait 4 seconds
  Then I should not visibly see the link "Return to Top"

@api @javascript
Scenario: User Can Click On Return To Top From Landing Page
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/landing_page"
    And I fill in the following:
      | Title                | BEHAT Landing Page       |
      | Description/Abstract | This is the description. |
    And I click on the element with css selector "#edit-group-l"
    And I type "This is a long text on left 1 box Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc," in the "Left 1 - Box" WYSIWYG editor
    And I click on the element with css selector "#edit-group-center-content"
    And I type "This is a center 2 box Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc," in the "Center 2 - Box" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Audience" from "Landing Page Subtype"
    And I select "news" from "Top Level Group"
    And I publish it
  Then I should not visibly see the link "Return to Top"
  When I scroll to the bottom
  Then I should see the link "Return to Top"
  When I click "Return to Top"
    And I wait 5 seconds
  Then I should not visibly see the link "Return to Top"

@api @javascript
Scenario: Return To Top Does Not Show For Small Content Page
  Given I am logged in as a user with the "content_approver" role
  When I visit "/node/add/landing_page"
    And I fill in the following:
      | Title                | BEHAT Landing Page       |
      | Description/Abstract | This is the description. |
    And I click on the element with css selector "#edit-group-l"
    And I type "This is a long text on left 1 box" in the "Left 1 - Box" WYSIWYG editor
    And I type "This is a long text for left 2 box" in the "Left 2 - Box" WYSIWYG editor
    And I type "This is a long left 3 box This is a long left 3 box " in the "Left 3 - Box" WYSIWYG editor
    And I type "This is a long left 4 box  This is a long left 4 box " in the "Left 4 - Box" WYSIWYG editor
    And I type "This is a left 5 box" in the "Left 5 - Box" WYSIWYG editor
    And I click on the element with css selector "#edit-group-center-content"
    And I type "This is a center 2 box" in the "Center 2 - Box" WYSIWYG editor
    And I click on the element with css selector "#edit-group-ri"
    And I type "This is a right 4 box" in the "Right 4 - Box" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "Audience" from "Landing Page Subtype"
    And I select "news" from "Top Level Group"
    And I publish it
  Then I should not visibly see the link "Return to Top"
