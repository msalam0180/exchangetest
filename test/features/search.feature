Feature: Test Search Functionality
  As a Content Creator
  I want to be able to search content
  So that visitors to the Insider can find relative content

Background:
  Given "topic" terms:
    | name     |
    | behat    |
    | sec      |
    | airforce |
    And "top_level_group" terms:
      | name     |
      | anything |
      | elite    |
    And "form_topic" terms:
      | name       |
      | Altruists  |
      | Boondoggle |
      | Man of War |
    And "tags" terms:
      | name     |
      | pear     |
      | lemon    |
      | rambutan |
      | durian   |
    And "site_section_theme" terms:
      | name         |
      | yellowOrange |
    And "site_section" terms:
      | name     |
      | corpfin1 |
    # And "landing_page" content:
    #   | title              |field_left_1_box  |field_right_2_box  |field_center_2_box | field_site_section | promote | status |
    #   | BEHAT Landing Page |This is left box1 |This is right box2 |This is center box | corpfin1           | 1       | 1      |

@api
Scenario: Search returns the correct result for article content types
  Given "sec_article" content:
    | title             | body         | field_source | field_top_level_group | field_topic | status | field_tags | published_at        | field_override_modified_date | moderation_state | changed             |
    | Behat Article X1  | mango        | orange       | anything              | airforce    | 1      | rambutan   | 2020-07-03T16:00:05 | 2020-07-25T17:00:05          | published        | 2020-05-01T13:00:05 |
    | Behat Article-2   | papaya       | guava        | anything              | airforce    | 1      | pear       | 2020-02-14T12:00:05 |                              | published        | 2020-06-14T14:00:05 |
    | Sample Content PQ | x1 pineapple | grapefruit   | elite                 | sec         | 1      | lemon      | 2020-03-12T14:00:05 |                              | published        | 2020-08-12T15:00:05 |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "Behat Article X1"
    And I press the "Search" button
  Then I should see the link "Behat Article X1"
    And I should see the text "July 25, 2020"
    And I should not see the link "Behat Article-2"
    And I should not see the link "Sample Content PQ"
  When I fill in "edit-keys" with "Behat Article"
    And I press the "Search" button
  Then I should see the link "Behat Article X1"
    And I should see the link "Behat Article-2"
    But I should not see the link "Sample Content PQ"
  When I fill in "edit-keys" with "papaya"
    And I press the "Search" button
  Then I should see the link "Behat Article-2"
    And I should see the text "June 14, 2020"
    And I should not see the link "Behat Article X1"
    And I should not see the link "Sample Content PQ"
  When I fill in "edit-keys" with "orange"
    And I press the "Search" button
  Then I should see the link "Behat Article X1"
    But I should not see the link "Behat Article-2"
    And I should not see the link "Sample Content PQ"
  When I fill in "edit-keys" with "airforce"
    And I press the "Search" button
  Then I should see the link "Behat Article-2"
    And I should see the link "Behat Article X1"
    But I should not see the link "Sample Content PQ"
  When I fill in "edit-keys" with "rambutan"
    And I press the "Search" button
  Then I should see the link "Behat Article X1"
    But I should not see the link "Behat Article-2"
    And I should not see the link "Sample Content PQ"
  When I fill in "edit-keys" with "X1"
    And I press the "Search" button
  Then I should see the link "Behat Article X1"
    And I should see the link "Sample Content PQ"
    But I should not see the link "Behat Article-2"
  When I fill in "edit-keys" with "PQ"
    And I press the "Search" button
  Then I should see the link "Sample Content PQ"
    And I should see the text "Aug. 12, 2020"
    And I should not see the link "Behat Article X1"
    And I should not see the link "Behat Article-2"

@api
Scenario: Search returns the correct result for announcement content type
  Given "announcement" content:
    | title              | field_short_title | body      | field_source | field_topic | field_top_level_group | status | field_from | field_to  | field_tags | published_at        | field_override_modified_date | moderation_state | changed             |
    | Behat Announcement | pitcher           | mango     | orange       | airforce    | elite                 | 1      | Mussina    | Frohwirth | rambutan   | 2020-07-03T16:00:05 | 2020-07-25T16:00:05          | published        | 2020-05-01T13:00:05 |
    | Another Thing Ps5  | designated hitter | pineapple | guava        | sec         | elite                 | 1      | Trumbo     | Mancini   | lemon      | 2020-06-14T12:00:05 |                              | published        | 2020-08-12T15:00:05 |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "behat announcement"
    And I press the "Search" button
  Then I should see the link "Behat Announcement"
    But I should not see the link "Another Thing Ps5"
    And I should see the text "July 25, 2020"
    But I should not see the text "July 3, 2020"
    And I fill in "edit-keys" with "pineapple"
    And I press the "Search" button
  Then I should see the link "Another Thing Ps5"
    But I should not see the link "Behat Announcement"
    And I should see the text "June 14, 2020"
    And I fill in "edit-keys" with "orange"
    And I press the "Search" button
  Then I should see the link "Behat Announcement"
    But I should not see the link "Another Thing Ps5"
    And I fill in "edit-keys" with "trumbo"
    And I press the "Search" button
  Then I should see the link "Another Thing Ps5"
    But I should not see the link "Behat Announcement"
    And I fill in "edit-keys" with "airforce"
    And I press the "Search" button
  Then I should see the link "Behat Announcement"
    But I should not see the link "Another Thing Ps5"
    And I fill in "edit-keys" with "mancini"
    And I press the "Search" button
  Then I should see the link "Another Thing Ps5"
    But I should not see the link "Behat Announcement"
    And I fill in "edit-keys" with "pitcher"
    And I press the "Search" button
  Then I should see the link "Behat Announcement"
    But I should not see the link "Another Thing Ps5"
    And I fill in "edit-keys" with "lemon"
    And I press the "Search" button
  Then I should see the link "Another Thing Ps5"
    But I should not see the link "Behat Announcement"
    And I fill in "edit-keys" with "ps5"
    And I press the "Search" button
  Then I should see the link "Another Thing Ps5"
    But I should not see the link "Behat Announcement"

