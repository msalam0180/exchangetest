Feature: Create Styles Screenshot
  As a Content Creator, I should be able to add styling to my content.

  @buttons_announcements @wdio
  Scenario: Element Screenshot of Announcements List Page Buttons
    Given I set my screensize to desktop
    When I visit "/news/announcements?aId=edit-submit-announcements-list&field_announcement_type_target_id=All&combine="
    Then I take screenshot of element "#content-wrapper"

  @buttons_calendar @wdio
  Scenario: Element Screenshot of Events List Page Buttons
    Given I set my screensize to desktop
    When I visit "/news/calendar?aId=edit-submit-events-list&field_event_type_value=All&field_start_date_value=&field_end_date_value=&combine="
    Then I take screenshot of element "#content-wrapper"

  @buttons_highlights @wdio
  Scenario: Element Screenshot of Highlights List Page Buttons
    Given I set my screensize to desktop
    When I visit "/news/highlights-archive?aId=edit-submit-highlights-archive&field_featured_type_value=All&combine="
    Then I take screenshot of element "#content-wrapper"

  @buttons_search @wdio
  Scenario: Element Screenshot of Search Buttons
    Given I set my screensize to desktop
    When I visit "/search?"
    Then I take screenshot of element "#content-wrapper"

  @buttons_style_guide @wdio
  Scenario: Element Screenshot of Button Styles
    Given I login as admin
    When I set my screensize to desktop
      And I visit "/simple-styleguide#buttons"
      And I hide "#environment-indicator"
    Then I take screenshot of element "div.simple-styleguide"
