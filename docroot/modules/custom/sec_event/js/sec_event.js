/**
 * @file Contains the javascript handling for sec_event node type.
 */
// Constants to clarify action for the event sessions
const DEFAULT_CLEAR = 1;
const DEADLINE = 2;
const GENERAL_OR_TRAINING = 3;
(function ($) {

  /**
  * Function that modifies the DOM based on what the event type the user chooses
  */

  function changeEventSession(eventType) {
    // "Clear" the session
    $('.field--name-field-start-date').hide();
    $('.field--name-field-end-date').hide();
    $('.field--name-field-location').hide();

    switch(eventType) {
      case DEADLINE:
        $('.field--name-field-end-date').find('.fieldset-legend').text('Deadline Date');
        $('.field--name-field-end-date').show();
        break;
      default:
        $('.field--name-field-end-date').find('.fieldset-legend').text('End Date');
        $('.field--name-field-start-date').show();
        $('.field--name-field-end-date').show();
        $('.field--name-field-location').show();
        break;
    }
  }

  /**
   * Attaches the JS behavior
   */
  Drupal.behaviors.secEvent = {
    attach: function (context) {
      const reqLabelClasses = 'js-form-required form-required';

      // For deadlines, populate the start date field even though it is hidden
      // This is so the events will show up on the homepage and event page views
      $('#edit-actions').find('input[type="submit"]').on('click', function() {
        if ($('#edit-field-event-type').val() == 'deadlines') {
          $('#edit-field-session-wrapper').find('.draggable').each(function() {
            const deadlineDate = $(this).find('.field--name-field-end-date').find('input.form-date').val();
            const deadlineTime = $(this).find('.field--name-field-end-date').find('input.form-time').val();

            $(this).find('.field--name-field-start-date').find('input.form-date').val(deadlineDate);
            $(this).find('.field--name-field-start-date').find('input.form-time').val(deadlineTime);
          });
        }
      });

      $('#edit-field-event-type').on('change', function() {
        // Do nothing if they didn't select a type
        if (this.value === '_none') {
          changeEventSession(DEFAULT_CLEAR);
		      $('.field--name-field-end-date label').removeClass(reqLabelClasses);
          return;
        }

        if (this.value === 'deadlines') {
          changeEventSession(DEADLINE);
		      $('.field--name-field-end-date label').addClass(reqLabelClasses);
        }
        else {
          changeEventSession(GENERAL_OR_TRAINING);
		      $('.field--name-field-end-date label').removeClass(reqLabelClasses);
        }
      });

      $(document).ready(function () {
        // trigger the change on page load to make sure required fields are marked
        $('#edit-field-event-type').trigger('change');

        // Adds CSS class to style these fields to look required, this validation happens in sec_event module file
        $('.field--name-field-start-date').find('span.fieldset-legend').addClass(reqLabelClasses);
        $('.field--name-field-location label, .field--name-field-location .label').addClass(reqLabelClasses);
		
		if ($('#edit-field-event-type').val() == 'deadlines') {
			$('.field--name-field-end-date label').addClass(reqLabelClasses);
		}
      });

      //add smart defaults when adding event sessions
      $('.field--name-field-session input.field-add-more-submit').on('mousedown', function() {
        $(document).ajaxComplete(function() {
          var sessions = $('.paragraphs-subform');
          if (sessions && sessions.length > 1) {
            var clonedSession = $(sessions[sessions.length - 2]);
            var latestSession = $(sessions[sessions.length -1]);

            var clonedStartDate = clonedSession.find(".field--name-field-start-date input").val();
            if (typeof clonedStartDate !== "undefined" && $('#edit-field-event-type').val() != 'deadlines') {
              var newStartDate = moment(clonedStartDate, "YYYY-MM-DD hh:mm:ss A").add("1","d").format("YYYY-MM-DD hh:mm:ss A");
              latestSession.find(".field--name-field-start-date input").val(newStartDate);
            }

            var clonedEndDate = clonedSession.find(".field--name-field-end-date input").val();
            if (typeof clonedEndDate !== "undefined" && clonedEndDate) {
              var newEndDate = moment(clonedEndDate, "YYYY-MM-DD hh:mm:ss A").add("1","d").format("YYYY-MM-DD hh:mm:ss A");
              latestSession.find(".field--name-field-end-date input").val(newEndDate);
            }

            var clonedLocation = clonedSession.find(".field--name-field-location textarea").val();
            if (typeof clonedLocation !== "undefined") {
              latestSession.find(".field--name-field-location textarea").val(clonedLocation);
            }

          }

        });

      });
    }
  };
})(jQuery);