@api
Scenario: Search returns no result for static file
  Given "file" content:
    | title                    | publish_at             | field_description_abstract            | field_file_upload    | status | field_topic | field_tags |
    | Behat First Testing File | 2017-11-11 12:00:00 PM | This is a description of ice cream    | file;behat-file.pdf  | 1      | sec         | rambutan   |
    | Second Test Object       | 2017-08-12 12:00:00 PM | This is a description of announcement | file;behat-file.docx | 1      | airforce    | lemon      |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "Behat First"
    And I press the "Search" button
  Then I should not see the link "Behat First Testing File"
    And I should not see the link "Second Test Object"
    And I fill in "edit-keys" with "second-test-object.docx"
    And I press the "Search" button
  Then I should not see the link "Second Test Object"
    And I should not see the link "Behat First Testing File"
    And I fill in "edit-keys" with "ice cream"
    And I press the "Search" button
  Then I should not see the link "Behat First Testing File"
    And I should not see the link "Second Test Object"
    And I fill in "edit-keys" with "airforce"
    And I press the "Search" button
  Then I should not see the link "Second Test Object"
    And I should not see the link "Behat First Testing File"
    And I fill in "edit-keys" with "rambutan"
    And I press the "Search" button
  Then I should not see the link "Behat First Testing File"
    And I should not see the link "Second Test Object"
    And I fill in "edit-keys" with "Second Test Object"
    And I press the "Search" button
  Then I should not see the link "Second Test Object"
    And I should not see the link "Behat First Testing File"

@api
Scenario: Search returns the correct result for media file type
  Given I create "media" of type "file":
    | name                               | field_media_file                 | field_media_description_abstract                                                                                                                                                                                                                    | field_media_topic | field_media_top_level_group | status |
    | Behat First Media Pdf File         | behat-the-mighty-5.pdf           | "The state is a center of transportation, education, information technology and research, government services, mining, and a major tourist destination for outdoor recreation."                                                                     | sec               | elite                       | 1      |
    | Behat Second Media Word Doc File   | behat-sweden.docx                | "It is not known when and how the kingdom of Sweden was born, but the list of Swedish monarchs is drawn from the first kings known to have ruled both Svealand (Sweden) and Götaland (Gothia) as one province, beginning with Eric the Victorious." | airforce          | anything                    | 1      |
    | Behat Third Media Excel File       | behat-orange-and-black-bird.xlsx | "Description/Abstract" with "The Miles-Krieger (Gunther Brewing Company)-Hoffberger group renamed their new team the Baltimore Orioles soon after taking control of the franchise."                                                                 | behat             | elite                       | 1      |
    | Behat Fourth Media Powerpoint File | behat-banff-national-park.pptx   | "Banff is home to several cultural institutions, including the Banff Centre, the Whyte Museum, the Buffalo Nations Luxton Museum, Cave and Basin National Historic Site, and several art galleries."                                                | behat             | elite                       | 1      |
    | Behat Fifth Media Compressed File  | behat-file.zip                   | "This is for compressed media file search"                                                                                                                                                                                                          | behat             | elite                       | 1      |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "compressed file"
    And I press the "Search" button
  Then I should see the link "Behat Fifth Media Compressed File"
    And I should not see the link "Behat Second Media Word Doc File"
    And I should not see the link "Behat Fourth Media Powerpoint File"
  # Search for description/teaser text
  When I fill in "edit-keys" with "major tourist destination"
    And I press the "Search" button
  Then I should see the link "Behat First Media Pdf File"
    But I should not see the link "Behat Second Media Word Doc File"
  When I fill in "edit-keys" with "cultural institutions"
    And I press the "Search" button
  Then I should see the link "Behat Fourth Media Powerpoint File"
  # Search for text in different media files (stopped working locally after 2.3)
    And I fill in "edit-keys" with "majestic view"
  When I press the "Search" button
  Then I should see the link "Behat First Media Pdf File"
    But I should not see the link "Behat Second Media Word Doc File"
  When I fill in "edit-keys" with "germanic peoples"
    And I press the "Search" button
  Then I should see the link "Behat Second Media Word Doc File"
    But I should not see the link "Behat Third Media Excel File"
  When I fill in "edit-keys" with "state bird"
    And I press the "Search" button
  Then I should see the link "Behat Third Media Excel File"
    But I should not see the link "Behat Second Media Word Doc File"
  When I fill in "edit-keys" with "ecoregions"
    And I press the "Search" button
  Then I should see the link "Behat Fourth Media Powerpoint File"
    But I should not see the link "Behat Fifth Media Compressed File"
  # Search for media file name
  When I fill in "edit-keys" with "behat-the-mighty-5.pdf"
    And I press the "Search" button
  Then I should see the link "Behat First Media Pdf File"

@api
Scenario: Search returns the correct result for landing page content type
  Given "landing_page" content:
    | title               | field_description_abstract | status | body      | field_tags | published_at        | field_override_modified_date | moderation_state | changed             |
    | Behat LandingPage   | zion                       | 1      | mango     | rambutan   | 2020-07-03T16:00:05 | 2020-07-25T17:00:05          | published        | 2020-05-01T13:00:05 |
    | Another LandingPage | brycecanyon                | 1      | papaya    | lemon      | 2020-04-14T12:00:05 |                              | published        | 2020-06-14T14:00:05 |
    | Third Example       | canyonlands                | 1      | pineapple | pear       | 2020-05-12T14:00:05 |                              | published        | 2020-08-12T15:00:05 |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "behat"
    And I press the "Search" button
    And I should see the link "Behat LandingPage"
  Then I should see the text "July 25, 2020"
  When I fill in "edit-keys" with "Third Example"
    And I press the "Search" button
  Then I should see the link "Third Example"
    And I should not see the link "Behat LandingPage"
    And I should not see the link "Another LandingPage"
  When I fill in "edit-keys" with "brycecanyon"
    And I press the "Search" button
  Then I should see the link "Another LandingPage"
    And I should see the text "June 14, 2020"
    And I should not see the link "Behat LandingPage"
    And I should not see the link "Third Example"
  When I fill in "edit-keys" with "pineapple"
    And I press the "Search" button
  Then I should see the link "Third Example"
    And I should see the text "Aug. 12, 2020"
    And I should not see the link "Behat LandingPage"
    And I should not see the link "Another LandingPage"
  When I fill in "edit-keys" with "lemon"
    And I press the "Search" button
  Then I should see the link "Another LandingPage"
    And I should not see the link "Behat LandingPage"
    And I should not see the link "Third Example"

