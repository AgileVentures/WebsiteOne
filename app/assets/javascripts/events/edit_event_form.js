var editEventForm = {
    timezone : function() {
        return timeZoneUtilities.detectUserTimeZone();
    },
    handleUserTimeZone: function () {
        if ($("#start_time_tz").length) {
            $('#start_time_tz').setToUserTimeZone(this.timezone());
        }
        if ($('#start_time').length && $('#start_date').length) {
            this.updateDateAndTimeToUserTimeZone($('#next_date'), $('#start_date'), $('#start_time'));
        }
    },
    updateDateAndTimeToUserTimeZone : function(next_date, start_date, start_time){
        var normalized_next_date_time = moment.utc(next_date.val() + " " + start_time.val(), "YYYY-MM-DD hh:mm a");
        var normalized_start_date_time = moment.utc(start_date.val() + " " + start_time.val(), "YYYY-MM-DD hh:mm a");
        var local_next_date_time = normalized_next_date_time.tz(this.timezone());
        var local_start_date_time = normalized_start_date_time.tz(this.timezone());
        start_date.val(local_start_date_time.format("YYYY-MM-DD"));
        start_time.val(local_next_date_time.format("hh:mm A"));
    }
};

jQuery.fn.setToUserTimeZone = function(timezone){
    var regEx = new RegExp(timezone);

    $('option', $(this[0])).each(function (index, option) {

        var $option = $(option);

        if ($option.html().match(regEx)) {
            $option.prop({selected: 'true'});
            return false;
        }
    });
};