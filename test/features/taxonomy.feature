Feature: Manage Taxonomies
  As a Content Creator for the Insider
  I want to be able to manage different taxonomies
  So that I can easily group content

Background:
Given I am logged in as a user with the "administrator" role

@api @javascript
Scenario Outline: Add a Term to a Taxonomy
  Given I visit "<Page>"
  When I click "List" in the "page_tabs" region
    And I click "Add term"
    And I fill in "Name" with "BEHAT New Joiner"
    And I press the "Save" button
  Then I should see the text "Created new term BEHAT New Joiner."

  Examples:
    | Page                                             |
    | /admin/structure/taxonomy/manage/audiences       |
    | /admin/structure/taxonomy/manage/group_club      |
    | /admin/structure/taxonomy/manage/office_division |
    | /admin/structure/taxonomy/manage/topic           |
    | /admin/structure/taxonomy/manage/form_topic      |


@api @javascript
Scenario Outline: Edit a Term in a Taxonomy
  Given "<Taxonomy>" terms:
    | name   |
    | Cody   |
    | Lawyer |
  When I visit "<Page>"
    And I click "List" in the "page_tabs" region
    And I click "Edit" in the "Cody" row
    And I fill in "Name" with "Outsider"
    And I press the "Save" button
  Then I should see the link "Outsider"
    And I should see the link "Lawyer"
    And I should not see the link "Cody"

  Examples:
    | Page                                             | Taxonomy        |
    | /admin/structure/taxonomy/manage/audiences       | audiences       |
    | /admin/structure/taxonomy/manage/group_club      | group_club      |
    | /admin/structure/taxonomy/manage/office_division | office_division |
    | /admin/structure/taxonomy/manage/topic           | topic           |
    | /admin/structure/taxonomy/manage/form_topic      | form_topic      |

@api @javascript
Scenario Outline: Delete a Term in a Taxonomy
  Given "<Taxonomy>" terms:
    | name   |
    | Cody   |
    | Lawyer |
  When I visit "<Page>"
    And I click "List" in the "page_tabs" region
    And I click "Edit" in the "Cody" row
    And I click "edit-delete"
    And I press the "Delete" button
  Then I should not see the link "Cody"
    And I should see the link "Lawyer"

  Examples:
    | Page                                             | Taxonomy        |
    | /admin/structure/taxonomy/manage/audiences       | audiences       |
    | /admin/structure/taxonomy/manage/group_club      | group_club      |
    | /admin/structure/taxonomy/manage/office_division | office_division |
    | /admin/structure/taxonomy/manage/topic           | topic           |
    | /admin/structure/taxonomy/manage/form_topic      | form_topic      |