@api
Scenario: Search returns the correct result for basic page content type
  Given "page" content:
    | title                | body                   | status | published_at        | changed             |
    | Behat Basic Page     | free ice cream         | 1      | 2020-07-03T16:00:05 | 2020-05-01T13:00:05 |
    | Second Basic Page 2D | Not the body of a page | 1      | 2020-05-12T14:00:05 | 2020-08-12T15:00:05 |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "basic page"
    And I press the "Search" button
  Then I should see the link "Behat Basic Page"
    And I should see the link "Second Basic Page 2D"
  When I fill in "edit-keys" with "ice cream"
    And I press the "Search" button
  Then I should see the link "Behat Basic Page"
    And I should see the text "May 1, 2020"
    And I should not see the link "Second Basic Page 2D"
  When I fill in "edit-keys" with "2D"
    And I press the "Search" button
  Then I should see the link "Second Basic Page 2D"
    And I should see the text "Aug. 12, 2020"
    And I should not see the link "Behat Basic Page"

@api
Scenario: Search successfully returns the correct result for video content type
  Given "video" content:
    | title          | field_video_type | field_video_origin | field_video                                 | status | body   | field_topic | field_transcript | field_tags | published_at        | field_override_modified_date | moderation_state | changed             |
    | Behat Video    | guest_speaker    | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc | 1      | Drama  | airforce    | mango            | rambutan   | 2020-07-03T16:00:05 | 2020-07-25T17:00:05          | published        | 2020-05-01T13:00:05 |
    | Second Blu-ray | instructional    | Wowza              |                                             | 1      | Horror | sec         | papaya           | lemon      | 2020-06-14T12:00:05 |                              | published        | 2020-09-02T14:00:05 |
    | Another DVD    | town_hall        | youtubevimeo       | https://www.youtube.com/watch?v=xf9BpXOtMcc | 1      | Comedy | sec         | pineapple        | pear       | 2020-08-12T14:00:05 |                              | published        | 2020-04-30T15:00:05 |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "second blu-ray"
    And I press the "Search" button
  Then I should see the link "Second Blu-ray"
    And I should not see the link "Behat Video"
    And I should not see the link "Another DVD"
  When I fill in "edit-keys" with "drama"
    And I press the "Search" button
  Then I should see the link "Behat Video"
    And I should see the text "July 25, 2020"
    And I should not see the link "Second Blu-ray"
    And I should not see the link "Another DVD"
  When I fill in "edit-keys" with "pineapple"
    And I press the "Search" button
  Then I should see the link "Another DVD"
    And I should see the text "Aug. 12, 2020"
    And I should not see the link "Behat Video"
    And I should not see the link "Second Blu-ray"
  When I fill in "edit-keys" with "airforce"
    And I press the "Search" button
  Then I should see the link "Behat Video"
    And I should not see the link "Second Blu-ray"
    And I should not see the link "Another DVD"
  When I fill in "edit-keys" with "lemon"
    And I press the "Search" button
  Then I should see the link "Second Blu-ray"
    And I should see the text "June 14, 2020"
    And I should not see the link "Behat Video"
    And I should not see the link "Another DVD"

@api
Scenario: Search returns the correct result for event content type
  Given I create "paragraph" of type "paragraph_session":
    | KEY | field_location | field_start_date | field_end_date | type              |
    | 100 | Durango        | +2 hour          | +1 day         | paragraph_session |
    | 101 |  Champaign     | +1 day           | +1 day +1 hour | paragraph_session |
    And I create "node" of type "event":
      | title                | field_short_title    | body                       | field_source  | status | field_topic | field_tags | field_session | published_at        | field_override_modified_date | moderation_state | changed             |
      | Behat Training Event | Home Page Title 0 K9 | This is a Drupal Event     | Minnie Mouse  | 1      | airforce    | rambutan   | 100           | 2020-07-03T16:00:05 | 2020-07-25T17:00:05          | published        | 2020-05-01T13:00:05 |
      | Test-General         | Home Page Title 1    | This is a ServiceNow Event | Eeyore	       | 1      | sec         | lemon      | 101           | 2020-05-14T12:00:05 |                              | published        | 2020-06-14T14:00:05 |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "Behat Training Event"
    And I press the "Search" button
  Then I should see the link "Behat Training Event"
    And I should see the text "July 25, 2020"
    And I should not see the link "Test-General"
    And I fill in "edit-keys" with "ServiceNow"
    And I press the "Search" button
  Then I should see the link "Test-General"
    And I should see the text "June 14, 2020"
    And I should not see the link "Behat Training Event"
    And I fill in "edit-keys" with "airforce"
    And I press the "Search" button
  Then I should see the link "Behat Training Event"
    But I should not see the link "Test-General"
    And I fill in "edit-keys" with "Eeyore"
    And I press the "Search" button
  Then I should see the link "Test-General"
    But I should not see the link "Behat Training Event"
    And I fill in "edit-keys" with "rambutan"
    And I press the "Search" button
  Then I should see the link "Behat Training Event"
    But I should not see the link "Test-General"
    And I fill in "edit-keys" with "champaign"
    And I press the "Search" button
  Then I should see the link "Test-General"
    But I should not see the link "Behat Training Event"
  When I fill in "edit-keys" with "k9"
    And I press the "Search" button
  Then I should see the link "Behat Training Event"
    But I should not see the link "Test-General"

