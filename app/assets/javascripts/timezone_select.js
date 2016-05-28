convert_date_time_to_local = function(date,time){

    var normalized_date_time = normalize_date_time(date, time);

    var local_hours = normalized_date_time.hours() % 12;
    local_hours = (local_hours < 10) ? ("0"+local_hours):""+local_hours;

    var local_pm = " AM";
    if(normalized_date_time.hours()>11){
        local_pm = " PM";
    }

    var local_minutes = normalized_date_time.minutes();
    local_minutes = (local_minutes<10)?("0"+local_minutes):""+local_minutes;

    var local_time = local_hours+":"+local_minutes+local_pm;
    return {date: normalized_date_time.format("YYYY-MM-DD"), time: local_time};
}

normalize_date_time = function(date, time) {
    var date_matches = date.match(/(\d\d\d\d)-(\d\d)-(\d\d)/);
    var year = date_matches[1];
    var day = date_matches[3];
    var month = date_matches[2];
    var time_matches = time.match(/(\d+):(\d\d) (PM|pm|AM|am)/);
    var minutes = time_matches[2];
    var hour = time_matches[1];
    if (time_matches[3] == "PM" || time_matches[3]=="pm") {
        hour = parseInt(hour) + 12 + "";
    }
    var normalized_date = moment.utc([year, month-1, day, hour, minutes, 0])
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
