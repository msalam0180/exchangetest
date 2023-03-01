Feature: Create and View Media
As a Content Creator to the Insider
I want to be able to add files
So that users can get information available in files on Insider

Background:

  Given "top_level_group" terms:
    | name     | field_abbreviation |
    | toplevel | top                |
    | sports   | spts               |
    And "topic" terms:
      | name   |
      | techno |
      | hr     |
    And "audiences" terms:
      | name    |
      | insider |
      | lawyer  |
    And "office_division" terms:
      | name    |
      | dera    |
      | corpfin |
    And "group_club" terms:
      | name    |
      | running |
      | cooking |

@api @javascript
Scenario Outline: Create And Delete Media Files
  Given I am logged in as a user with the "content_approver" role
  When I am on "/media/add/file"
    And I fill in "Name" with "<FileName>"
    And I fill in "Description/Abstract" with "This is '<FileName>'"
    And I attach the file "<FileType>" to "File Upload"
    And I wait for ajax to finish
  Then I should see the "a" element with the "href" attribute set to "/system/files/filefield_paths/<FileType>" in the "file_widget" region
  When I select "hr" from "Topic"
    And I select "sports" from "Top Level Group"
    And I press "Save"
  Then I should see the text "has been created."
    And I should see the link "<FileName>"
    # Clean up by deleting created media test data
  When I fill in "Format" for "Media name"
    And I press "Filter"
    And I click "Edit" in the "<FileName>" row
    And I should see the "a" element with the "href" attribute set to "/files/exchange/media/spts/<FileType>" in the "file_widget" region
    And I click "edit-delete"
  Then I should see the heading "Are you sure you want to delete the media item <FileName>?"
    And I should see the text "This action cannot be undone"
  When I press "edit-submit"
  Then I should see the text "The media item <FileName> has been deleted"
    And I should not see the link "<FileName>"

  Examples:
    | FileName    | FileType        |
    | CSV Format  | behat-file.csv  |
    | DOC Format  | behat-file.doc  |
    | DOCX Format | behat-file.docx |
    | PDF Format  | behat-file.pdf  |
    | PPT Format  | behat-file.ppt  |
    | PPTX Format | behat-file.pptx |
    | TXT Format  | behat-file.txt  |
    | XLS Format  | behat-file.xls  |
    | XLSX Format | behat-file.xlsx |
    | VCS Format  | behat-file.vcs  |
    | XML Format  | behat-file.xml  |
    | ICS Format  | behat-file.ics  |
    | ZIP Format  | behat-file.zip  |

@api @javascript
Scenario: Add Unsupported File Type
  Given I am logged in as a user with the "content_approver" role
  When I am on "/media/add/file"
    And I fill in "Name" with "Unsupported File"
    And I fill in "Description/Abstract" with "This test validates against unsupported file format"
    And I attach the file "behat-bird.gif" to "File Upload"
    And I wait for ajax to finish
  Then I should see the text "The selected file behat-bird.gif cannot be uploaded."
    And I should see the text "Only files with the following extensions are allowed: csv, doc, docx, ics, pdf, ppt, pptx, txt, vcs, xls, xlsx, xml, zip."

@api @javascript
Scenario: Create Media With / In Title
  Given I am logged in as a user with the "content_approver" role
  When I am on "/media/add/file"
    And I fill in "Name" with "Behat Protection w/ Prohibited Personnel Practices"
    And I fill in "Description/Abstract" with "This is a slash to dash conversion test"
    And I attach the file "behat-file.pdf" to "File Upload"
    And I wait for ajax to finish
    And I wait 5 seconds
    And I select "hr" from "Topic"
    And I select "sports" from "Top Level Group"
    And I press "Save"
    And I am on "/admin/content/media"
    And I fill in "behat" for "Media name"
    And I press "Filter"
    And I wait for AJAX to finish
  Then I should see the link "Behat Protection w/ Prohibited Personnel Practices"