@api
Scenario Outline: Search returns the correct result for SECR content type
# Due to a 3 character minimum limitation, series search will not work as value assigned is only up to 2 digits
  Given "secr" content:
    | title         | field_secr_number | field_publish_date | field_series | status | body                        | field_source | field_topic | field_tags | published_at        | field_override_modified_date | moderation_state | changed             |
    | Behat SECR    | R1-2              | now                | 12           | 1      | This is a simple SECR       | Minnie Mouse | sec         | rambutan   | 2020-07-03T16:00:05 | 2020-07-25T17:00:05          | published        | 2020-05-01T13:00:05 |
    | Another Thing | R1-3              | -5 day             | 11           | 1      | This is a complex SECR      | Eeyore       | sec         | lemon      | 2020-05-14T12:00:05 |                              | published        | 2020-06-14T14:00:05 |
    | More Things   | R1-4              | -2 day             | 30           | 1      | This is a supplemental SECR | Pluto        | airforce    | pear       | 2020-06-12T14:00:05 |                              | published        | 2020-08-12T15:00:05 |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "<search>"
    And I press the "Search" button
  Then I should see the link "<result1>"
    And I should see the text "<date>"
    And I should not see the link "<result2>"
    And I should not see the link "<result3>"

    Examples:
      | search              | result1              | result2              | result3              | date          |
      | behat secr          | R1-2 - Behat SECR    | R1-3 - Another Thing | R1-4 - More Things   | July 25, 2020 |
      | r1-3                | R1-3 - Another Thing | R1-2 - Behat SECR    | R1-4 - More Things   | June 14, 2020 |
      # | management controls | R1-4 - More Things   | R1-2 - Behat SECR    | R1-3 - Another Thing |               |
      | complex             | R1-3 - Another Thing | R1-2 - Behat SECR    | R1-4 - More Things   |               |
      | minnie mouse        | R1-2 - Behat SECR    | R1-3 - Another Thing | R1-4 - More Things   |               |
      | airforce            | R1-4 - More Things   | R1-2 - Behat SECR    | R1-3 - Another Thing | Aug. 12, 2020 |
      | lemon               | R1-3 - Another Thing | R1-2 - Behat SECR    | R1-4 - More Things   |               |

@api
Scenario Outline: Search returns the correct result for OP content type
# Due to a 3 character minimum limitation, series search will not work as value assigned is only up to 2 digits
  Given "operating_procedure" content:
    | title                           | field_release_number | field_series | status | body                  | field_source | field_topic | field_tags | published_at        | field_override_modified_date | moderation_state | changed             |
    | Jira Operating Procedures       | OP_01752             | 3            | 1      | This is a simple OP   | Minnie Mouse | sec         | rambutan   | 2020-07-03T16:00:05 | 2020-07-25T17:00:05          | published        | 2020-05-01T13:00:05 |
    | Confluence Operating Procedures | OP_05689             | 11           | 1      | This is a complex OP  | Eeyore       | sec         | lemon      | 2020-05-14T12:00:05 |                              | published        | 2020-06-14T14:00:05 |
    | ServiceNow Operating Procedures | OP_98956             | 28           | 1      | This is a standard OP | Pluto        | airforce    | pear       | 2020-06-12T14:00:05 |                              | published        | 2020-08-12T15:00:05 |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "<search>"
    And I press the "Search" button
  Then I should see the link "<result1>"
    And I should see the text "<date>"
    And I should not see the link "<result2>"
    And I should not see the link "<result3>"

    Examples:
      | search        | result1                                    | result2                                    | result3                                    | date          |
      | servicenow    | OP_98956 - ServiceNow Operating Procedures | OP_01752 - Jira Operating Procedures       | OP_05689 - Confluence Operating Procedures | Aug. 12, 2020 |
      | op_01752      | OP_01752 - Jira Operating Procedures       | OP_05689 - Confluence Operating Procedures | OP_98956 - ServiceNow Operating Procedures | July 25, 2020 |
      # | real property | OP_05689 - Confluence Operating Procedures | OP_01752 - Jira Operating Procedures       | OP_98956 - ServiceNow Operating Procedures |               |
      | simple        | OP_01752 - Jira Operating Procedures       | OP_05689 - Confluence Operating Procedures | OP_98956 - ServiceNow Operating Procedures |               |
      | airforce      | OP_98956 - ServiceNow Operating Procedures | OP_01752 - Jira Operating Procedures       | OP_05689 - Confluence Operating Procedures |               |
      | eeyore        | OP_05689 - Confluence Operating Procedures | OP_01752 - Jira Operating Procedures       | OP_98956 - ServiceNow Operating Procedures | June 14, 2020 |
      | pear          | OP_98956 - ServiceNow Operating Procedures | OP_01752 - Jira Operating Procedures       | OP_05689 - Confluence Operating Procedures |               |

@api
Scenario: Search returns the correct result for library item content type
  Given "library_item" content:
     | title                | field_vendor       | field_format       | body                     | field_topic | status | published_at        | field_override_modified_date | moderation_state | changed             |
     | FOCUS CHX            | Chicago Stock Exch | Oracle; Unix/Linux | Broker-dealer financials | airforce    | 1      | 2020-07-03T16:00:05 | 2020-07-25T17:00:05          | published        | 2020-05-01T13:00:05 |
     | Historical TotalView | NASDAQ OMX         | Web-based          | Intraday Trades & Quotes | sec         | 1      | 2020-05-14T12:00:05 |                              | published        | 2020-06-14T14:00:05 |
     | Interest Rates       | Federal Reserve    | WRDS               | Interest Rates           | sec         | 1      | 2020-06-12T14:00:05 |                              | published        | 2020-08-12T15:00:05 |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "focus chx"
    And I press the "Search" button
  Then I should see the link "FOCUS CHX"
    And I should see the text "July 25, 2020"
    And I should not see the link "Historical TotalView"
    And I should not see the link "Interest Rates"
  When I fill in "edit-keys" with "intraday trade"
    And I press the "Search" button
  Then I should see the link "Historical TotalView"
    And I should see the text "June 14, 2020"
    And I should not see the link "Interest Rates"
    And I should not see the link "FOCUS CHX"
  When I fill in "edit-keys" with "federal reserve"
    And I press the "Search" button
  Then I should see the link "Interest Rates"
    And I should see the text "Aug. 12, 2020"
    And I should not see the link "FOCUS CHX"
    And I should not see the link "Historical TotalView"
  When I fill in "edit-keys" with "airforce"
    And I press the "Search" button
  Then I should see the link "FOCUS CHX"
    But I should not see the link "Historical TotalView"
    And I should not see the link "Interest Rates"

