var browserAdapter = {
    jumpTo : function (url) {
        window.location.assign(url);
    }
};

var events = {
    makeRowBodyClickable : function () {
        $('.event-row').css('cursor', 'pointer');
        $('.event-row').on('click', function (event) {
            var clicked_row = $(this);
            var href = clicked_row.find('.event-title a')[0].href;
            browserAdapter.jumpTo(href);
        });
    },
    hideCalendarLinks: function () {
        $('#calendar_links').hide();
    },
    addToCalendar: function () {
        $('#calendar_link').on('click', function () {
            $('#calendar_links').show();
        })
    }
};

$(document).ready(function () {
    events.makeRowBodyClickable();
    events.hideCalendarLinks();
    events.addToCalendar();
    editEventForm.handleUserTimeZone();
    showEvent.showUserTimeZone();
});