@api
Scenario: Media download link should open inline
  Given I am logged in as a user with the "content_approver" role
  When I am on "/media/add/file"
    And I fill in "Name" with "Behat File Download"
    And I fill in "Description/Abstract" with "This is the description and abstract"
    And I attach the file "behat-file.pdf" to "File Upload"
    And I wait 5 seconds
    And I select "hr" from "Topic"
    And I select "sports" from "Top Level Group"
    And I press "Save"
  Then I should see the link "Behat File Download"
  When I click "Behat File Download"
  Then I should see response headers with inline content type "PDF"

@api
Scenario Outline: Accessing Media Types Based on Role
  Given I am logged in as a user with the "<role>" role
  When I am on "/media/add/"
  Then I should see the text "<chkaddmedia>"
  When I am on "/media/add/file"
  Then I should see the text "Add File"
  When I am on "<URL1>"
  Then I should see the text "<Result1>"
  When I am on "<URL2>"
  Then I should see the text "<Result2>"
  When I am on "<URL3>"
  Then I should see the text "<Result3>"
  When I am on "<URL4>"
  Then I should see the text "<Result4>"

  Examples:
    | role               | chkaddmedia    | URL1             | Result1              | URL2             | Result2              | URL3                    | Result3              | URL4             | Result4              |
    | administrator      | Add media item | /media/add/audio | Add Audio            | /media/add/image | Add Image            | /media/add/remote_video | Add Remote Video     | /media/add/video | Add Video            |
    | sitebuilder        | Add File       | /media/add/audio | Error 403: Forbidden | /media/add/image | Error 403: Forbidden | /media/add/remote_video | Error 403: Forbidden | /media/add/video | Error 403: Forbidden |
    | content_approver   | Add File       | /media/add/audio | Error 403: Forbidden | /media/add/image | Error 403: Forbidden | /media/add/remote_video | Error 403: Forbidden | /media/add/video | Error 403: Forbidden |
    | content_creator    | Add File       | /media/add/audio | Error 403: Forbidden | /media/add/image | Error 403: Forbidden | /media/add/remote_video | Error 403: Forbidden | /media/add/video | Error 403: Forbidden |
    | microsite_creator  | Add File       | /media/add/audio | Error 403: Forbidden | /media/add/image | Error 403: Forbidden | /media/add/remote_video | Error 403: Forbidden | /media/add/video | Error 403: Forbidden |
    | microsite_approver | Add File       | /media/add/audio | Error 403: Forbidden | /media/add/image | Error 403: Forbidden | /media/add/remote_video | Error 403: Forbidden | /media/add/video | Error 403: Forbidden |

@api @javascript
Scenario Outline: Media Published Status Filtering
  Given I create "media" of type "file":
    | name                             | field_media_file | field_media_description_abstract | field_media_topic | field_media_top_level_group | status |
    | This is for published scenario   | behat-file.pdf   | This is ticket DI4934            | hr                | toplevel                    | 1      |
    | This is for unpublished scenario | behat-form1.pdf  | This is ticket DI4934            | hr                | toplevel                    | 0      |
    And I am logged in as a user with the "<role>" role
  When I am on "/admin/content/media"
    And I select "- Any -" from "Published status"
    And I press the "Filter" button
  Then I should see the link "This is for unpublished scenario"
    And I should see the link "This is for published scenario"
  When I select "Unpublished" from "Published status"
    And I press the "Filter" button
  Then I should see the text "Unpublished" in the "This is for unpublished scenario" row
    And I should not see the link "This is for published scenario"
  When I select "Published" from "Published status"
    And I press the "Filter" button
  Then I should see the text "Published" in the "This is for published scenario" row
    And I should not see the link "This is for unpublished scenario"
  When I select "- Any -" from "Published status"
    And I press the "Filter" button
  Then I should see the link "This is for unpublished scenario"
    And I should see the link "This is for published scenario"

  Examples:
    | role               |
    | Content Creator    |
    | Content Approver   |
    | sitebuilder        |
    | administrator      |
    | microsite_creator  |
    | microsite_approver |