@api
Scenario Outline: Search returns the correct result for form content type
  Given "form" content:
    | body                    | title                     | field_form_number | field_form_topic | status | field_source | field_topic | field_tags | published_at        | field_override_modified_date | moderation_state | changed             |
    | apples oranges pears    | Fruits Purchase Form      | 1111              | Altruists        | 1      | Minnie Mouse | sec         | durian     | 2020-07-03T16:00:05 | 2020-07-25T17:00:05          | published        | 2020-05-01T13:00:05 |
    | cucumbers kale tomatoes | Vegetables Purchase Form  | 2222              | Boondoggle       | 1      | Eeyore       | airforce    | lemon      | 2020-05-14T12:00:05 |                              | published        | 2020-06-14T14:00:05 |
    | coke pepsi sprite       | Soft Drinks Purchase Form | 3333k             | Man of War       | 1      | Pluto        | sec         | pear       | 2020-06-12T14:00:05 |                              | published        | 2020-08-12T15:00:05 |
    And I run drupal cron
    And I run drush "cr"
  When I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
    And I fill in "edit-keys" with "<search>"
    And I press the "Search" button
  Then I should see the link "<result1>"
    And I should see the text "<date>"
    But I should not see the link "<result2>"
    And I should not see the link "<result3>"

    Examples:
      | search    | result1                   | result2                  | result3                   | date          |
      | kale      | Vegetables Purchase Form  | Fruits Purchase Form     | Soft Drinks Purchase Form | June 14, 2020 |
      | fruits    | Fruits Purchase Form      | Vegetables Purchase Form | Soft Drinks Purchase Form | July 25, 2020 |
      | 3333k     | Soft Drinks Purchase Form | Fruits Purchase Form     | Vegetables Purchase Form  | Aug. 12, 2020 |
      | altruists | Fruits Purchase Form      | Vegetables Purchase Form | Soft Drinks Purchase Form |               |
      | pluto     | Soft Drinks Purchase Form | Fruits Purchase Form     | Vegetables Purchase Form  |               |
      | airforce  | Vegetables Purchase Form  | Fruits Purchase Form     | Soft Drinks Purchase Form |               |
      | durian    | Fruits Purchase Form      | Vegetables Purchase Form | Soft Drinks Purchase Form |               |

@api
Scenario: Search returns no result for unpublished content
  Given I am logged in as a user with the "Authenticated user" role
    And "sec_article" content:
      | title   | body   | status |
      | Atticus | Body 1 | 0      |
    And I run drupal cron
  When I am on the homepage
    And I fill in "edit-keys" with "Atticus"
    And I press the "Search" button
  Then I should not see the link "Atticus"
    And I should not see the text "Body 1"
    And I should see the text "Sorry, no results found. Try entering fewer or broader query terms."

@api
Scenario: Search returns no result for non existent content
  Given I am logged in as a user with the "Authenticated user" role
    And I am on the homepage
  When I fill in "edit-keys" with "noresult"
    And I press the "Search" button
  Then I should see the text "Sorry, no results found. Try entering fewer or broader query terms."

@api
Scenario: Deleted content is removed from the search
  Given I am logged in as a user with the "administrator" role
    And "announcement" content:
      | title          | body   | publish_at | status |
      | Free Ice Cream | Test 1 | now        | 1      |
  When I visit "/admin/content"
    And I click "Edit" in the "Free Ice Cream" row
    And I click "edit-delete"
    And I press the "Delete" button
    And I am on the homepage
    And I fill in "edit-keys" with "Free Ice Cream"
    And I press the "edit-submit" button
  Then I should not see the link "Free Ice Cream"

@api
Scenario: Search returns no result for link content type
  Given I am logged in as a user with the "Authenticated user" role
    And "link" content:
      | title             |  field_url                                    | publish_at           | status |
      | BEHAT File Test 1 | BEHAT Test Link Title - http://www.google.com |  2017-08-11 12:00:00 | 1      |
    And I run drupal cron
  When I am on the homepage
    And I fill in "edit-keys" with "BEHAT File Test 1"
    And I press the "Search" button
  Then I should not see the link "BEHAT File Test 1"

@api
Scenario: Search returns no result for image content type
  Given I am logged in as a user with the "Authenticated user" role
    And "image" content:
      | title            | field_alt_text             | field_image_upload   | status |
      | BEHAT Image Test | This is a picure of a bird | image;behat-bird.gif | 1      |
    And I run drupal cron
  When I am on the homepage
    And I fill in "edit-keys" with "BEHAT Image Test"
    And I press the "Search" button
  Then I should not see the link "BEHAT Image Test"

@api
Scenario: Search returns no result for site alert content type
  Given I am logged in as a user with the "Authenticated user" role
    And "sec_alert" content:
      | title     | status |
      | sec alert | 1      |
    And I run drupal cron
  When I am on the homepage
    And I fill in "edit-keys" with "sec alert"
    And I press the "Search" button
  Then I should not see the link "sec alert"

@api @javascript
Scenario: Search page displays the number of items found for a search result
  Given I am logged in as a user with the "Content Approver" role
    And I visit "/node/add/sec_article"
    And I fill in the following:
      | Title | Behat_Exchange Article Search |
    And I type "Test Source" in the "Source" WYSIWYG editor
    And I type "Test Body" in the "Body" WYSIWYG editor
    And I scroll to the top
    And I click "Exchange Details"
    And I select "behat" from "Topic"
    And I select "elite" from "Top Level Group"
    And I scroll to the bottom
    And I publish it
  When I am logged in as a user with the "Authenticated user" role
    And I am on "/search"
    And I fill in "edit-search-api-fulltext" with "Behat_Exchange"
    And I press the "edit-submit-the-exchange-search" button
  Then I should see the link "Behat_Exchange Article Search"
    And I should see the text "1 to 1 of 1 items"

