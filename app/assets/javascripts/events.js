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
    }
}

$(document).ready(function () {
    events.makeRowBodyClickable();
    editEventForm.handleUserTimeZone();
    showEvent.showUserTimeZone();
});