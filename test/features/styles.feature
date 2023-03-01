Feature: Add and change styles
  As a Visitor to the Insider
  I want to be able to view announcements
  So that I can be kept up to date on the latest important content on the Insider

@api
Scenario: Able to see the styles code
  Given I am logged in as a user with the "administrator" role
  When I am on "/admin/config/styleguide/settings"
  Then I should see the text "COLOR PALETTE"
    And I should see the text "Hex Color Code|Class Name|Usage Description"
    And I should see the text "#273a56|Navy---$primary-color |Usage Description"

@api
Scenario: Able to see new default button color
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/config/styleguide/settings"
  Then I should see the text "COLOR PALETTE"
    And I should see the text "Hex Color Code|Class Name|Usage Description"
    And I should see the text "#2f64b2|Azure---$secondary-color |Usage Description"
    And I should see the text "#040707|Raven---$gray-dkest |Usage Description"
  When I visit "/simple-styleguide"
  Then I should see the text "Values: #2f64b2 | rgb(47,100,178)"
    And I should not see the text "Values: #2f64b1 | rgb(47,100,177)"

@api @javascript
  Scenario: Adding a new style to the existing list of styles
  Given I am logged in as a user with the "sitebuilder" role
  When I visit "/admin/config/styleguide/settings"
    And I click "Create Custom Styleguide Patterns"
    And I click "Add styleguide pattern"
    And I fill in "Label" with "BEHAT Test Styleguide"
    And I wait 2 seconds
    And I fill in "Pattern" with "BEHAT this is a test"
    And I press "Save"
  Then I should see the text "Created the BEHAT Test Styleguide Styleguide pattern."

@api
Scenario Outline: Role Access to Style Guide Creation
  Given I am logged in as a user with the "<role>" role
  When I am on "/admin/config/styleguide/patterns/add"
  Then I should see the heading "<Result1>"

	Examples:
    | role             | Result1                |
    | content_creator  | Error 403: Forbidden   |
    | content_approver | Error 403: Forbidden   |
    | sitebuilder      | Add styleguide pattern |
    | administrator    | Add styleguide pattern |

@api @javascript
Scenario Outline: Role Access and Adding a new styleguide pattern to the existing list of styles
  Given I am logged in as a user with the "sitebuilder" role
  When I visit "/admin/config/styleguide/settings"
    And I click "Create Custom Styleguide Patterns"
    And I click "Add styleguide pattern"
    And I fill in "Label" with "BEHAT Test Styleguide Pattern"
    And I wait 2 seconds
    And I fill in "Pattern" with "BEHAT Test Gir. -Yes sir!"
    And I press "Save"
    And I am logged in as a user with the "<role>" role
    And I visit "/simple-styleguide"
  Then I should see the link "behat test styleguide pattern"
    And I click "behat test styleguide pattern"
    And I should see the heading "BEHAT TEST STYLEGUIDE PATTERN"
    And I click on the element with css selector ".behat_test_styleguide_pattern-styles"
    And I should see the text "BEHAT Test Gir. -Yes sir!"
  When I am logged in as a user with the "sitebuilder" role
    And I visit "/admin/config/styleguide/patterns"
    And I click "Edit" in the "BEHAT Test Styleguide Pattern" row
    And I click "edit-delete"
  Then I should see the heading "Are you sure you want to delete BEHAT Test Styleguide Pattern?"
    And I should see the text "This action cannot be undone."
    And I press "Delete"
    And I should see the text "content styleguide_pattern: deleted BEHAT Test Styleguide Pattern"

  Examples:
  	| role             |
    | content_creator  |
  	| content_approver |
  	| sitebuilder      |
  	| administrator    |

@api
Scenario: Verify Multiple Accordions Added to Simple Styleguide
  Given I am logged in as a user with the "content_creator" role
  When I am on "/simple-styleguide"
  Then I should see the Link "accordion bd style"
    And I should see the Link "accordion bd style - independent open"
    And I should see the Link "accordion bg style"
    And I should see the Link "accordion bg style - independent open"
    And I should see the Link "accordion bg style with heading"
    And I should see the Link "accordion bg style with heading - independent open"
    And I should see the Link "accordion bg style with multiple headings"
    And I should see the Link "accordion bg style with multiple headings - independent open"