@api
Scenario: Search page displays the default pagination
  Given I am logged in as a user with the "Authenticated user" role
    And "sec_article" content:
      | title          | body   | publish_at | status | Published_Date      |
      | SEC Article 1  | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
      | SEC Article 2  | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
      | SEC Article 3  | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
      | SEC Article 4  | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
      | SEC Article 5  | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
      | SEC Article 6  | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
      | SEC Article 7  | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
      | SEC Article 8  | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
      | SEC Article 9  | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
      | SEC Article 10 | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
      | SEC Article 11 | Body 1 | now        | 1      | 2017-08-11 12:00:00 |
    And I run drupal cron
  When I am on the homepage
    And I wait 5 seconds
    And I fill in "edit-keys" with "SEC Article"
    And I press the "Search" button
  Then I should see the link "Next"
    And I should see the link "Last"

@api @javascript
Scenario: Search page selection of the number of items
  Given "sec_article" content:
    | title                   | body     | publish_at | status | Published_Date      |
    | theExchange Article 1   | Body 1   | now        | 1      | 2017-08-11 12:00:00 |
    | theExchange Article 2   | Body 2   | now        | 1      | 2017-08-12 12:00:00 |
    | theExchange Article 3   | Body 3   | now        | 1      | 2017-08-13 12:00:00 |
    | theExchange Article 4   | Body 4   | now        | 1      | 2017-08-14 12:00:00 |
    | theExchange Article 5   | Body 5   | now        | 1      | 2017-08-15 12:00:00 |
    | theExchange Article 6   | Body 6   | now        | 1      | 2017-08-16 12:00:00 |
    | theExchange Article 7   | Body 7   | now        | 1      | 2017-08-17 12:00:00 |
    | theExchange Article 8   | Body 8   | now        | 1      | 2017-08-18 12:00:00 |
    | theExchange Article 9   | Body 9   | now        | 1      | 2017-08-19 12:00:00 |
    | theExchange Article 10  | Body 10  | now        | 1      | 2017-08-20 12:00:00 |
    | theExchange Article 11  | Body 11  | now        | 1      | 2017-08-21 12:00:00 |
    | theExchange Article 12  | Body 12  | now        | 1      | 2017-08-22 12:00:00 |
    | theExchange Article 13  | Body 13  | now        | 1      | 2017-08-23 12:00:00 |
    | theExchange Article 14  | Body 14  | now        | 1      | 2017-08-24 12:00:00 |
    | theExchange Article 15  | Body 15  | now        | 1      | 2017-08-25 12:00:00 |
    | theExchange Article 16  | Body 16  | now        | 1      | 2017-08-26 12:00:00 |
    | theExchange Article 17  | Body 17  | now        | 1      | 2017-08-27 12:00:00 |
    | theExchange Article 18  | Body 18  | now        | 1      | 2017-08-28 12:00:00 |
    | theExchange Article 19  | Body 19  | now        | 1      | 2017-08-29 12:00:00 |
    | theExchange Article 20  | Body 20  | now        | 1      | 2017-08-30 12:00:00 |
    | theExchange Article 21  | Body 21  | now        | 1      | 2017-08-31 12:00:00 |
    | theExchange Article 22  | Body 22  | now        | 1      | 2017-08-32 12:00:00 |
    | theExchange Article 23  | Body 23  | now        | 1      | 2017-08-01 12:00:00 |
    | theExchange Article 24  | Body 24  | now        | 1      | 2017-08-04 12:00:00 |
    | theExchange Article 25  | Body 25  | now        | 1      | 2017-08-05 12:00:00 |
    | theExchange Article 26  | Body 26  | now        | 1      | 2017-08-06 12:00:00 |
    | theExchange Article 27  | Body 27  | now        | 1      | 2017-08-07 12:00:00 |
    | theExchange Article 28  | Body 28  | now        | 1      | 2017-08-08 12:00:00 |
    | theExchange Article 29  | Body 29  | now        | 1      | 2017-08-09 12:00:00 |
    | theExchange Article 30  | Body 30  | now        | 1      | 2017-08-10 12:00:00 |
    | theExchange Article 31  | Body 31  | now        | 1      | 2017-09-01 12:00:00 |
    | theExchange Article 32  | Body 32  | now        | 1      | 2017-09-02 12:00:00 |
    | theExchange Article 33  | Body 33  | now        | 1      | 2017-09-03 12:00:00 |
    | theExchange Article 34  | Body 34  | now        | 1      | 2017-09-04 12:00:00 |
    | theExchange Article 35  | Body 35  | now        | 1      | 2017-09-05 12:00:00 |
    | theExchange Article 36  | Body 36  | now        | 1      | 2017-09-06 12:00:00 |
    | theExchange Article 37  | Body 37  | now        | 1      | 2017-09-07 12:00:00 |
    | theExchange Article 38  | Body 38  | now        | 1      | 2017-09-08 12:00:00 |
    | theExchange Article 39  | Body 39  | now        | 1      | 2017-09-09 12:00:00 |
    | theExchange Article 40  | Body 40  | now        | 1      | 2017-09-10 12:00:00 |
    | theExchange Article 41  | Body 41  | now        | 1      | 2017-09-11 12:00:00 |
    | theExchange Article 42  | Body 42  | now        | 1      | 2017-09-12 12:00:00 |
    | theExchange Article 43  | Body 43  | now        | 1      | 2017-09-13 12:00:00 |
    | theExchange Article 44  | Body 44  | now        | 1      | 2017-09-14 12:00:00 |
    | theExchange Article 45  | Body 45  | now        | 1      | 2017-09-15 12:00:00 |
    | theExchange Article 46  | Body 46  | now        | 1      | 2017-09-16 12:00:00 |
    | theExchange Article 47  | Body 47  | now        | 1      | 2017-09-17 12:00:00 |
    | theExchange Article 48  | Body 48  | now        | 1      | 2017-09-18 12:00:00 |
    | theExchange Article 49  | Body 49  | now        | 1      | 2017-09-19 12:00:00 |
    | theExchange Article 50  | Body 50  | now        | 1      | 2017-09-20 12:00:00 |
    | theExchange Article 51  | Body 51  | now        | 1      | 2017-09-21 12:00:00 |
    | theExchange Article 52  | Body 52  | now        | 1      | 2017-09-22 12:00:00 |
    | theExchange Article 53  | Body 53  | now        | 1      | 2017-09-23 12:00:00 |
    | theExchange Article 54  | Body 54  | now        | 1      | 2017-09-24 12:00:00 |
    | theExchange Article 55  | Body 55  | now        | 1      | 2017-09-25 12:00:00 |
    | theExchange Article 56  | Body 56  | now        | 1      | 2017-09-26 12:00:00 |
    | theExchange Article 57  | Body 57  | now        | 1      | 2017-09-27 12:00:00 |
    | theExchange Article 58  | Body 58  | now        | 1      | 2017-09-28 12:00:00 |
    | theExchange Article 59  | Body 59  | now        | 1      | 2017-09-29 12:00:00 |
    | theExchange Article 60  | Body 60  | now        | 1      | 2017-09-30 12:00:00 |
    | theExchange Article 61  | Body 61  | now        | 1      | 2017-10-01 12:00:00 |
    | theExchange Article 62  | Body 62  | now        | 1      | 2017-10-02 12:00:00 |
    | theExchange Article 63  | Body 63  | now        | 1      | 2017-10-23 12:00:00 |
    | theExchange Article 64  | Body 64  | now        | 1      | 2017-10-24 12:00:00 |
    | theExchange Article 65  | Body 65  | now        | 1      | 2017-10-25 12:00:00 |
    | theExchange Article 66  | Body 66  | now        | 1      | 2018-08-26 12:00:00 |
    | theExchange Article 67  | Body 67  | now        | 1      | 2018-08-27 12:00:00 |
    | theExchange Article 68  | Body 68  | now        | 1      | 2018-08-28 12:00:00 |
    | theExchange Article 69  | Body 69  | now        | 1      | 2018-08-29 12:00:00 |
    | theExchange Article 70  | Body 70  | now        | 1      | 2018-08-30 12:00:00 |
    | theExchange Article 71  | Body 71  | now        | 1      | 2018-08-31 12:00:00 |
    | theExchange Article 72  | Body 72  | now        | 1      | 2018-08-32 12:00:00 |
    | theExchange Article 73  | Body 73  | now        | 1      | 2018-08-01 12:00:00 |
    | theExchange Article 74  | Body 74  | now        | 1      | 2018-08-04 12:00:00 |
    | theExchange Article 75  | Body 75  | now        | 1      | 2018-08-05 12:00:00 |
    | theExchange Article 76  | Body 76  | now        | 1      | 2018-08-06 12:00:00 |
    | theExchange Article 77  | Body 77  | now        | 1      | 2018-08-07 12:00:00 |
    | theExchange Article 78  | Body 78  | now        | 1      | 2018-08-08 12:00:00 |
    | theExchange Article 79  | Body 79  | now        | 1      | 2018-08-09 12:00:00 |
    | theExchange Article 80  | Body 80  | now        | 1      | 2018-08-10 12:00:00 |
    | theExchange Article 81  | Body 81  | now        | 1      | 2018-09-01 12:00:00 |
    | theExchange Article 82  | Body 82  | now        | 1      | 2018-09-02 12:00:00 |
    | theExchange Article 83  | Body 83  | now        | 1      | 2018-09-03 12:00:00 |
    | theExchange Article 84  | Body 84  | now        | 1      | 2018-09-04 12:00:00 |
    | theExchange Article 85  | Body 85  | now        | 1      | 2018-09-05 12:00:00 |
    | theExchange Article 86  | Body 86  | now        | 1      | 2018-09-06 12:00:00 |
    | theExchange Article 87  | Body 87  | now        | 1      | 2018-09-07 12:00:00 |
    | theExchange Article 88  | Body 88  | now        | 1      | 2018-09-08 12:00:00 |
    | theExchange Article 89  | Body 89  | now        | 1      | 2018-09-09 12:00:00 |
    | theExchange Article 90  | Body 90  | now        | 1      | 2018-09-10 12:00:00 |
    | theExchange Article 91  | Body 91  | now        | 1      | 2018-09-11 12:00:00 |
    | theExchange Article 92  | Body 92  | now        | 1      | 2018-09-12 12:00:00 |
    | theExchange Article 93  | Body 93  | now        | 1      | 2018-09-13 12:00:00 |
    | theExchange Article 94  | Body 94  | now        | 1      | 2018-09-14 12:00:00 |
    | theExchange Article 95  | Body 95  | now        | 1      | 2018-09-15 12:00:00 |
    | theExchange Article 96  | Body 96  | now        | 1      | 2018-09-16 12:00:00 |
    | theExchange Article 97  | Body 97  | now        | 1      | 2018-09-17 12:00:00 |
    | theExchange Article 98  | Body 98  | now        | 1      | 2018-09-18 12:00:00 |
    | theExchange Article 99  | Body 99  | now        | 1      | 2018-09-19 12:00:00 |
    | theExchange Article 100 | Body 100 | now        | 1      | 2018-09-20 12:00:00 |
    | theExchange Article 101 | Body 101 | now        | 1      | 2018-09-21 12:00:00 |
    | theExchange Article 102 | Body 102 | now        | 1      | 2018-09-22 12:00:00 |
    And I run drupal cron
    And I am logged in as a user with the "Authenticated user" role
    And I am on "/search"
    And I fill in "edit-search-api-fulltext" with "theExchange Article"
    And I press the "edit-submit-the-exchange-search" button
    And I select "5" from "Show items per page"
  Then I should see the text "1 to 5 of"
    And I click "Next" in the "paging" region
    And I wait for AJAX to finish
    And I should see the text "6 to 10 of"
    And I click "First" in the "paging" region
    And I wait 2 seconds
    And I select "10" from "Show items per page"
    And I wait for AJAX to finish
    And I should see the text "1 to 10 of"
    And I click "Next" in the "paging" region
    And I wait for AJAX to finish
    And I should see the text "11 to 20 of"
    And I click "First" in the "paging" region
    And I wait 2 seconds
    And I select "25" from "Show items per page"
    And I wait for AJAX to finish
    And I should see the text "1 to 25 of"
    And I click "Next" in the "paging" region
    And I wait for AJAX to finish
    And I should see the text "26 to 50 of"
    And I click "First" in the "paging" region
    And I wait 2 seconds
    And I select "50" from "Show items per page"
    And I wait for AJAX to finish
    And I scroll to the bottom
    And I should see the text "1 to 50 of"
    And I click "Next" in the "paging" region
    And I wait for AJAX to finish
    And I scroll to the bottom
    And I should see the text "51 to 100"

