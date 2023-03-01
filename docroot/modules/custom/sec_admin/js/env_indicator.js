(function ($, Drupal) {
  "use strict";

  // Detach environment Indicator toolbar option
  Drupal.behaviors.environmentIndicatorToolbar = {
    detach: function (context, settings, unload) {
    }
  };

  // Added environment indicator customizations
  Drupal.behaviors.EnvIndicator = {
    attach: function (context, settings) {
      $(context).ready(function () {

        // Adjust padding top for indicator position
        var toolbarTabOuterHeight = $('#toolbar-bar').find('.toolbar-tab').outerHeight() || 0;
        var toolbarTrayHorizontalOuterHeight = $('.is-active.toolbar-tray-horizontal').outerHeight() || 0;
        $('body').css({
          'padding-top': toolbarTabOuterHeight + toolbarTrayHorizontalOuterHeight
        });

        // Adding a div wrapper for the environment indicator wrapper
        $('#environment-indicator', context).once('addEnvironmentWrapper').each(function () {
          $('#environment-indicator').wrapInner('<div class="env-indicator-text"></div>');
          $('#environment-indicator div.env-indicator-text', context).css({
            'background-color': settings.environmentIndicator.bgColor,
            'color': settings.environmentIndicator.fgColor
          });
        });

        // Position fixed for mobile view
        if ($('body').hasClass('toolbar-vertical') && !$('body').hasClass('toolbar-fixed')) {
          var env_pos = $('#environment-indicator').offset().top;
          $(window).scroll(function (e) {
            var env_indicator = $('#environment-indicator div.env-indicator-text');
            if ($(this).scrollTop() > env_pos) {
              env_indicator.css({ 'position': 'fixed', 'top': '0px' });
            } else {
              env_indicator.css({ 'position': 'sticky', 'top': 'auto' });
            }
          });
        }

      });
    }
  }

}(jQuery, Drupal));
