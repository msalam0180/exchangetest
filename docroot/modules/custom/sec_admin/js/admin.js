;(function($, Drupal) {
  function addVideoLinkRequired() {
    /* Enable asterisk for the condition field in admin backend (Add Form) */
    $(".node-video-form .form-item-field-video-0-value label:first").addClass("form-required")
    $(".node-video-form .form-item-field-media-id-0-value label:first").addClass("form-required")
    $(".node-video-form .form-item-field-limelight-thumbnail-0 label:first").addClass(
      "form-required"
    )

    /* Enable asterisk for the condition field in admin backend (Edit Form) */
    $(".node-video-edit-form .form-item-field-video-0-value label:first").addClass("form-required")
    $(".node-video-edit-form .form-item-field-media-id-0-value label:first").addClass(
      "form-required"
    )
    $(".node-video-edit-form .form-item-field-limelight-thumbnail-0 label:first").addClass(
      "form-required"
    )
  }

  // Add asterisk on the change event
  $('select[name="field_video_origin"]').change(function() {
    addVideoLinkRequired()
  })

  // Add asterisk on initial page load
  addVideoLinkRequired()

  /* Disable teaser field's text format select*/
  if ($(".node-announcement-form.node-form").length > 0) {
    $("#edit-field-teaser-0-format--2").prop("disabled", "disabled")
  }

  /* Hide publishing checkbox is workflow buttons are available
     but check the box */
  if ($(".moderation-state-published ").length > 0) {
    $(".form-item-status-value")
      .addClass("visually-hidden")
      .attr("aria-hidden", "true")
  }
  /*DI-1574 */
  $(".moderation-state-published").click(function(e) {
    if (
      $(this)
        .find(".form-submit")
        .val() === "Save and Publish"
    ) {
      $("#edit-status-value").prop("checked", true)
    }
  })

  //Adds a tabindex to iframe in modal popups created by entity browser so it is tab-able
  Drupal.behaviors.entityBrowserModalIframeAlter = {
    attach: function(context) {
      $(window).on({
        "dialog:aftercreate": function(event, dialog, $element, settings) {
          $(".entity-browser-modal-iframe").attr("tabindex", "0")
        },
      })
    },
  }

  // Adds ToolTips next to the label for tall fields so a user can see it quickly OSSS-8845
  Drupal.behaviors.helptext = {
    attach: function(context) {
      // Textarea (WYSIWYG) widgets
      $(
        ".field--widget-text-textarea-with-summary .description, .field--widget-text-textarea .description"
      ).each(function(index) {
        // Find Field Wrppaing element
        var $field = $(this).closest(".form-wrapper")
        //Check if it already has a help text popup
        if (!$field.find(".helper-popup").length) {
          //Add help popup
          var $label = $field.find("label")
          $label.addClass("has-helper-popup")
          var $question = $label
            .first()
            .after(
              "<span class='helper-popup' title='" +
                $(this).text() +
                "' tabindex='0'>" +
                $label.first().text() +
                " Help Info</span>"
            )
        }
      })

      // Textarea widgets
      $(".form-type-textarea .description").each(function(index) {
        // Find Field Wrppaing element
        var $field = $(this).closest(".form-item")
        //Check if it already has a help text popup
        if (!$field.find(".helper-popup").length) {
          //Add help popup
          var $label = $field.find("label")
          $label.addClass("has-helper-popup")
          var $question = $label
            .first()
            .after(
              "<span class='helper-popup' title='" +
                $(this).text() +
                "' tabindex='0'>" +
                $label.first().text() +
                " Help Info</span>"
            )
        }
      })

      //drag and drop tables for multiple items
      $(".field-multiple-table")
        .next(".description")
        .each(function(index) {
          var $field = $(this).closest(".form-wrapper")
          if (!$field.find(".helper-popup").length) {
            var $label = $field.find(".field-label .label")
            $label.addClass("has-helper-popup")
            var $question = $label
              .first()
              .after(
                "<span class='helper-popup' title='" +
                  $(this).text() +
                  "' tabindex='0'>" +
                  $label.first().text() +
                  " Help Info</span>"
              )
          }
        })
    },
  }

  //Adds tab focus handling for ajax inline-entity forms
  Drupal.behaviors.focusInlineEntityForms = {
    attach: function (context) {
      $(".field--widget-inline-entity-form-complex .button.js-form-submit").on("mousedown",function() {
        var fieldwrapper = $(this).closest(".field--widget-inline-entity-form-complex");
        $(document).ajaxComplete(function() {
          var firstInput = fieldwrapper.find("fieldset input.form-text, fieldset input.entity-browser-processed")[0];
          if (typeof firstInput == "undefined") {
            firstInput = fieldwrapper.find("input")[0];
          }
          firstInput.focus();
        });
      });
    }
  }
})(jQuery, Drupal)
