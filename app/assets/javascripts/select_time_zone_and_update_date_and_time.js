jQuery.fn.selectTimeZoneAndUpdateDateAndTime = function () {

    var setLocalDateAndTime = function () {
        var date = $('#next_date').val();
        var time = $('#start_time').val();
        var normalized_date_time = moment.utc(date + " " + time, "YYYY-MM-DD hh:mm a");
        var local_date_time = normalized_date_time.tz(jstz.determine().name());
        //$('#start_date').val(local_date_time.format("YYYY-MM-DD"));
        $('#start_time').val(local_date_time.format("hh:mm A"));
    };

    setLocalDateAndTime();

    var $el = $(this[0]); // our element

    var regEx = new RegExp(jstz.determine().name()); // create a RegExp object with our pattern

    $('option', $el).each(function (index, option) { // loop through all the options in our element

        var $option = $(option); // cache a jQuery object for the option

        if ($option.html().match(regEx)) { // check if our regex matches the html(text) inside the option
            $option.prop({selected: 'true'}); // select the option
            return false; // stop the loop—we're all done here
        }
    });

};

var handleUserTimeZone = function () {
    if ($("#start_time_tz").length) {
        $('#start_time_tz').selectTimeZoneAndUpdateDateAndTime();
    }
};

$(document).on('ready page:load', function () {
    handleUserTimeZone();
});
