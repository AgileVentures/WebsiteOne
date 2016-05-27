jQuery.fn.selectTimeZone = function() {

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
}

$(document).on('ready page:load', function () {
    $('#start_time_tz').selectTimeZone();
});