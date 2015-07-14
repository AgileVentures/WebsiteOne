var Scrum = {
  setup: function () {
    $('.scrum_yt_link').on('click', Scrum.select_video);
    $('#scrumVideo').on('hidden.bs.modal', function(event){
        player = $("#scrumVideo .modal-body iframe").get(0);
        player.src = '';
    });
  },
  select_video: function(event) {
    event.preventDefault();
    player = $("#scrumVideo .modal-body iframe").get(0);
    player.src = 'http://www.youtube.com/embed/' + $(this).data('source') + '?enablejsapi=1';
    $('#scrumVideo #playerTitle').text($(this).data('content'));
  }

}
$(document).on('ready page:load', Scrum.setup)
