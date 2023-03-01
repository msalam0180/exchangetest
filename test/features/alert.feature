Feature: Create and View Alerts
  As a Content Creator to the Insider
  I want to be able to post alerts
  So that users can be notified of late breaking information

@api
Scenario: View Active Alerts
  Given I am logged in as a user with the "Authenticated user" role
    And "sec_alert" content:
      | title            | body                          | status |
      | Active Alert 1   | This is an active alert.      | 1      |
      | Active Alert 2   | This is also an active alert. | 1      |
      | Inactive Alert 1 | This is an inactive alert.    | 0      |
  When I am on the homepage
  Then I should see the text "Active Alert 1"
    And I should see the text "This is an active alert."
    And I should see the text "Active Alert 2"
    And I should see the text "This is also an active alert."
    And I should not see the text "Inactive Alert 1"
    And I should not see the text "This is an inactive alert."

@api @javascript
Scenario: Create Alert Through the UI
  Given I am logged in as a user with the "administrator" role
  When I visit "/node/add/sec_alert"
    And I fill in "Title" with "BEHAT Test Alert"
    And I type "Testing " in the "Body" WYSIWYG editor
    And I press "Link (Ctrl+L)" in the "Body" WYSIWYG Toolbar
    And I wait for ajax to finish
    And I fill in "URL*" with "www.google.com"
    And I click "OK"
    And I wait for ajax to finish
    And I select "info" from "Alert Type"
    And I publish it
    And I am on the homepage
  Then I should see the text "BEHAT Test Alert"
    And I should see the text "Testing"
    And I should see the link "http://www.google.com"

#@api
#Scenario: Check Scheduled Publish and Unpublished Alert
  #Given "sec_alert" content:
  #  | title              | body            | status | publish_on | unpublish_on |
  #  | BEHAT Test Alert 1 | This is test 1. | 1      | 111        | 222          |
  #  | BEHAT Test Alert 2 | This is test 2. | 0      | 222        | 333          |
  #  And I am on the homepage
  #  Then I should see the text "BEHAT Test Alert 1"
  #    And I should not see the text "BEHAT Test Alert 2"
  #  When I wait 70 seconds
  #  And I run drupal cron
  #  And I move backward one page
  #  And I reload the page
  #Then I should see the text "BEHAT Test Alert 2"
  #  And I should not see the text "BEHAT Test Alert 1"

@api @javascript
Scenario: Move Alert To Top of List
  Given "sec_alert" content:
    | title                    | body            | status | field_alert_type | nid   |
    | Test was a success       | This is alert 1 | 1      | success          | 11111 |
    | Info for upcoming test   | This is alert 2 | 1      | info             | 22222 |
    | Warning of upcoming test | This is alert 3 | 1      | warning          | 33333 |
    | Critical test in session | This is alert 4 | 1      | critical         | 44444 |
    And I am logged in as a user with the "Authenticated user" role
  When I am on the homepage
  Then I should see the text "Test was a success" in the "hp_alert" region
    And I should see the text "Info for upcoming test" in the "hp_alert" region
    And I should see the text "Warning of upcoming test" in the "hp_alert" region
    And I should see the text "Critical test in session" in the "hp_alert" region
    And "Test was a success" should precede "Info for upcoming test" for the query "//div[@class='alert-title']"
    And "Info for upcoming test" should precede "Warning of upcoming test" for the query "//div[@class='alert-title']"
    And "Warning of upcoming test" should precede "Critical test in session" for the query "//div[@class='alert-title']"
  When I am logged in as a user with the "Content Approver" role
    And I am on "/node/44444/edit"
    And I click on the element with css selector "#edit-options"
    And I check the box "edit-sticky-value"
    And I publish it
    And I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
  Then "Critical test in session" should precede "Test was a success" for the query "//div[@class='alert-title']"
    And "Test was a success" should precede "Info for upcoming test" for the query "//div[@class='alert-title']"
    And "Info for upcoming test" should precede "Warning of upcoming test" for the query "//div[@class='alert-title']"
