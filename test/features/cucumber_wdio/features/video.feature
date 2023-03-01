Feature: Create Video Screenshot
  As a Content Creator, I should be able to create Video page.

  @image_vmvideo @wdio
  Scenario: Element Screenshot of Preview Image for Vimeo Video
    Given I set my screensize to desktop
    When I visit "/gallery/behat-test-title"
      And I wait for "2" seconds
      And I hide "#block-insider-content > article > div.node__content > div.node-additional-fields.clearfix > div > span.field__item"
    Then I take screenshot of element "#content-wrapper"

  @embed_vmvideo @wdio
  Scenario: Element Screenshot of Article Embeded Vimeo Video
    Given I set my screensize to desktop
    When I visit "/my-sec/world-cup"
      And I wait for "2" seconds
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @ytube_vmvideo @wdio
  Scenario: Element Screenshot of Replicated Youtube and Vimeo Video
    Given I set my screensize to desktop
    When I visit "/gallery/behat-test"
      And I wait for "2" seconds
      And I hide "#block-insider-content > article > div.node__content > div.node-additional-fields.clearfix > div > span.field__item"
    Then I take screenshot of element "#content-wrapper"
