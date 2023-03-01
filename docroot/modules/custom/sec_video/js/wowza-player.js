(function ($, Drupal) {
  Drupal.behaviors.wowzaPlayer = {
    attach: function (context) {
      $(document, context).once('wowza_players').each(function () {

        $(document).ready(function () {
          let counter = 1001;
          let wowzaIDs = '';

          // If wowza player is embeded or in gallary then assign correct class.
          if ($('.embedded-entity').length) {
            wowzaIDs = '.embedded-entity #wowza_player_1001';
          } else if ($('.galleryGrid').length) {
            wowzaIDs = '.galleryGrid #wowza_player_1001';
          } else {
            wowzaIDs = '#wowza_player_1001';
          }

          // Change wowza player ID when there are > 1 video on a page.
          $(wowzaIDs).each(function () {
            let newID = 'wowza_player_' + counter;
            this.id = newID;

            // Getting URL for video
            let mediaID = $('#' + newID).data('mediaid');
            createVideo(newID, mediaID);
            counter++;
          })

          // Create video with source and captions.
          function createVideo(playerID, url) {
            // Set wowza player options.
            let options = {
              enableTouchActivity: true
            };
            // Create wowza player.
            let player = videojs(playerID, options, function () {
              // Always start video at 0 seconds.
              this.one('play', function () {
                this.currentTime(0);
              });
              // Adding touch play/pause for touch devices (mobile and tablets).
              // this.on('touchstart', function () {
              //   this.paused() ? this.play() : this.pause()
              // })
            })
            // Converting URL extension from .mp4 to .txt.
            let captionUrl = url.substr(0, url.lastIndexOf(".")) + ".txt";
            player.src({
              src: url,
              type: "video/mp4"
            })

            $.ajax({
              url: captionUrl,
              statusCode: {
                200: function (responseObject, textStatus, jqXHR) {
                  // Add caption source.
                  player.addRemoteTextTrack({
                    src: captionUrl,
                    kind: 'captions',
                    srclang: 'en',
                    label: 'English',
                    default: false
                  }, false)
                }
              }
            }).fail(function () {
              console.log('Caption file not found: ' + captionUrl)
            })
          }
        });
      });
    }
  }
})(jQuery, Drupal);