@api @javascript
Scenario: Search Relevance
  Given "sec_article" content:
    | title     | body   | field_source | field_topic   | field_top_level_group | status | Published_Date      |
    | Nuggets11 | Body 2 | source2      | About the SEC | News                  | 1      | 2018-08-12 12:00:00 |
    | Nuggets22 | Body 2 | source2      | About the SEC | News                  | 1      | 2018-08-12 12:00:00 |
    And I run drupal cron
    And I am logged in as a user with the "content_approver" role
  When I am on "/admin/content"
    And I click "Edit" in the "Nuggets22" row
    And I click secondary option "Override Modified Date"
    And I fill in "field_override_modified_date[0][value][date]" with "04/10/2019"
    And I fill in "field_override_modified_date[0][value][time]" with "12:30:30PM"
    And I publish it
  When I am logged in as a user with the "Authenticated user" role
    And I am on "/search"
    And I fill in "edit-search-api-fulltext" with "Nuggets"
    And I press the "edit-submit-the-exchange-search" button
    And I select "Newest" from "sort_bef_combine"
    And I click on the element with css selector "form.views-exposed-form input.form-submit"
  Then I should see the link "Nuggets11" before I see the link "Nuggets22" in the "search_results" region
    And I should not see the text "2038"
    And I select "Oldest" from "sort_bef_combine"
    And I click on the element with css selector "form.views-exposed-form input.form-submit"
  Then I should see the link "Nuggets22" before I see the link "Nuggets11" in the "search_results" region