@api @javascript
Scenario: Verify Accordions BD Dependent
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/config/styleguide/patterns/accordion_bd_style/edit"
    And I copy html within css selector "#edit-pattern" into "behat"
    And I visit "/node/add/page"
    And I fill in "Title" with "Title Behat Test"
    And I press "Source" in the WYSIWYG Toolbar
    And I paste "behat" in css selector ".cke_source"
    And I publish it
  Then I should see the text "Item Title 1"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(1)"
    And I wait 1 seconds
    And I should see the text "Item Content 1"
    And I should not see the text "Item Content 2"
    And I should not see the text "Item Content 3"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(3)"
    And I wait 1 seconds
    And I should see the text "Item Content 2"
    And I should not see the text "Item Content 1"
    And I should not see the text "Item Content 3"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(5)"
    And I wait 1 seconds
    And I should see the text "Item Content 3"
    And I should not see the text "Item Content 1"
    And I should not see the text "Item Content 2"

@api @javascript
Scenario: Verify Accordions BD Independent
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/config/styleguide/patterns/accordion_bd_style_independent_open/edit"
    And I copy html within css selector "#edit-pattern" into "behat"
    And I visit "/node/add/page"
    And I fill in "Title" with "Title Behat Test"
    And I press "Source" in the WYSIWYG Toolbar
    And I paste "behat" in css selector ".cke_source"
    And I publish it
  Then I should see the text "Item Title 1"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(1)"
    And I click on the element with css selector "#ui-id-17"
    And I click on the element with css selector "#ui-id-19"
    And I wait 1 seconds
    And I should see the text "Item Content 1"
    And I should see the text "Item Content 2"
    And I should see the text "Item Content 3"

@api @javascript
Scenario: Verify Accordions BG Dependent
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/config/styleguide/patterns/accordion_bg_style/edit"
    And I copy html within css selector "#edit-pattern" into "behat"
    And I visit "/node/add/page"
    And I fill in "Title" with "Title Behat Test"
    And I press "Source" in the WYSIWYG Toolbar
    And I paste "behat" in css selector ".cke_source"
    And I publish it
  Then I should see the text "Item Title 1"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(1)"
    And I wait 1 seconds
    And I should see the text "Item Content 1"
    And I should not see the text "Item Content 2"
    And I should not see the text "Item Content 3"
    And I click on the element with css selector "#ui-id-17"
    And I wait 1 seconds
    And I should not see the text "Item Content 1"
    And I should see the text "Item Content 2"
    And I should not see the text "Item Content 3"
    And I click on the element with css selector "#ui-id-19"
    And I wait 1 seconds
    And I should not see the text "Item Content 1"
    And I should not see the text "Item Content 2"
    And I should see the text "Item Content 3"

@api @javascript
Scenario: Verify Accordions BG Independent
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/config/styleguide/patterns/accordion_bg_style_independent_open/edit"
    And I copy html within css selector "#edit-pattern" into "behat"
    And I visit "/node/add/page"
    And I fill in "Title" with "Title Behat Test"
    And I press "Source" in the WYSIWYG Toolbar
    And I paste "behat" in css selector ".cke_source"
    And I publish it
  Then I should see the text "Item Title 1"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(1)"
    And I click on the element with css selector "#ui-id-17"
    And I click on the element with css selector "#ui-id-19"
    And I should see the text "Item Content 1"
    And I should see the text "Item Content 2"
    And I should see the text "Item Content 3"

@api @javascript
Scenario: Verify Accordions BG with Heading Dependent
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/config/styleguide/patterns/accordion_bg_style_with_heading/edit"
    And I copy html within css selector "#edit-pattern" into "behat"
    And I visit "/node/add/page"
    And I fill in "Title" with "Title Behat Test"
    And I press "Source" in the WYSIWYG Toolbar
    And I paste "behat" in css selector ".cke_source"
    And I publish it
  Then I should see the text "Medium Heading"
    And I should see the text "Item Title 1"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(1)"
    And I wait 1 seconds
    And I should see the text "Item Content 1"
    And I should not see the text "Item Content 2"
    And I should not see the text "Item Content 3"
    And I click on the element with css selector "#ui-id-17"
    And I wait 1 seconds
    And I should not see the text "Item Content 1"
    And I should see the text "Item Content 2"
    And I should not see the text "Item Content 3"
    And I click on the element with css selector "#ui-id-19"
    And I wait 1 seconds
    And I should not see the text "Item Content 1"
    And I should not see the text "Item Content 2"
    And I should see the text "Item Content 3"

