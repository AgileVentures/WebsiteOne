
WSO.define('Users', function() {
  var player;

  function selectVideo(event) {
    event.preventDefault();
    player = $('#ytplayer');
    player.attr('src', 'http://www.youtube.com/v/' + this.id + '?version=3&enablejsapi=1');
    $('#video_contents').text($(this).data('content'));

    $('html, body').animate({
      scrollTop: player.offset().top - 100
    }, 300);
  }

  function init() {
    $('.yt_link').on('click', selectVideo);
  }

  return {
    init: init,
    selectVideo: selectVideo
  }
});