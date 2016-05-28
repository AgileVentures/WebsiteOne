convert_date_time_to_local = function(date,time){

    var normalized_date_time = normalize_date_time(date, time);

    return {date: normalized_date_time.format("YYYY-MM-DD"), time: normalized_date_time.format("hh:mm A")};
}

normalize_date_time = function(date, time) {

    var normalized_date = moment.utc(date +" " + time, "YYYY-MM-DD hh:mm a")
    return normalized_date.tz(jstz.determine().name());
}

jQuery.fn.selectTimeZone = function(converter) {

    var $el = $(this[0]); // our element

    var regEx = new RegExp(jstz.determine().name()); // create a RegExp object with our pattern

    $('option', $el).each(function(index, option) { // loop through all the options in our element

        var $option = $(option); // cache a jQuery object for the option
        //console.log($option.html());
        if($option.html().match(regEx)) { // check if our regex matches the html(text) inside the option
            $option.prop({selected: 'true'}); // select the option
            return false; // stop the loop—we're all done here
        }
    });


    var local_date_time = converter($('#start_date').val(),$('#start_time').val());
    $('#start_date').val(local_date_time.date);
    $('#start_time').val(local_date_time.time);
}

var timezone_select = {
    on_ready: function () {
        if ($("#start_time_tz").length) {
            $('#start_time_tz').selectTimeZone(convert_date_time_to_local);
        }
    }
};
$(document).on('ready page:load', function () {
    timezone_select.on_ready();
});
