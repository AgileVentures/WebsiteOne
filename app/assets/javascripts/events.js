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
    addToCalendar: function () {
        /* Any click not the calendar link will hide the calendar links div */
        $(document).click(function(e){
            if(e.currentTarget.activeElement.id === 'calendar_link') {
                $("#calendar_links").show();
            } else {
                $("#calendar_links").hide();
            }
        });
    }
};

$(document).ready(function () {
    // events.makeRowBodyClickable();
    events.addToCalendar();
    WebsiteOne.editEventForm.handleUserTimeZone();

    if ($("#local_time").length) {
        $('#local_time').append("&nbsp;" + WebsiteOne.timeZoneUtilities.detectUserTimeZone());
    }
    $(".dropdown-menu a").click(function() {
        $(this).closest(".dropdown").find("[data-toggle='dropdown']").dropdown("toggle");
    });
    $("#attendance_checkbox").change( function (){
        $(".form-class").submit();
    });
});
