Feature: Configuration
  As a user with a specific role
  I want to be able to access the allowed site administration UI sections
  So that I am able to perform some specific tasks

@api
Scenario: Clearing Cache By Sitebuilder
  Given I am logged in as a user with the "sitebuilder" role
    And I visit "/admin/config/development/performance"
  Then the response status code should be 200
  When I press "Clear all caches"
  Then I should see the text "Caches cleared."

@api
Scenario Outline: Page Access To Flush Drupal Cache
  Given I am logged in as a user with the "<role>" role
  When I am on "/admin/config/development/performance"
  Then the response status code should be <code>

  Examples:
    | role               | code |
    | content_creator    | 403  |
    | content_approver   | 403  |
    | microsite_creator  | 403  |
    | microsite_approver | 403  |
    | administrator      | 200  |

@api @javascript
Scenario Outline: Link Access To Clear Drupal Cache
  Given I am logged in as a user with the "<role>" role
  When I click "Workbench"
    And I click "Manage"
    And I hover over the element ".toolbar-icon-admin-toolbar-tools-help"
    And I wait 1 seconds
  Then I should <validate> the text "Flush all caches"

  Examples:
    | role               | validate |
    | content_creator    | not see  |
    | content_approver   | not see  |
    | microsite_creator  | not see  |
    | microsite_approver | not see  |
    | administrator      | see      |
    | sitebuilder        | see      |