@api @javascript
Scenario Outline: Authorized Users Can Access Media List Page
  Given I am logged in as a user with the "<role>" role
  When I am on "/admin/content/media"
  Then I should see the text "Published status"
    And I should see the text "Media name"
    And I should see the text "Type"
    And I should see the text "Language"
    And I should see the button "Filter"
  When I click on the element with css selector "#edit-type"
  Then I should see "File"
    And I should not see "Audio"
    And I should not see "Image"
    And I should not see "Remote video"
    And I should not see "Video"

  Examples:
    | role               |
    | Content Creator    |
    | Content Approver   |
    | sitebuilder        |
    | administrator      |
    | microsite_creator  |
    | microsite_approver |

@api
Scenario Outline: Verify Unpublished Media File Nodes Are Not Accessible By Enduser
  Given I create "media" of type "file":
    | name         | field_media_file | field_media_description_abstract | field_media_topic | field_media_top_level_group | mid   | status |
    | My PDF file  | behat-file.pdf   | some abstract                    | hr                | toplevel                    | 99999 | 0      |
    | My CSV file  | behat-file.csv   | some abstract                    | hr                | toplevel                    | 99991 | 0      |
    | My DOC file  | behat-file.doc   | some abstract                    | hr                | toplevel                    | 99992 | 0      |
    | My DOCX file | behat-file.docx  | some abstract                    | hr                | toplevel                    | 99993 | 0      |
    | My ICS file  | behat-file.ics   | some abstract                    | hr                | toplevel                    | 99994 | 0      |
    | My PPT file  | behat-file.ppt   | some abstract                    | hr                | toplevel                    | 99995 | 0      |
    | My PPTX file | behat-file.pptx  | some abstract                    | hr                | toplevel                    | 99996 | 0      |
    | My TXT file  | behat-file.txt   | some abstract                    | hr                | toplevel                    | 99997 | 0      |
    | My VCS file  | behat-file.vcs   | some abstract                    | hr                | toplevel                    | 99998 | 0      |
    | My XLS file  | behat-file.xls   | some abstract                    | hr                | toplevel                    | 99919 | 0      |
    | My XLSX file | behat-file.xlsx  | some abstract                    | hr                | toplevel                    | 99929 | 0      |
    | My XML file  | behat-file.xml   | some abstract                    | hr                | toplevel                    | 99939 | 0      |
    | My ZIP file  | behat-file.zip   | some abstract                    | hr                | toplevel                    | 99949 | 0      |
    And I create "media" of type "remote_video":
      | field_media_oembed_video                    | mid   | status |
      | https://www.youtube.com/watch?v=21X5lGlDOfg | 99399 | 0      |
      | https://vimeo.com/213220367                 | 99499 | 0      |
    And I create "media" of type "video":
      | name        | field_media_video_file | mid   | status |
      | My MP4 file | behat-file.mp4         | 99599 | 0      |
    And I am logged in as a user with the "authenticated" role
  When I am on "<url>"
  Then the response status code should be 403

  Examples:
    | url                   |
    | /media/99999/download |
    | /media/99999          |
    | /media/99991/download |
    | /media/99992/download |
    | /media/99993/download |
    | /media/99994/download |
    | /media/99995/download |
    | /media/99996/download |
    | /media/99997/download |
    | /media/99998/download |
    | /media/99919/download |
    | /media/99929/download |
    | /media/99939/download |
    | /media/99949/download |
    | /media/99399/download |
    | /media/99499/download |
    | /media/99599/download |

