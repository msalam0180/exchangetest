Feature: Polls
  As a site visitor, I want to take a poll on a topic of interest to me so that I can learn how other employees feel about that topic.

@api @javascript
  Scenario Outline: Polls on The Exchange homepage
    #Create the poll
    Given I am logged in as a user with the "<role>" role
    When I visit "/poll/add"
      And I enter "<poll question>" for "Question"
      And I enter "HI" for "choice[0][choice]"
      And I press "Add another item"
      And I wait 2 seconds
      And I enter "FL" for "choice[1][choice]"
      And I press "Add another item"
      And I wait 2 seconds
      And I enter "CA" for "choice[2][choice]"
      And I press "Add another item"
      And I wait 2 seconds
      And I enter "NC" for "choice[3][choice]"
      And I press "Add another item"
      And I wait 2 seconds
      And I enter "NY" for "choice[4][choice]"
      And the "Active" checkbox should be checked
      And the "Featured" checkbox should be unchecked
      And I press "Save"
      And I wait 2 seconds
    Then I should see the text "The poll <poll question> has been added."
    # Poll appearing on details page
      And I click "<poll question>"
    Then I should see the text "<poll question>"
    # Assert that since poll is active but not featured and thus will not appear on homepage
    When I go to homepage
    Then I should not see the text "<poll question>"

    # Edit same poll (to: featured but not active)
    When I visit "/admin/content/poll"
      And I click "Edit" in the "<poll question>" row
      And I scroll to the bottom
      And I uncheck the box "Active"
      And I check the box "Featured"
      And I press "Save"
      And I wait 2 seconds
      Then I should see the text "The poll <poll question> has been updated."
    # Assert that since poll is featured but not active and thus will not appear on homepage
    When I go to homepage
    Then I should not see the text "<poll question>"

    # Edit same poll (to: featured and is active)
    When I visit "/admin/content/poll"
      And I click on the element with css selector "#edit-status option[value=2]"
      And I press "Apply"
      And I click "Edit" in the "<poll question>" row
      And I scroll to the bottom
      And I check the box "Active"
      And the "Featured" checkbox should be checked
      And I press "Save"
      And I wait 2 seconds
    Then I should see the text "The poll <poll question> has been updated."
    # Assert that since poll is both featured and is active and thus it WILL now appear on homepage
    When I go to homepage
    Then I should see the text "<poll question>"

    # Using the poll to Vote and validating results: Authenticated users should be able to vote only once and see the poll results on the homepage
    When I am logged in as a user with the "Authenticated user" role
      And I go to homepage
      And I should see the text "<poll question>"
      And I should not see the button "View results"
      And I select the radio button "CA"
      And I press "Vote"
      And I wait 2 seconds
      And I should see the text "100% (1 vote)"
      And I should see the text "Total votes: 1"
      And I should not see the button "Vote"
      And I should not see the button "View results"
      And I should not see the button "Cancel vote"

    Examples:
      | role             | poll question                          |
      | content_approver | What is your favorite Vacation State?  |
      | sitebuilder      | What is your favorite State in Summer? |

@api @javascript
  Scenario: Feature poll permissions

    # content_creator cannot see "Featured" checkbox to add poll
    Given I am logged in as a user with the "content_creator" role
    When I visit "/poll/add"
    And I scroll to the bottom
    Then I should not see "Featured"

    # content_approver can see "Featured" checkbox
    Given I am logged in as a user with the "content_approver" role
    When I visit "/poll/add"
    And I scroll to the bottom
    Then I should see "Featured"

