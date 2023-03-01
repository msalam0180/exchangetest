Feature: Create Polls Screenshot
  As a Content Approver, I should be able to create polls on the Homepage.

  @polls_layout @wdio
  Scenario: Elements Screenshot of Poll
    Given I set my screensize to desktop
    When I visit "/"
    Then I take screenshot of element "div.poll"
