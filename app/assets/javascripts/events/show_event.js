var showEvent = {
    showUserTimeZone: function () {
        if ($("#local_time").length) {
            $('#local_time').append("&nbsp;" + timeZoneUtilities.detectUserTimeZone());
        }
    }
};