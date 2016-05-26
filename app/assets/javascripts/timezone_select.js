jQuery.fn.selectTimeZone = function() {

    var $el = $(this[0]); // our element

    var date = new Date();
    var match = /((\+|\-)\d\d)(\d\d)/.exec(date);

    offsetFromGMT = '\\' + match[1] + ':' + match[3];

    var regEx = new RegExp(offsetFromGMT); // create a RegExp object with our pattern

    $('option', $el).each(function(index, option) { // loop through all the options in our element

        var $option = $(option); // cache a jQuery object for the option
        //console.log($option.html());
        if($option.html().match(regEx)) { // check if our regex matches the html(text) inside the option
            $option.attr({selected: 'true'}); // select the option
            return false; // stop the loop—we're all done here
        }
    });
}

$(document).on('ready page:load', function () {
    $('#start_time_tz_time_zone').selectTimeZone();
});