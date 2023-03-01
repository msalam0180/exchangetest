Feature: WDIO for Styles
  As a content creator
  I need to be able to style my content
  So I can display my content in a stylish manner

@api @javascript @ui @wdio @styles
Scenario: WDIO Styles For Buttons
  Given I am logged in as a user with the "Content Approver" role
  Then I take a screenshot using "styles.feature" file with "@buttons_announcements" tag
    And I take a screenshot using "styles.feature" file with "@buttons_calendar" tag
    And I take a screenshot using "styles.feature" file with "@buttons_highlights" tag
    And I take a screenshot using "styles.feature" file with "@buttons_search" tag
    And I take a screenshot using "styles.feature" file with "@buttons_style_guide" tag
