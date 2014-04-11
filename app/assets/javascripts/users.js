
WSO.define('Users', function() {
  var player;

  function selectVideo(event) {
    event.preventDefault();
    player = $('#ytplayer').get(0);
    player.src = 'http://www.youtube.com/v/' + this.id + '?version=3&enablejsapi=1';
    $('#video_contents').text($(this).data('content'));
  }

  function init() {
    $('.yt_link').on('click', selectVideo);
  }

  return {
    init: init,
    selectVideo: selectVideo
  }
});