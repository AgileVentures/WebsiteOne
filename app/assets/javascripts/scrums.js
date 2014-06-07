var Scrum = {
  setup: function () {
    $('.scrum_yt_link').on('click', Scrum.select_video);
  },
  select_video: function(event) {
    event.preventDefault();
    player = $(".modal-body iframe").get(0);
    player.src = 'http://www.youtube.com/embed/' + this.id + '?enablejsapi=1';
    $('#playerTitle').text($(this).data('content'));
  }

}
$(Scrum.setup);
