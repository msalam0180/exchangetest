/* eslint-disable */
/**
 * @file
 * Contains js for the tippy.js library.
 */

(function ($, Drupal, drupalSettings, once) {

  'use strict';

  Drupal.behaviors.tippy_tooltip = {

    attach: function (context, settings) {
      once('tippyTooltipBehavior', 'html', context).forEach(function () {
        $(function () {
          // Add tippy for the data attr
          tippy('[data-tippy-content]', {
            // for troubleshooting, uncomment the next two lines
            // trigger: 'click',
            // hideOnClick: false
          });

          // Replace title attribute with tippy and add data-drupal-title attribute.
          function replaceTitleAttr() {
            // DI-5977: Ckeditor 'linkit' button- change title from 'Link' to 'LinkIt'
            $('.cke_button__drupallink').each(function () {
              $(this).attr('title', 'LinkIt (Ctrl+K)');
            });
            tippy('[title]:not(iframe)', {
              content: function (reference) {
                const title = reference.getAttribute('title');
                reference.setAttribute('data-drupal-title', title);
                reference.removeAttribute('title');
                return title;
              },
              delay: 300,
            })
          }

          let flag = false;
          // Wait for CKEDITOR to fully load then call replaceTitleAttr().
          function checkForCkeditor() {
            if (flag === false) {
              // Incase CKEDITOR doesn't exists this will stop the JS after 5 seconds.
              if (typeof CKEDITOR != "undefined") {
                let editors = Object.keys(CKEDITOR.instances);
                let last_id = editors[editors.length - 1];
                CKEDITOR.instances[last_id].on('loaded', function () {
                  // Replace after last CKEDITOR has been loaded.
                  replaceTitleAttr();
                });
                flag = true;
              } else {
                // Adding this to prevent infinite wait time to 5 seconds.
                setTimeout(() => {
                  flag = true;
                }, 5000);
              }
              replaceTitleAttr();
              setTimeout(function () {
                checkForCkeditor();
              }, 1000);
            }
          }

          checkForCkeditor();
        });
      })
    }
  };

})(jQuery, Drupal, drupalSettings, once);
