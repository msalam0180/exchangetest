(function ($) {
  Drupal.behaviors.secVideo = {
    attach: function (context) {
      const reqLabelClasses = 'js-form-required form-required';

      // Trigger change on page load to make sure required fields are marked.
      $('#edit-field-video-origin').trigger('change');

      // Add CSS class to style these fields to give required style, this validation happens in sec_video module file.
      $('.form-item-field-video-0-value label, .form-item-field-video-0-value .label').addClass(reqLabelClasses);
      $('.field--name-field-media-id label, .field--name-field-media-id .label').addClass(reqLabelClasses);
    }
  }
})(jQuery);
