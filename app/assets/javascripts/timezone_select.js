normalize_date_time = function(date, time) {
    date_matches = date.match(/(\d\d\d\d)-(\d\d)-(\d\d)/);
    var year = date_matches[1];
    var day = date_matches[2];
    var month = date_matches[3];
    time_matches = time.match(/(\d\d):(\d\d) (PM|AM)/);
    var minutes = time_matches[2];
    var hour = time_matches[1];
    if (time_matches[3] == "PM") {
        hour = parseInt(hour) + 12 + "";
    }
    normalized_date = new Date()
    normalized_date.setUTCFullYear(year);
    normalized_date.setUTCDate(day);
    normalized_date.setUTCMonth(month);
    normalized_date.setUTCHours(hour);
    normalized_date.setUTCMinutes(minutes);
    normalized_date.setUTCSeconds(0);
    return normalized_date;
}

jQuery.fn.selectTimeZone = function(normalizer) {

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
    normalized_date_time = normalizer($('#start_date').val(), $('#start_time').val());

    local_day = normalized_date.getDate();
    local_day = (local_day < 10)? "0"+local_day:""+local_day;
    local_month = normalized_date.getMonth();
    local_month = (local_month<10)?"0"+local_month:""+local_month;
    local_date = normalized_date_time.getFullYear()+ "-"+local_day+"-"+local_month;

    local_hours = normalized_date_time.getHours() % 12;
    local_hours = (local_hours < 10) ? ("0"+local_hours):""+local_hours;

    local_pm = " AM";
    if(normalized_date_time.getHours()>11){
        local_pm = " PM";
    }

    local_minutes = normalized_date_time.getMinutes();
    local_minutes = (local_minutes<10)?("0"+local_minutes):""+local_minutes;

    local_time = local_hours+":"+local_minutes+local_pm;

    $('#start_date').val(local_date);
    $('#start_time').val(local_time);
}

$(document).on('ready page:load', function () {
    $('#start_time_tz').selectTimeZone(normalize_date_time);
});