@api @javascript
Scenario: Verify Accordions BG With Heading Independent
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/config/styleguide/patterns/accordion_bg_style_with_heading_independent_open/edit"
    And I copy html within css selector "#edit-pattern" into "behat"
    And I visit "/node/add/page"
    And I fill in "Title" with "Title Behat Test"
    And I press "Source" in the WYSIWYG Toolbar
    And I paste "behat" in css selector ".cke_source"
    And I publish it
  Then I should see the text "Medium Heading"
    And I should see the text "Item Title 1"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(1)"
    And I click on the element with css selector "#ui-id-17"
    And I click on the element with css selector "#ui-id-19"
    And I should see the text "Item Content 1"
    And I should see the text "Item Content 2"
    And I should see the text "Item Content 3"

@api @javascript
Scenario: Verify Accordions BG with Multiple Heading Dependent
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/config/styleguide/patterns/accordion_bg_style_with_multiple_headings/edit"
    And I copy html within css selector "#edit-pattern" into "behat"
    And I visit "/node/add/page"
    And I fill in "Title" with "Title Behat Test"
    And I press "Source" in the WYSIWYG Toolbar
    And I paste "behat" in css selector ".cke_source"
    And I publish it
  Then I should see the text "Dark Heading"
    And I should see the text "Medium Heading"
    And I should see the text "Item Title 1"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(1)"
    And I wait 1 seconds
    And I should see the text "Item Content 1"
    And I should not see the text "Item Content 2"
    And I should not see the text "Item Content 3"
    And I click on the element with css selector "#ui-id-17"
    And I wait 1 seconds
    And I should not see the text "Item Content 1"
    And I should see the text "Item Content 2"
    And I should not see the text "Item Content 3"
    And I click on the element with css selector "#ui-id-19"
    And I wait 1 seconds
    And I should not see the text "Item Content 1"
    And I should not see the text "Item Content 2"
    And I should see the text "Item Content 3"

@api @javascript
Scenario: Verify Accordions BG With Multiple Heading Independent
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/config/styleguide/patterns/accordion_bg_style_with_multiple_headings_independent_open/edit"
    And I copy html within css selector "#edit-pattern" into "behat"
    And I visit "/node/add/page"
    And I fill in "Title" with "Title Behat Test"
    And I press "Source" in the WYSIWYG Toolbar
    And I paste "behat" in css selector ".cke_source"
    And I publish it
  Then I should see the text "Dark Heading"
    And I should see the text "Medium Heading"
    And I should see the text "Item Title 1"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(1)"
    And I click on the element with css selector "#ui-id-17"
    And I click on the element with css selector "#ui-id-19"
    And I should see the text "Item Content 1"
    And I should see the text "Item Content 2"
    And I should see the text "Item Content 3"

@api @javascript
Scenario: Add Accordion to Event
  Given I am logged in as a user with the "sitebuilder" role
    And "topic" terms:
      | name            |
      | human resources |
    And "top_level_group" terms:
      | name   | field_abbreviation |
      | sports | spt                |
    And I create "paragraph" of type "paragraph_session":
      | KEY | field_location | field_start_date | field_end_date | type              |
      | 100 | Texas          | +2 hour          | +1 day         | paragraph_session |
    And I create "node" of type "event":
      | title                       | field_short_title | body                | field_source | field_topic     | field_top_level_group | status | field_session |
      | BEHAT Test Event - Training | Home Page Title 0 | This is an Event 0. | Minnie Mouse | human resources | sports                | 1      | 100           |

    And I visit "/admin/config/styleguide/patterns/accordion_bd_style_independent_open/edit"
    And I copy html within css selector "#edit-pattern" into "behat"
  When I am logged in as a user with the "content_creator" role
    And I visit "/admin/content"
    And I click "Edit" in the "BEHAT Test Event - Training" row
    And I select "Training" from "Event Type"
    And I scroll "#edit-body-wrapper" into view
    And I press "Source" in the WYSIWYG Toolbar
    And I paste "behat" in css selector ".cke_source"
    And I press the "Save and Create New Draft" button
  Then I should see the text "BEHAT Test Event - Training"
    And I should see the text "Item Title 1"
    And I click on the element with css selector "div.ui-accordion-header:nth-child(1)"
    And I should see the text "Item Content 1"

