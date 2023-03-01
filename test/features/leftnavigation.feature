Feature: Create and View Left Navigation Menu on Articles
  As a Content Creator
  I want to be able to create a left navigation menu
  So that visitor can navigate to related content on detail pages

Scenario: Test Other Applicable Content Types

@api
Scenario: Display the default left nav menu for a top level group on an Article detail page
  Given I am logged in as a user with the "administrator" role
    And I create menu:
    | id              | label         | description                     |
    | behat-test-menu | behattestmenu | This is an auto generated menu. |
    And menu links:
    | title   | menu_name       |
    | Behat 1 | behat-test-menu |
    | Behat 2 | behat-test-menu |
    And "top_level_group" terms:
    | name       | field_default_menu |
    | BEHAT Term | behattestmenu      |
    And I am viewing an "sec_article" content:
    | body                  | This is the body |
    | title                 | My test article  |
    | field_top_level_group | Behat Term       |
    | status                | 1                |
  Then I should see the heading "My test article"
    And I should see the link "Behat 1" in the "leftnav" region


@api
Scenario: Override the default left nav menu for a top level group on an Article detail page
  Given I am logged in as a user with the "administrator" role
    And I create menu:
    | id                 | label              | description                     |
    | behat-test-menu    | Behat Test Menu    | This is an auto generated menu. |
    | override-test-menu | override Test Menu | This is an override test menu.  |
    And menu links:
    | title      | menu_name          |
    | Behat 1    | behat-test-menu    |
    | Behat 2    | behat-test-menu    |
    | Override 1 | override-test-menu |
    | Override 2 | override-test-menu |
    And "top_level_group" terms:
    | name       | field_default_menu |
    | BEHAT Term | Behat Test Menu    |
    And I am viewing an "sec_article" content:
    | body                    | This is the body   |
    | title                   | My test article    |
    | field_top_level_group   | Behat Term         |
    | field_show_field        | 1                  |
    | field_left_nav_override | override Test Menu |
    | status                  | 1                  |
  Then I should see the heading "My test article"
    And I should see the link "Override 1" in the "leftnav" region

@api
Scenario: Override the default left nav menu with no left nav for a top level group on an Article detail page
  Given I am logged in as a user with the "administrator" role
    And I create menu:
      | id              | label           | description                     |
      | behat-test-menu | Behat Test Menu | This is an auto generated menu. |
    And menu links:
      | title   | menu_name       |
      | Behat 1 | behat-test-menu |
      | Behat 2 | behat-test-menu |
    And "top_level_group" terms:
      | name       | field_default_menu |
      | BEHAT Term | Behat Test Menu    |
    #And "choose_left_navigation" terms:
    And I am viewing an "sec_article" content:
      | body                    | This is the body |
      | title                   | My test article  |
      | field_top_level_group   | Behat Term       |
      | field_show_field        | 1                |
      | field_left_nav_override |                  |
      | status                  | 1                |
  Then I should see the heading "My test article"
    And I should not see the link "Behat 1" in the "leftnav" region
