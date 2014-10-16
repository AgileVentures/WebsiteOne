WebsiteOne.define('Users', function () {
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

        $('#user-filter').on('keydown', function (e) {
            if (e.keyCode == 13) e.preventDefault();
        });

        $('#tabs a').click(function (e) {
            var scrollHeight = $(document).scrollTop();
            $(this).tab('show');
            setTimeout(function () {
                $(window).scrollTop(scrollHeight);
            }, 5);
        });

        $('#user-filter').on('keyup', function (e) {
            e.preventDefault();

            var searchString = $(this).val().trim().toLowerCase();
            var users = $('.media-list li');

            filtered = $(users).filter(function () {
                return $(this).text().toLowerCase().match(searchString);
            }).show();
            $(users).not(filtered).hide();
        });
    }

    return {
        init: init,
        selectVideo: selectVideo
    }
});
