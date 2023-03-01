/**
 * @file Contains the javascript handling for insider_announcement node type.
 */
(function ($, Drupal) {
  // Attaches the JS behavior.
  Drupal.behaviors.insiderAnnouncement = {
    attach: function (context, settings) {
      $(document).ready(function () {
        var reqLabelClasses = 'js-form-required form-required';

        $('#edit-field-link-display input').change(function () {
          if ($('#edit-field-link-display input:checked').val() === 'self') {
            $('#edit-body-wrapper label, #edit-body-wrapper .label').addClass(reqLabelClasses);
          }
          else {
            $('#edit-body-wrapper label, #edit-body-wrapper .label').removeClass(reqLabelClasses);
          }
        }).change();

        $('#edit-field-announcement-type').change(function () {
          $to_field = '#edit-field-to-wrapper label, #edit-field-to-wrapper .label';
          $from_field = '#edit-field-from-wrapper label, #edit-field-from-wrapper .label';
          $date_field = '#edit-field-date-wrapper label, #edit-field-date-wrapper .label';
          if (this.value !== '_none') {
            $($to_field + ',' + $from_field + ',' + $date_field).addClass(reqLabelClasses);
          }
          else {
            $($to_field + ',' + $from_field + ',' + $date_field).removeClass(reqLabelClasses);
          }
        }).change();
      });
    }
  };
})(jQuery, Drupal);