@api @javascript
Scenario: User Can Filter Search Results By Microsite
  Given "sec_article" content:
    | body             | title                       | field_source | field_topic | field_top_level_group | field_site_section | status |Published_Date      | changed             |
    | This is the body | Microsite BEHAT Article     | Source       | sec         | anything              | corpfin1           | 1      |2018-08-12 12:00:00 | 2019-08-12 12:00:00 |
    | This is the body | Microsite New BEHAT Article | Source       | sec         | anything              | corpfin1           | 1      |2018-08-12 12:00:00 | 2019-04-10 12:00:00 |
    And "sec_article" content:
      | title                    | body   | field_source | field_topic   | field_top_level_group | status | Published_Date      |
      | Exchange BEHAT Article11 | Body 2 | source2      | About the SEC | News                  | 1      | 2018-08-12 12:00:00 |
      | Exchange BEHAT Article24 | Body 2 | source2      | About the SEC | News                  | 1      | 2018-08-12 12:00:00 |
    And I run drupal cron
  When I am logged in as a user with the "Authenticated user" role
    And I am on "/search"
    And I fill in "edit-search-api-fulltext" with "BEHAT"
    And I press the "edit-submit-the-exchange-search" button
  Then I should see the link "Microsite BEHAT Article"
    And I should see the link "Microsite New BEHAT Article"
    And I should see the link "Exchange BEHAT Article11"
    And I should see the link "Exchange BEHAT Article24"
    # I commented out the below steps becasue Search View Dropdown has been removed. Please see the ticket DI-5631 for more detail
  #   And I select "The Exchange" from "field_site_section"
  # When I click on the element with css selector "#edit-submit-the-exchange-search"
  # Then I should not see the link "Microsite BEHAT Article"
  #   And I should not see the link "Microsite New BEHAT Article"
  #   And I should see the link "Exchange BEHAT Article11"
  #   And I should see the link "Exchange BEHAT Article24"
  # When I select "corpfin1" from "field_site_section"
  #   And I click on the element with css selector "#edit-submit-the-exchange-search"
  # Then I should see the link "Microsite BEHAT Article"
  #   And I should see the link "Microsite New BEHAT Article"
  #   And I should not see the link "Exchange BEHAT Article11"
  #   And I should not see the link "Exchange BEHAT Article24"
  When I select "Newest" from "sort_bef_combine"
  Then I should see the link "Microsite BEHAT Article" before I see the link "Microsite New BEHAT Article" in the "search_results" region
  When I click "Microsite BEHAT Article"
    And I wait 1 seconds
  Then I should see the heading "Microsite BEHAT Article"
    And I should see the text "corpfin1"

  @api @javascript
  Scenario Outline: Verification of Removed Search View Dropdown for Sites
    Given I am logged in as a user with the "<role>" role
    When I am on "/search"
    Then I should not see an "edit-field-site-section" element
      And I should not see "- All Sites -"
      And I should not see "The Exchange"
      And I should not see "Division of Corporation Finance"
    When I fill in "CorpFin" for "edit-search-api-fulltext"
      And I click on the element with css selector "#edit-submit-the-exchange-search"
    Then I should not see the link "CorpFin Homepage"

    Examples:
      | role               |
      | Authenticated user |
      | administrator      |
      | sitebuilder        |
      | content_approver   |
      | content_creator    |

  @api
  Scenario Outline: Verification of Unpublished Microsite Corpfin Homepage
    Given I am logged in as a user with the "<role>" role
    When I am on "/admin/content"
      And I select "Division of Corporation Finance" from "field_site_section_target_id"
    Then I should see "Division of Corporation Finance"
    When I press the "Filter" button
    Then I should see "Unpublished" in the "CorpFin Homepage" row
    When I select "corpfin1" from "field_site_section_target_id"
    Then I should see "corpfin1"
      And I press the "Reset" button
    When I fill in "CorpFin Homepage" for "edit-title"
      And I press the "Filter" button
    Then I should see "Unpublished" in the "CorpFin Homepage" row

    Examples:
      | role             |
      | administrator    |
      | sitebuilder      |
      | content_approver |
      | content_creator  |
