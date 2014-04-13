$(function () {
    function ready() {
        var hash = window.location.hash;
        hash && $(hash + 's a').tab('show');
        $('html,body').scrollTop($('body').scrollTop());

        $('.nav-tabs a').click(function (e) {
            $(this).tab('show');
            window.location.hash = this.hash.replace("s_list", "");
            $('html,body').scrollTop($('body').scrollTop());
        });

        $.ajax({
            url: 'https://apis.google.com/js/platform.js',
            dataType: "script",
            cache: true
        }).done(function () {
            var button = $('#HOA-placeholder');
            if (button != null && typeof gapi !== "undefined") {
                gapi.hangout.render('HOA-placeholder', {
                    'topic': button.data('hoa-title'),
                    'render': 'createhangout',
                    'hangout_type': 'onair',
                    'initial_apps': [
                        { 'app_type': 'ROOM_APP' }
                    ]
                });
            }
        });

    }

    $(document).ready(ready);
    $(document).on('page:load', ready);
});
