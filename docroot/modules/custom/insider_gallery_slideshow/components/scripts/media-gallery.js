jQuery(function($) {

  $(function(){

    // Alter href attribute of left nav; overrides default Drupal functionality
    $(".local-nav nav[role='navigation'] li a").each(function(i, o) {
      $(o).attr("href", "#");
    });

    // Add data-filter attribute to left nav a elements; remove Drupal data attribute
    $(".local-nav li.item-all a").attr("data-filter", "*").removeAttr("data-drupal-link-system-path");
    $(".local-nav li.item-graphics a").attr("data-filter", ".graphic").removeAttr("data-drupal-link-system-path");
    $(".local-nav li.item-photos a").attr("data-filter", ".photo").removeAttr("data-drupal-link-system-path");
    $(".local-nav li.item-videos a").attr("data-filter", ".video").removeAttr("data-drupal-link-system-path");

    // Add id to nav ul element; referenced in .mediaBoxes instantiation below
    $(".local-nav nav[role='navigation'] ul").attr("id", "mbox-filter");

    //Resize Icon/Target sizes for Desktop (Mobile is defaulted per set classes in HTML)
    function shareIconResizer() {
      // If window width is GT 800px
      if ($(window).width() > 800) {
        $(".media-box-social-buttons em").not(".svg-icon-circle-fill").removeClass("svg-icon-box-md").removeClass("svg-icon-sm");
        $(".media-box-social-buttons em").not(".svg-icon-circle-fill").addClass("svg-icon-box-sm").addClass("svg-icon-xs");
        $(".media-box-social-buttons em.svg-icon-circle-fill").removeClass("svg-icon-box-sm").removeClass("svg-icon-xs").addClass("svg-icon-box-xs");

      // If window width is LTE 800px
      } else {
        $(".media-box-social-buttons em").not(".svg-icon-circle-fill").removeClass("svg-icon-box-sm").removeClass("svg-icon-xs");
        $(".media-box-social-buttons em").not(".svg-icon-circle-fill").addClass("svg-icon-box-md").addClass("svg-icon-sm");
        $(".media-box-social-buttons em.svg-icon-circle-fill").removeClass("svg-icon-box-xs").addClass("svg-icon-box-sm").addClass("svg-icon-xs");
      }
    }
    $(window).on("resize load", shareIconResizer);
    $(document).on("ready load", shareIconResizer);

    //Share Button Script
    $(window).on("load scroll", function() {
      var mBoxContainer = $("div.media-box > div.media-box-container");

      // Twitter Share
      $(mBoxContainer).each(function(index, element) {
        // element == this
        var socialBtns = $(element).find("div.media-box-footer > div.media-box-social-buttons");
        var linkSrc = $(element).find("div.media-box-image > div + div").attr("data-popup");

        // Twitter Tweet: Refer to https://dev.twitter.com/web/intents#tweet-intent
        var twitterURL = "https://twitter.com/intent/tweet";
        twitterURL += "?text=Check%20out%20what%20I%20found%20on%20%40SEC_News'%20Media%20Gallery!%20https%3A%2F%2Fwww.sec.gov%2Fnews%2Fmedia-gallery%2F%23mb%3D" + linkSrc + "%7C%7Cgrid";
        var twitterLink = $(element).find("div.media-box-footer > div.media-box-social-buttons > a.twitterShare").attr("href", twitterURL);
        return twitterLink;
      });

      // Facebook Share
      $(mBoxContainer).each(function(index, element) {
        // element == this
        var socialBtns = $(element).find("div.media-box-footer > div.media-box-social-buttons");
        var mediaSrc = $(element).find("div.media-box-image > div").attr("data-thumbnail");
        var linkSrc = $(element).find("div.media-box-image > div + div").attr("data-popup");
        var mediaType = $(element).find("div.media-box-footer > div.media-box-social-buttons > a.fbShare").attr("href", fbURL);

        // Facebook Share Setup: Refer to http://donordigital.com/services/socialshare/
        var fbURL = "https://www.facebook.com/dialog/feed?app_id=184683071273";
        fbURL += "&link=https%3A%2F%2Fwww.sec.gov%2Fnews%2Fmedia-gallery%2F%23mb%3D" + linkSrc + "%7C%7Cgrid";
        fbURL += "&picture=" + mediaSrc;
        fbURL += "&name=SEC%20Media%20Gallery%3A%20" + $(element).find("div.media-box-image > div + div").attr("title");
        //fbURL += "&caption=Check%20out%20what%20I%20found%20on%20SEC's%20Media%20Gallery!";
        fbURL += "&description=Check%20out%20what%20I%20found%20on%20SEC's%20Media%20Gallery!";
        fbURL += "&redirect_uri=http%3A%2F%2Fwww.facebook.com%2F";
        //fbURL += "&hashtag=%23SECMediaGallery";
        var fbLink = $(element).find("div.media-box-footer > div.media-box-social-buttons > a.fbShare").attr("href", fbURL);
        return fbLink;
      });

      // LinkedIn Share
      $(mBoxContainer).each(function(index, element) {
        // element == this
        var socialBtns = $(element).find("div.media-box-footer > div.media-box-social-buttons");
        var mediaSrc = $(element).find("div.media-box-image > div").attr("data-thumbnail");
        var linkSrc = $(element).find("div.media-box-image > div + div").attr("data-popup");

        // LinkedIn Post: Refer to https://developer.linkedin.com/docs/share-on-linkedin
        var linkedInURL = "https://www.linkedin.com/shareArticle?mini=true";
        linkedInURL += "&url=https%3A//www.sec.gov/news/media-gallery/%23mb%3D" + linkSrc + "%7C%7Cgrid";
        linkedInURL += "&title=SEC%20Media%20Gallery%3A%20" + $(element).find("div.media-box-image > div + div").attr("title");
        linkedInURL += "&summary=Check%20out%20what%20I%20found%20on%20SEC's%20Media%20Gallery!";
        linkedInURL += "&source=us-securities-and-exchange-commission";
        var linkedInLink = $(element).find("div.media-box-footer > div.media-box-social-buttons > a.linkedInShare").attr("href", linkedInURL);
        return linkedInLink;
      });

      // Pinterest Share
      $(mBoxContainer).each(function(index, element) {
        // element == this
        var socialBtns = $(element).find("div.media-box-footer > div.media-box-social-buttons");
        var mediaSrc = $(element).find("div.media-box-image > div").attr("data-thumbnail");
        var linkSrc = $(element).find("div.media-box-image > div + div").attr("data-popup");

        // Pinterest Pins Setup: Refer to http://developers.pinterest.com/pin_it/  -and-  http://donordigital.com/services/socialshare/
        var pinItURL = "http://pinterest.com/pin/create/button/";
        pinItURL += "?url=https%3A%2F%2Fwww.sec.gov%2Fnews%2Fmedia-gallery%2F%23mb%3D" + linkSrc + "%7C%7Cgrid";
        pinItURL += "&media=" + mediaSrc;
        pinItURL += "&description=SEC%20Media%20Gallery%3A%20" + $(element).find("div.media-box-image > div + div").attr("title");
        var pinLink = $(element).find("div.media-box-footer > div.media-box-social-buttons > a.pinShare").attr("href", pinItURL);
        return pinLink;
      });

      //Email Share
      $(mBoxContainer).each(function(index, element) {
        // element == this
        var socialBtns = $(element).find("div.media-box-footer > div.media-box-social-buttons");
        var mediaSrc = $(element).find("div.media-box-image > div").attr("data-thumbnail");
        var linkSrc = $(element).find("div.media-box-image > div + div").attr("data-popup");

        // Email Share Setup: Refer to http://donordigital.com/services/socialshare/
        var emailItURL = "mailto:";
        emailItURL += "?subject=SEC%20Media%20Gallery%3A%20" + $(element).find("div.media-box-image > div + div").attr("title");
        emailItURL += "&body=Check%20out%20what%20I%20found%20on%20SEC's%20Media%20Gallery%3A%20https%3A%2F%2Fwww.sec.gov%2Fnews%2Fmedia-gallery%2F%23mb%3D" + linkSrc + "%7C%7Cgrid";
        var emailLink = $(element).find("div.media-box-footer > div.media-box-social-buttons > a.emailShare").attr("href", emailItURL);
        return emailLink;
      });
    });
  });

  $(document).ready(function(){
    $('#grid').mediaBoxes({
        boxesToLoadStart: 6,
        boxesToLoad: 6,
        deepLinking: true,
        showOnlyLoadedBoxesInPopup: false,
        filterContainer: '#mbox-filter',
        columns: 2,
        horizontalSpaceBetweenBoxes: 30,
        LoadingWord: 'Loading...',
        loadMoreWord: 'Load More',
        noMoreEntriesWord: 'No More Entries',
        minBoxesPerFilter: 6,
        resolutions: [
            {
                maxWidth: 800,
                columnWidth: 'auto',
                columns: 2,
            },
            {
                maxWidth: 700,
                columnWidth: 'auto',
                columns: 1,
            },
        ],
        search: '#mbox-search',
        verticalSpaceBetweenBoxes: 30,
        popup: 'magnificpopup'
    });
  });

});
