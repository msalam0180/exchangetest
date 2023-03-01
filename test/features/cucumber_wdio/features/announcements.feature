Feature: Create Announcement Screenshot
  As a Content Creator, I should be able to create announcement page.

  @memo_image @wdio
  Scenario: Element Screenshot of Memo With Image Embed
    Given I set my screensize to desktop
    When I visit "/node/1212022"
    Then I take screenshot of element "#main-wrapper"

  @obit_image @wdio
  Scenario: Element Screenshot of Obituary With Image Embed
    Given I set my screensize to desktop
    When I visit "/node/1212022"
    Then I take screenshot of element "#main-wrapper"

  @det_image @wdio
  Scenario: Element Screenshot of Detail With Image Embed
    Given I set my screensize to desktop
    When I visit "/node/1212022"
    Then I take screenshot of element "#main-wrapper"

  @train_image @wdio
  Scenario: Element Screenshot of Training With Image Embed
    Given I set my screensize to desktop
    When I visit "/node/1212022"
    Then I take screenshot of element "#main-wrapper"

  @memo_wzvideo @wdio
  Scenario: Element Screenshot of Memo With Wowza Video Embed
    Given I set my screensize to desktop
    When I visit "/node/1212022"
      And I wait for "2" seconds
      And I hide "#environment-indicator, #page > section:nth-child(1), .sitefooter"
    Then I take full page screenshot

  @obit_wzvideo @wdio
  Scenario: Element Screenshot of Obituary With Wowza Video Embed
    Given I set my screensize to desktop
    When I visit "/node/1212022"
      And I wait for "2" seconds
      And I hide "#environment-indicator, #page > section:nth-child(1), .sitefooter"
    Then I take full page screenshot

  @det_wzvideo @wdio
  Scenario: Element Screenshot of Detail With Wowza Video Embed
    Given I set my screensize to desktop
    When I visit "/node/1212022"
      And I wait for "2" seconds
      And I hide "#environment-indicator, #page > section:nth-child(1), .sitefooter"
    Then I take full page screenshot

  @train_wzvideo @wdio
  Scenario: Element Screenshot of Training With Wowza Video Embed
    Given I set my screensize to desktop
    When I visit "/node/1212022"
      And I wait for "2" seconds
      And I hide "#environment-indicator, #page > section:nth-child(1), .sitefooter"
    Then I take full page screenshot

  @memo_ytvideo @wdio
  Scenario: Element Screenshot of Memo With YouTube Video Embed
    Given I set my screensize to desktop
    When I visit "/node/1212022"
      And I wait for "2" seconds
      And I hide "#environment-indicator, #page > section:nth-child(1), .sitefooter"
    Then I take full page screenshot

  @obit_vmvideo @wdio
  Scenario: Element Screenshot of Obituary With Vimeo Video Embed
    Given I set my screensize to desktop
    When I visit "/node/1212022"
      And I wait for "2" seconds
      And I hide "#environment-indicator, #page > section:nth-child(1), .sitefooter"
    Then I take full page screenshot

  @announcement_pagi @wdio
  Scenario: Element Screenshot of Announcements Pagination
    Given I set my screensize to desktop
    When I visit "/news/announcements?&items_per_page=10"
      And I click on "#table_paging > div.pager-wrapper > nav > ul > li.pager__item.pager__item--next > a"
      And I hide "#environment-indicator, #block-insider-content > article > div > div > div.panel-panel.panel-top > div > div.block.field_center_2_box > div, #block-insider-content > article > div > div > div.panel-panel.panel-top > div > div.views-element-container.block.announcements_list-block_3 > div > div > div.view-filters, #page > section:nth-child(1), #sidebar-first > aside > nav, #content-wrapper > h1, #filter, .sitefooter"
    Then I take full page screenshot