@api @javascript
Scenario: Create a Page with multiple Accordions
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin/config/styleguide/patterns/accordion_bd_style/edit"
    And I copy html within css selector "#edit-pattern" into "behat"
    And I visit "/node/add/page"
    And I fill in "Title" with "Title Behat Test"
    And I press "Source" in the WYSIWYG Toolbar
    And I paste "behat" in css selector ".cke_source"
    And I publish it
    And I visit "/admin/config/styleguide/patterns/accordion_bg_style_with_multiple_headings_independent_open/edit"
    And I copy html within css selector "#edit-pattern" into "behat1"
    And I visit "/admin/content"
    And I click "Edit" in the "Title Behat Test" row
    And I wait 3 seconds
    And I press "Source" in the WYSIWYG Toolbar
    And I add html "behat" and "behat1" into css selector ".cke_source"
    And I publish it
    And I click "Title Behat Test"
  Then I should see the text "Item Title 1"
    And I click on the element with css selector "div.ui-accordion:nth-child(1) > div:nth-child(1)"
    And I click on the element with css selector "div.ui-accordion:nth-child(1) > div:nth-child(3)"
    And I click on the element with css selector "div.ui-accordion:nth-child(1) > div:nth-child(5)"
    And I click on the element with css selector "div.node__content > div > div:nth-child(2)>div:nth-child(3)"
    And I click on the element with css selector "div.node__content > div > div:nth-child(2)>div:nth-child(4)"
    And I click on the element with css selector "div.node__content > div > div:nth-child(2)>div:nth-child(5)"
    And I should see the text "Item Content 1"
    And I should see the text "Item Content 2"
    And I should see the text "Item Content 3"

@api @javascript
Scenario: Adding and Interacting With Tab Styling
  Given I am logged in as a user with the "content_approver" role
    And "landing_page" content:
      | title                        | publish_at             | field_description_abstract | field_top_level_group | status | body  |
      | Behat Landing Page with Tabs | 2017-11-11 12:00:00 PM | Test                       | News                  | 1      | mango |
  When I am on "/admin/content"
    And I click "Edit" in the "Behat Landing Page with Tabs" row
    And I press the 'Left Content' button
    And I scroll '#edit-field-left-3-box-0-value' into view
    And I press "Source" in the "Left 3 - Box" WYSIWYG Toolbar
    And I type '<div id="tabs-corpfin"><ul><li><a href="#tab1">Statutes</a></li><li><a href="#tab2">Rules</a></li><li><a href="#tab3">Forms</a></li><li><a href="#tab4">Special Filers / Transactions</a></li></ul><div id="tab1"><h3>Some Statutes</h3></div><div id="tab2"><h3>Some Rules</h3></div><div id="tab3"><h3>Some Forms</h3></div><div id="tab4"><h3>Some Special Filers / Transactions</h3></div></div>' in css selector "#cke_3_contents > textarea"
    And I publish it
  #Interactions to test tabs are working:
  When I click on the element with css selector "#tabs-corpfin > ul > li:nth-child(1)"
  Then I should see the text "Some Statutes"
    And I should not see the text "Some Rules"
    And I should not see the text "Some Forms"
    And I should not see the text "Some Special Filers / Transactions"
  When I click on the element with css selector "#tabs-corpfin > ul > li:nth-child(2)"
  Then I should see the text "Some Rules"
    And I should not see the text "Some Statutes"
    And I should not see the text "Some Forms"
    And I should not see the text "Some Special Filers / Transactions"
  When I click on the element with css selector "#tabs-corpfin > ul > li:nth-child(3)"
  Then I should see the text "Some Forms"
    And I should not see the text "Some Statutes"
    And I should not see the text "Some Rules"
    And I should not see the text "Some Special Filers / Transactions"
  When I click on the element with css selector "#tabs-corpfin > ul > li:nth-child(4)"
  Then I should see the text "Some Special Filers / Transactions"
    And I should not see the text "Some Statutes"
    And I should not see the text "Some Rules"
    And I should not see the text "Some Forms"
