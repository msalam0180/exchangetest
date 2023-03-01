Feature: WDIO Polls
  As a site visitor, I want to take a poll on a topic of interest to me so that I can learn how other employees feel about that topic.

@api @javascript @ui @wdio
Scenario: WDIO Poll On The Exchange Homepage
  Given I am logged in as a user with the "content_approver" role
  When I visit "/poll/add"
    And I enter "What was the Division of Examinations previously called back in 2020?" for "Question"
    And I enter "Office of Compliance, Inspections, and Examinations" for "choice[0][choice]"
    And I press "Add another item"
    And I wait 2 seconds
    And I enter "Office of Compliance Inspections and Examinations" for "choice[1][choice]"
    And I press "Add another item"
    And I wait 2 seconds
    And I enter "Office of Inspections" for "choice[2][choice]"
    And I press "Add another item"
    And I wait 2 seconds
    And I enter "Office of Examinations" for "choice[3][choice]"
    And I check the box "Featured"
    And I press "Save"
  Then I take a screenshot using "polls.feature" file with "@polls_layout" tag
