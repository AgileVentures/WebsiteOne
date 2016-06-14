jQuery.fn.selectTimeZoneAndUpdateDateAndTime = function () {

    var setLocalDateAndTime = function () {
        var next_date = $('#next_date').val();
        var start_date = $('#start_date').val();
        var time = $('#start_time').val();
        var normalized_next_date_time = moment.utc(next_date + " " + time, "YYYY-MM-DD hh:mm a");
        var normalized_start_date_time = moment.utc(start_date + " " + time, "YYYY-MM-DD hh:mm a");
        var local_next_date_time = normalized_next_date_time.tz(tzUtilities.detectUserTimeZone());
        var local_start_date_time = normalized_start_date_time.tz(tzUtilities.detectUserTimeZone());
        $('#start_date').val(local_start_date_time.format("YYYY-MM-DD"));
        $('#start_time').val(local_next_date_time.format("hh:mm A"));
    };

    setLocalDateAndTime();

    var $el = $(this[0]); // our element

    var regEx = new RegExp(tzUtilities.detectUserTimeZone()); // create a RegExp object with our pattern

    $('option', $el).each(function (index, option) { // loop through all the options in our element

        var $option = $(option); // cache a jQuery object for the option

        if ($option.html().match(regEx)) { // check if our regex matches the html(text) inside the option
            $option.prop({selected: 'true'}); // select the option
            return false; // stop the loop—we're all done here
        }
    });

};
var tzUtilities = {
    detectUserTimeZone : function () {
        return moment.tz.guess();
    }
}

var showUserTimeZone = function(){
    if ($("#local_time").length) {
        $('#local_time').append("&nbsp;"+tzUtilities.detectUserTimeZone());
    }
};

var handleUserTimeZone = function () {
    if ($("#start_time_tz").length) {
        $('#start_time_tz').selectTimeZoneAndUpdateDateAndTime();
    }
};

$(document).on('ready page:load', function () {
    handleUserTimeZone();
    showUserTimeZone();
});
