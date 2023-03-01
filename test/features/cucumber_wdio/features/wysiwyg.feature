Feature: Create Embeded Wysiwyg Image Screenshot
  As a Content Creator, I should be able to create announcement page.

  @image_default_left_alignment @wdio
  Scenario: Element Screenshot of Left Alignment Image Default Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-default-embed-left-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_default_right_alignment @wdio
  Scenario: Element Screenshot of Right Alignment Image Default Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-default-embed-right-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_default_center_alignment @wdio
  Scenario: Element Screenshot of Center Alignment Image Default Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-default-embed-center-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_default_no_alignment @wdio
  Scenario: Element Screenshot of None Alignment Image Default Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-default-embed-no-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_fw_left_alignment @wdio
  Scenario: Element Screenshot of Left Alignment Image Full Width Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-full-width-embed-left-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_fw_right_alignment @wdio
  Scenario: Element Screenshot of Right Alignment Image Full Width Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-full-width-embed-right-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_fw_center_alignment @wdio
  Scenario: Element Screenshot of Center Alignment Image Full Width Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-full-width-embed-center-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_fw_no_alignment @wdio
  Scenario: Element Screenshot of None Alignment Image Full Width Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-full-width-embed-no-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_org_left_alignment @wdio
  Scenario: Element Screenshot of Left Alignment Image Original Size Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-original-size-embed-left-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_org_right_alignment @wdio
  Scenario: Element Screenshot of Right Alignment Image Original Size Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-original-size-embed-right-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_org_center_alignment @wdio
  Scenario: Element Screenshot of Center Alignment Image Original Size Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-original-size-embed-center-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_org_no_alignment @wdio
  Scenario: Element Screenshot of None Alignment Image Original Size Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-original-size-embed-no-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_teaser_left_alignment @wdio
  Scenario: Element Screenshot of Left Alignment Image Teaser Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-teaser-embed-left-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_teaser_right_alignment @wdio
  Scenario: Element Screenshot of Right Alignment Image Teaser Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-teaser-embed-right-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_teaser_center_alignment @wdio
  Scenario: Element Screenshot of Center Alignment Image Teaser Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-teaser-embed-center-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"

  @image_teaser_no_alignment @wdio
  Scenario: Element Screenshot of None Alignment Image Teaser Embed
    Given I set my screensize to desktop
    When I visit "/wdio-image-teaser-embed-no-alignment"
      And I hide "#block-insider-content > article > div.node-additional-fields.clearfix > div.modified-date.field"
    Then I take screenshot of element "#content-wrapper"
