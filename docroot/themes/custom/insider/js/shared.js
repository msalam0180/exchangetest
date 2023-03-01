
(function ($) {
  // add aId value on page load DI-4168
  Drupal.behaviors.insider_add_aid = {
    attach: function (context, settings) {
      $('form', context).each(function(e) {
        var formId = $(this).attr('id');
        $(this).find('input[name="aId"]').val(formId);
      });
    }
  };

	Drupal.behaviors.insider_menus = {
	  attach: function (context, settings) {
		  // Initialize main-navigation
		  $('ul#main-menu').superfish({
		    delay: 650, // delay on mouseout
		    animation: {
		      height: 'show'
		    }, // fade-in and slide-down animation
		    dropShadows: false
		  });

		  $('ul#user-menu').superfish();

		  // Initialize Quick Links
		  $('ul#quick-links').superfish({
		    delay: 650, // delay on mouseout
		    animation: {
		      height: 'show'
		    }, // fade-in and slide-down animation
		    dropShadows: false
		  });
	  }
	};

  // DI-4459 fix search issues with EDGE browser
  if(/Edge/.test(window.navigator.userAgent)){
    //disable autocomplete feature on search box
    $('#edit-search-api-fulltext').attr('autocomplete', 'off');
    $('#edit-keys').attr('autocomplete', 'off');
  }
  //DI-4606 provide help text for unsupported twitter feed in IE
  //DI-5496 remove link to Twitter feed for IE
  if (/Trident/.test(window.navigator.userAgent) || /MSIE/.test(window.navigator.userAgent)) {
    $('div.sec-on-twitter h2').after("<p>Internet Explorer is no longer supported by Twitter. Please use another browser to view SEC tweets on The Exchange homepage.</p>");
    $('div.sec-on-twitter .twitter-timeline').hide();
  }

	// DI-1755 IE11 Twitter video player fix
	if (typeof Object.assign != 'function') {
	  Object.assign = function(target) {
	    'use strict';
	    if (target == null) {
	      throw new TypeError('Cannot convert undefined or null to object');
	    }

	    target = Object(target);
	    for (var index = 1; index < arguments.length; index++) {
	      var source = arguments[index];
	      if (source != null) {
	        for (var key in source) {
	          if (Object.prototype.hasOwnProperty.call(source, key)) {
	            target[key] = source[key];
	          }
	        }
	      }
	    }
	    return target;
	  };
	}

  // Skip links accross browsers
  // on clicking skip link move focus to main content
  $('#skip-link').on('click', function (e) {
    $('#main-content').attr('tabIndex', -1).focus();
  });

  // Preload SEC Video Search Feature
  $(document).ready(function () {
    if ($('.sec-videos-view #edit-reset').length > 0) {
      $('.sec-videos-view #edit-submit-sec-videos').hide();
      $('.sec-videos-view .views-exposed-form').show();
    }
    else {
      $('.sec-videos-view .views-exposed-form').show();
      $('.sec-videos-view #edit-submit-sec-videos').show();
    }
    if ($('.spotlights-view #edit-reset').length > 0) {
      $('.spotlights-view #edit-submit-spotlights').hide();
      $('.spotlights-view .views-exposed-form').show();
    }
    else {
      $('.spotlights-view .views-exposed-form').show();
      $('.spotlights-view #edit-submit-spotlights').show();
    }
  });

  // On viewport size change, refresh the screen
  window.onresize = function (event) {

    if ($('div[id^="tabs-"]').length > 0) {
      setTabSize();
    }
    if ($('div.tabs').length > 0) {
      setTabSize();
    }
  };

  /* disable dropdown for preview pages without id (new content preview) */
  if ($("meta[name='id']").length === 0
      && $('.node-preview-form-select select').length > 0) {
    $('.node-preview-form-select select').attr('disabled', true);
  }

  /* highlight navigation for detail pages */
  if ($('.newsroom-list-page').length > 0 || $('.article-list').length > 0) {
    $("#local-nav li a[href='" + window.location.pathname + "']").addClass(
      'is-active');
  }

  if ($('body.path-node').length > 0) {
    var navPath = window.location.pathname.substring(0,
      window.location.pathname.lastIndexOf('/'));
    switch (navPath) {
      case '/news/press-release':
        navPath = '/news/pressreleases';
        break;
      case '/news/public-statement':
        navPath = '/news/statements';
        break;
    }
    $("body.node--type-news #local-nav li a[href^='" + navPath + "']")
      .addClass('is-active');
  }

  $('.sf-menu li a').focusin(function () {
    $(this).parent().addClass('focus');
  }).focusout(function () {
    $(this).parent().removeAttr('class');
  });

  // add hover effects to tables
  $('tr').focusin(function () {
    $(this).addClass('current');
  }).focusout(function () {
    $(this).removeClass('current');
  });

  /*
   * Calculate the height of the left nav to set min-height of the
   * article-content class
   */
  if ($('.article-content').length > 0) {
    var leftNavHeight = $('.local-nav').height();
    var articleContent = $('.article-content').height();
    if (leftNavHeight > articleContent) {
      $('.article-content').css('min-height', leftNavHeight);
    }
  }

  /* Mobile Menu Toggle */
  $('.left-nav-menu').click(function () {

    // DI-6129: Mobile menu fix for fontawesome svg IE
    var $leftNav = ($(this).find('span.fa').length > 0) ? $(this).children('span.fa') : $(this).children('svg.svg-inline--fa');

    if ($leftNav.hasClass('fa-bars')) {
      $leftNav.removeClass('fa-bars').addClass('fa-times');
      $('.local-nav').show('slide', {
        direction: 'left'
      });
    }
    else {
      $leftNav.removeClass('fa-times').addClass('fa-bars');
      $('.local-nav').hide('slide', {
        direction: 'left'
      }, 'fast');
    }
  });

  function mobileAccordian(ulToBeSlider, addWrapperClass) {

    // all menus with the same "addWrapperClass" are combined
    $(ulToBeSlider).parent().addClass(addWrapperClass);

    var $wrapper = $('.' + addWrapperClass);
    $wrapper.find('> li').addClass('slider-key');
    $wrapper.find('> li > ul').addClass('slider-children');
    $wrapper.accordion({
      active: false,
      collapsible: true,
      heightStyle: 'content'
    });

    $wrapper.find('.slider-key > a').attr('tabindex', '0');
  }

  // Mobile Nav
  mobileAccordian('#sidebar-first ul.mobile-nav li ul', 'mobile-nav-sliders');
  // Quick Links Mobile Nav
  mobileAccordian('#sidebar-first ul.mobile-nav-ql li ul',
    'mobile-nav-ql-sliders');
  // left sidebar nav
  mobileAccordian('#sidebar-first nav ul li ul', 'left-nav-sliders');

  /* AddThis async load function */
  var checkAddThisLoadedInterval = null;

  function checkAddThisLoaded() {
    if ($('.addthis_button_compact')) {
      $('.appIconsDetail').css('visibility', 'visible');
      clearInterval(checkAddThisLoadedInterval);
    }
  }

  if (typeof window.addthis !== 'undefined') {
    window.addthis.init();
    checkAddThisLoadedInterval = setInterval(checkAddThisLoaded, 100);
  }

  // This looks like it is just hiding rows based on the search in the header on
  // list pages...
  if ($('.list-search-label').length > 0) {

    /* Filter list by keywords */
    var $rows = $('.list tbody tr');
    $('#list-search-field').keyup(
      function () {
        var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase();

        // do not filter columns with noFilter class
        $rows.show().filter(
          function () {
            var text = $(this).children('td').not('.noFilter').text()
              .replace(/\s+/g, ' ').toLowerCase();
            return !~text.indexOf(val);
          }).hide();
      });

  }

  // refocus after form submit/reset
  if ($('.view-filters .views-exposed-form').length > 0) {
    Drupal.behaviors.focusAfterSubmit = {
      attach: function (context, settings) {
        $('[id^=edit-submit]', context).on('click', function (e) {
          $("input[name='aId']", this.form).val($(this).attr('id'));
          $(this).closest('form').trigger('submit');
        });
      }
    };

  }
  // add end of day time to datepicker on events
  if ($('.events_list-block_1').length > 0) {
    Drupal.behaviors.contentSearchPage = {
      attach: function (context, settings) {
        $('#edit-field-end-date-value', context).change(function () {
          if ($(this).val().length > 0 && ($(this).val().indexOf('23:59:59')=== -1)) {
            $(this).val($(this).val() + ' 23:59:59');
          }
        });
      }
    };
  }

  // Activate accordion
  if ($('.list-accordion').length > 0) {
    //    var icons = {
    //      header: 'ui-icon-circlesmall-plus',
    //      activeHeader: 'ui-icon-circlesmall-minus'
    //    };
    $('.list-accordion').accordion({
      active: false,
      collapsible: true
    });
  }

  // Activate tabs
  function setTabSize() {

    $('li.ui-tabs-tab').css('height', '');
    $('li.ui-tabs-tab').children().removeAttr('style');

    //    var tabSets;
    var tabsLength;
    var tabGroupName;
    var tabWidth;
    var tabHeights = [];
    var tabWidths = [];
    var contentHeights = [];
    var tabHeight;
    // var currentHeight;
    // var maxHeight;
    // var minHeight;
    // var newPadding;

    //    if ($('.ui-tabs').length > 0) {
    //      tabSets = $('.ui-tabs').length;
    //    }

    // if ( $('div[id^="tabs"] ul li').length > 0 ) {
    //
    // } else if ( $('div.tabs ul li').length > 0 ) {
    // tabsLength = $('div.tabs ul > li.ui-state-default').length;
    // }

    $('.ui-tabs').each(
      function (i) {

        if ($(this).attr('id')) {
          tabGroupName = '#' + $(this).attr('id');
        }
        else {
          $(this).attr('id', 'tabs-ui-tabs-' + i);
          tabGroupName = '#' + $(this).attr('id');
        }

        if ($(tabGroupName).has('li.ui-tabs-tab')) {

          tabsLength = $(tabGroupName + ' ul li.ui-tabs-tab').length;

          $(tabGroupName + ' ul li.ui-tabs-tab').each(function (tab) {
            tabWidth = (100 / tabsLength);
            $(this).css('width', tabWidth + '%');
          });

          // finds the largest height and creates tabs that are equal heights
          Array.max = function (array) {
            return Math.max.apply(Math, array);
          };
          Array.min = function (array) {
            return Math.min.apply(Math, array);
          };

          $(tabGroupName + ' ul li.ui-tabs-tab').each(function (tab) {
            tabHeights.push($(this).height());
            contentHeights.push($(this).has('a').contents().height());
          });

          tabHeight = Array.max(tabHeights);
          tabWidth = Array.max(tabWidths);
          // maxHeight = Array.max(contentHeights);
          // minHeight = Array.min(contentHeights);

          if (tabHeight < 32) {
            $(tabGroupName + ' ul li.ui-tabs-tab').css('height', '32px');
          }
          else {
            $(tabGroupName + ' ul li.ui-tabs-tab').css('height',
              Array.max(tabHeights) + 'px');
          }

          $(tabGroupName + ' a.ui-tabs-anchor').each(function (i) {
            var h;
            // var p;
            h = contentHeights[i];
            // p = (tabHeight - h) / 2;

            $(this).css({
              'padding-top': Math.round((tabHeight - h) / 2) + 'px',
              'height': 'inherit'
            });
          });
        }
      });

    if ($(window).width() < 476) {
      if ($('div[id^="tabs-"] ul.ui-tabs-nav li').length > 4) {
        $('div[id^="tabs-"]').addClass('vertical-tabs');
      }
      if ($(tabGroupName).hasClass('vertical-tabs')) {
        $('div.vertical-tabs ul.ui-tabs-nav li').removeAttr('style');
        $('div.vertical-tabs ul.ui-tabs-nav li a').removeAttr('style');
      }
    }
  }

  if ($('div[id^="tabs-"]').length > 0) {
    Drupal.behaviors.contentTabBox = {
      attach: function (context, settings) {
        $('div[id^="tabs-"]').tabs();
        // function to fix the alignment and padding
        $.fn.resetTabs = function () {
          // finds the largest height and creates tabs that are equal
          $('li.ui-tabs-tab').css('height', '');
          $('li.ui-tabs-tab').children().removeAttr('style');
        };
        setTabSize();
      }
    };
  }
  if ($('div.tabs').length > 0) {
    Drupal.behaviors.contentTabBox = {
      attach: function (context, settings) {
        $('div.tabs').tabs();
        // function to fix the alignment and padding
        $.fn.resetTabs = function () {
          // finds the largest height and creates tabs that are equal
          $('li.ui-tabs-tab').css('height', '');
          $('li.ui-tabs-tab').children().removeAttr('style');
        };
        setTabSize();
      }
    };
  }

  Drupal.behaviors.statusMessage = {
    attach: function(context, settings) {
      $(document).ready(function() {
        // Try First
        $('.message-item').focus();
        // Try second
        // initial hide all status messages using css
        // $(".messages").slideDown().find('.message-item')).focus();
        // Try third
        // initial hide all status messages using css
        // var $messageItem = $('.message-item').hide().remove();
        // $(".messages").slideDown();
        // $messageItem.prependTo('.messages').slideDown().focus();
      })
    },
  }

  $('.field--name-field-transcript').attr('id', 'accordion-transcript');

  if ($('div[id^="accordion-"]').length > 0) {
    $('div[id^="accordion-"]').accordion({
      active: false,
      collapsible: true,
      heightStyle: 'content'
    });
  }

  $.fn.getQueryVariable = function () {
    var query = window.location.search.substring(1);
    var vars = query.split('&');
    var pair;
    var i = 0;
    var elem;
    if (vars.length > 0) {
      pair = vars[i].split('=');
      if (pair[0] === 'aId') {
        elem = pair[1];
      }
    }
    return elem;
  };
  // autofocus on page load
  $(window).on("load",function () {
    var q = $.fn.getQueryVariable();
    if (q) {
      $('#' + q).focus();
    }
  });

  // Custom backtoTop logic.
  var initBackTotop = function () {
    // No business running this function if id is not there.
    if ($('.back-to-top').length === 0) {
      return;
    }

      // Logic to handle smoother return-to-top.
      var amountScrolled = 500;
      var backTotop = $('a.back-to-top');
      var footerHeight = $("section[role='footer']").height() + 10;
      backTotop.hide();
      $(window).scroll(function () {
        if ($(window).scrollTop() > amountScrolled) {
          backTotop.fadeIn('slow');
          backTotop.css('bottom', footerHeight);
        }
        else {
          backTotop.fadeOut('slow');
        }
      });

      $('a.back-to-top').click(function () {
        $('html, body').animate({
          scrollTop: 0
        }, 700);
        return false;
      });

  };


function updateQueryStringParameter(uri, key, value) {
  var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
  var separator = uri.indexOf('?') !== -1 ? "&" : "?";
  if (uri.match(re)) {
    return uri.replace(re, '$1' + key + "=" + value + '$2');
  }
  else {
    return uri + separator + key + "=" + value;
  }
}

  //Submit items per page
  if ($('#table_paging').length > 0) {
    Drupal.behaviors.itemsPerPage = {
      attach: function (context, settings) {
        var $currentPage = window.location.search;
        if ($('#table_paging .pager-wrapper').length > 0) {
          $currentPage = $('.pager__item.is-active a').attr('href');
        }
        $('#table_paging select', context).change(function () {
          if ($currentPage.indexOf('items_per_page') === -1){
            window.location.search = $currentPage + '&items_per_page=' + this.value;
          }
          else {
            window.location.search = updateQueryStringParameter($currentPage, 'items_per_page', this.value)
          }
          });
        }
      };
    };


  // On document ready envoke our method;
  $(document).ready(
    function () {
      initBackTotop();
      // Detect select change for datatable front-end length change event.
      $('#datatable_length select').change(function () {
        initBackTotop();
      });
      /*
         * if ($('body.node--type-link').length > 0) { var redirectTo =
         * $('.field-link-title-url a').attr('href');
         * window.location.replace(redirectTo); }
         */
      var displayHelpBlocks = $('#videoplayer').length > 0
            || $('.sample-player').length > 0 ? true : false;
      if (displayHelpBlocks) {
        $('#block-webcast-trouble,#block-flashsoftware').show();
      }
    });

  // iife to handle clickble table row in data-distribution table view;
  (function (selector) {

    $('.associated-data-distribution table tbody tr').each(
      function () {
        var href = $(selector, this).attr('href');
        // var height = $(this).find('td').height();
        if (href) {
          var link = $(
            '<a href="' + $(selector, this).attr('href')
                    + '" download></a>').css({
            'text-decoration': 'none',
            'display': 'block',
            'color': $(this).css('color')
          });
          $(this).children().wrapInner(link);
        }
      });

  }('a:first'));

  // Begin logic for custom smooth scroll to an anchor.
  // Re-use this method for your own custom scroll to anchor needs. Just add
  // generic css class e.g. 'scroll' in the anchor tag
  // and replace the selector e.g. $('.scroll');

  var hashTagActive = '';
  $('#sec-mission .hp-content a').on(
    'click',
    function (e) {
      if ($(this).get(0).hash) {
        if (hashTagActive !== this.hash) { // this will prevent if the user
          // click several times the same link
          // to freeze the scroll.
          e.preventDefault();
          // calculate destination place
          var dest = 0;
          if ($(this.hash).offset().top > $(document).height()
                - $(window).height()) {
            dest = $(document).height() - $(window).height();
          }
          else {
            dest = $(this.hash).offset().top;
          }
          // go to destination
          $('html,body').animate({
            scrollTop: dest
          }, 1000, 'swing');
          hashTagActive = this.hash;
        }
      }
    });

  // Submit handler for 'meeting category' select option;
  $(document.body).on('change', '#edit-field-meeting-category-value',
    function () {
      $(this).closest('form').submit();
    });

  //Event calendar
  $(document).ready(function () {
    //show all invites if there are no multiple
    if ( $('.field_session .event_session').length === 1) {
      $('.event_add_cal').css('display', 'table-cell');
		  $(this).find($('.cal_item')).addClass('active');
    }
    else {
      $('.field_session .event_session').each(function (i){
        //show invites related to row
        $(this).find($('.cal_item')).eq(i).css('display', 'table-cell').addClass('active');
        //hide other invites
        $(this).find($('.cal_item')).not(':eq(' + i + ')').css('display', 'none');
        $('.event_add_cal').css('display', 'table-cell');
      });
    }
	  //generate invite button
    $(".atcb-link").click(function (e){
      cal_id = '.cal_item.active ' + '#' + this.id + ' + .atc_event ';
      cal_single = ics();
      cal_single.addEvent($(cal_id).find('.atc_title').text(),
                          $(cal_id).find('.atc_description').text().replace(/\n/g, "\\n"),
                          $(cal_id).find('.atc_description').html().replace(/\n/g, "\\n"),
                          $(cal_id).find('.atc_location').text(),
                          $(cal_id).find('.atc_date_start').text(),
                          $(cal_id).find('.atc_date_end').text());
      cal_single.download($(cal_id).find('.atc_title').text());
    });

    //on search page, if no microsite option selected, default to All
    if ($("body.path-search").length > 0) {
      if ($("#edit-field-site-section option[selected]").length === 0) {
        $("#edit-field-site-section option[value='All']").attr("selected","selected");
      }
      var options = $('#edit-field-site-section option' );
      $(options[1]).insertBefore($(options[0]));
    }
  });

  // Hide the masquerade button when panelizer is expanded.
  if ($('#panels-ipe-tray').length > 0) {
    const targetNode = $('#panels-ipe-tray')[0];

    // Options for the observer (which mutations to observe)
    const config = {
      subtree: true,
      attributes: true,
      childList: true,
      attributeFilter: ['class']
    };

    // Callback function to execute when a change in the targetNode subtree is
    // detected
    const callback = function(mutationsList) {
      for (var i = 0; i < mutationsList.length; i++) {
        mutation = mutationsList[i];
        // Only the edit button triggers an attribute mutation.
        if (mutation.type === 'attributes') {
          if (showOrHideMasquerade(mutation.target, 'active', 99)) {
            break;
          }
        }
        $addedNodes = mutation.addedNodes;
        $removedNodes = mutation.removedNodes;

        for (var j = 0; j < $addedNodes.length; j++) {
          if (showOrHideMasquerade($addedNodes[j], 'ipe-tab active', 201)) {
            break;
          };
        }

        for (var k = 0; k < $removedNodes.length; k++) {
          if (showOrHideMasquerade($removedNodes[k], 'ipe-tabs-content', 99)) {
            break;
          };
        }
      }
    };

    // Create an observer instance linked to the callback function
    const observer = new MutationObserver(callback);

    // Start observing the target node for configured mutations
    observer.observe(targetNode, config);
  }

  function showOrHideMasquerade($node, $classString, $zIndexValue) {
    if ($node instanceof Element) {
      if ($node.getAttribute('class') === $classString) {
        $('#panels-ipe-tray').css('z-index', $zIndexValue);
        return true;
      }
    }

    return false;
  }

})(jQuery);