@api
Scenario Outline: Verify Unpublished Media Audio Nodes Are Not Accessible By Enduser
  Given I create "media" of type "audio":
    | name        | field_media_audio_file | mid      | status |
    | My MP3 file | behat-file.mp3         | 99959919 | 0      |
    | My WAV file | behat-file.wav         | 99969929 | 0      |
    And I am logged in as a user with the "authenticated" role
  When I am on "<url>"
  Then the response status code should be 403

  Examples:
    | url                      |
    | /media/99959919/download |
    | /media/99969929/download |

@api
Scenario Outline: Verify Unpublished Media Image Nodes Are Not Accessible By Enduser
  Given I create "media" of type "image":
    | name         | files                  | mid   | status | field_alt_text |
    | My PNG file  | behat-cat.png          | 99979 | 0      | test           |
    | My GIF file  | behat-bird.gif         | 99989 | 0      | test           |
    | My JPG file  | behat-black_rabbit.jpg | 99199 | 0      | test           |
    | My JPEG file | behat-dog.jpeg         | 99299 | 0      | test           |
    And I am logged in as a user with the "authenticated" role
  When I am on "<url>"
  Then the response status code should be 403

  Examples:
    | url                   |
    | /media/99979/download |
    | /media/99989/download |
    | /media/99199/download |
    | /media/99299/download |

@api @javascript
Scenario: Delete media file from file system
  Given I create "media" of type "file":
    | name             | field_media_file      | field_media_description_abstract | field_media_topic | field_media_top_level_group | mid    | status |
    | BEHAT media file | behat-file_delete.pdf | some abstract                    | hr                | toplevel                    | 999999 | 1      |
  And I am logged in as a user with the "administrator" role
  And I delete the file "files/exchange/media/top/behat-file_delete.pdf" from the file system
  When I am on "/admin/content/media"
    And I click "Edit" in the "BEHAT media file" row
    And I press the "Remove" button
    And I wait for ajax to finish
    And I attach the file "behat-file_delete.pdf" to "File Upload"
    And I wait for ajax to finish
    And I press "Save"
    And I click "BEHAT media file" in the "BEHAT media file" row
    And I click "behat-file_delete.pdf"
  Then I should not see the text "Error 403: Forbidden"

@api @javascript
Scenario: UI Media CSV Export With Division/Office Filtering
  Given I create "media" of type "file":
    | name                             | field_media_file | field_media_description_abstract | field_media_topic | field_media_top_level_group | status | field_media_division_office | field_media_group_club |
    | This is for published scenario   | behat-file.pdf   | This is a file                   | hr                | toplevel                    | 1      | dera                        | cooking                |
    | This is for unpublished scenario | behat-form1.pdf  | This is another file             | hr                | toplevel                    | 0      | corpfin                     | running                |
    And I am logged in as a user with the "Content Creator" role
  When I am on "/admin/content/media"
    And I select "dera" from "Division/Office"
    And I press "Filter"
  Then I should see the link "This is for published scenario"
    And I should not see the link "This is for unpublished scenario"
  When I click "Download CSV"
    And I wait 2 seconds
  Then I should see the text "Export complete. Download the file here if file is not automatically downloaded."
    And I should see the link "here"

@api
Scenario: Status Code - Media CSV Export With Group/Club Filtering
  Given I create "media" of type "file":
    | name                             | field_media_file | field_media_description_abstract | field_media_topic | field_media_top_level_group | status | field_media_division_office | field_media_group_club |
    | This is for published scenario   | behat-file.pdf   | This is a file                   | hr                | toplevel                    | 1      | dera                        | cooking                |
    | This is for unpublished scenario | behat-form1.pdf  | This is another file             | hr                | toplevel                    | 0      | corpfin                     | running                |
  When I am logged in as a user with the "Content Approver" role
  When I am on "/admin/content/media"
    And I select "running" from "Group/Club"
    And I press "Filter"
  Then I should see the link "This is for unpublished scenario"
    And I should not see the link "This is for published scenario"
  When I click "Download CSV"
  Then the response status code should not be 500
    And the response status code should be 200
