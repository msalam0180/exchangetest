jQuery(document).ajaxComplete(function() {
  document.querySelector('[id^="limelight_player_9279"]').focus();
});

jQuery(document).ready(function($) {
  var counter = 92795;
  var allVideos = [];
  // Check to see if .embedded-entity exists and assign selector to a variable based on that
  var embed_selector = ($('.embedded-entity').length) ? '.embedded-entity #limelight_player_92795' : '#limelight_player_92795';  
  $(embed_selector).each(function() {
    allVideos.push(this);
  });

   // Check to see if .galleryGrid exists and assign selector to a variable based on that
   var gallery_selector = ($('.galleryGrid').length) ? '.galleryGrid #limelight_player_92795' : '#limelight_player_92795';  
   $(gallery_selector).each(function() {
     allVideos.push(this);
   });
   
  
  // For loop to change limelight player ID when there are more then 1 video embed on a page.
  $(allVideos).each(function() {
    var newID = 'limelight_player_'+counter;
    this.id = newID;
    // Creating limelight player
    var playercode = $('#'+this.id).data('mediaid');
    if (typeof window.LimelightPlayerUtil !== 'undefined') {
      window.LimelightPlayerUtil.embed({playerForm: 'Player', width: 480, playerId: this.id, mediaId: playercode, height: 270});
    }
    counter++;
  })
});
