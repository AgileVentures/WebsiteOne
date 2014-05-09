var Scrum = {
  setup: function () {
    $('.yt_link').on('click', Scrum.select_video);
  },
  select_video: function(event) {
    event.preventDefault();
    player = $('#ytplayer').get(0);
    player.src = 'http://www.youtube.com/v/' + this.id + '?version=3&enablejsapi=1';
    $('#scrum_contents').text($(this).data('content'));
  }
};
$(Scrum.setup);