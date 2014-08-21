WebsiteOne.define('Users', function() {
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

    $('#skills').tags({
        readOnly: false,
        tagClass: 'add-btn-agile',
        tagSize: 'md',
        tagData: $('#skills').data("skill-list"),
        promptText: " "
    });

    $('#skills').bind("keydown keypress", function (e) {
        var code = e.keyCode || e.which;
        if (code == 9 || code == 44) {
            e.preventDefault();
            $("#skills").tags().addTag($('input.tags-input').val().replace(",", ""));
            $('input.tags-input').val("");
        }
        // Sampriti: Let bootstrap-tags handle Enter event
        else if (code == 13) {
            e.preventDefault();
        }
    });

    $('#edit_user').submit(function (event) {
        $("#user_skill_list").val($("#skills").tags().getTags().join(","));
    });

    $('#UsersFilterForm').on('submit', function(e){
      e.preventDefault();
      var users_list = $('#UsersList li');
      var search_string = $('#UsersFilter').val();
      console.log(users_list);
      console.log(search_string);
      if (search_string != '') {
        filter_trough_users(users_list, search_string);
      } else {
        users_list.each(function(){
          $(this).show();
        });
      }
    });
  }

  function filter_trough_users(users, keyword){ 
    users.each(function(){
      if (!$(this).find('p').text().match(keyword)) {
        $(this).hide();
      } else {
        $(this).show();
      }
    });
  }

  return {
    init: init,
    selectVideo: selectVideo
  }
});
