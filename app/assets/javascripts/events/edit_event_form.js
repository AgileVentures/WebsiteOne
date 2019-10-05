var editEventForm = {
    timezone: function () {
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
    updateDateAndTimeToUserTimeZone: function (next_date, start_date, start_time) {
        var normalized_next_date_time = moment.utc(next_date.val() + " " + start_time.val(), "YYYY-MM-DD hh:mm a");
        var normalized_start_date_time = moment.utc(start_date.val() + " " + start_time.val(), "YYYY-MM-DD hh:mm a");
        var local_next_date_time = normalized_next_date_time.tz(this.timezone());
        var local_start_date_time = normalized_start_date_time.tz(this.timezone());
        start_date.val(local_start_date_time.format("YYYY-MM-DD"));
        start_time.val(local_next_date_time.format("hh:mm A"));

        let daysOfWeek = document.querySelectorAll('#daysOfWeek>label>input')
        let arrayOfdays = []
        daysOfWeek.forEach((checkBox) => arrayOfdays.push(checkBox.checked))
        /*
        normalized_start_date_time.year()
        local_start_date_time.year()
        normalized_start_date_time.month()
        local_start_date_time.month()
        normalized_start_date_time.date()
        local_start_date_time.date()
        */
       console.log(normalized_start_date_time)
       let local_date;
        let rotation;
        if(
            normalized_start_date_time.year() === local_start_date_time.year() &&
            normalized_start_date_time.month() ===local_start_date_time.month() &&
            normalized_start_date_time.date()===local_start_date_time.date()
    
        ){
            rotation=0
        }
        else if (normalized_start_date_time.year() > local_start_date_time.year() 
        ||
        normalized_start_date_time.year() === local_start_date_time.year() &&
        normalized_start_date_time.month() >local_start_date_time.month()
        ||
        normalized_start_date_time.year() === local_start_date_time.year() &&
        normalized_start_date_time.month() ===local_start_date_time.month() &&
        normalized_start_date_time.date()>local_start_date_time.date()
        ) {
            rotation = 1
        }else{
            rotation = -1
        }
        /*
        console.log(arrayOfdats)
        todo : rotate
        arrayOfdays[0] = true
        */
        daysOfWeek.forEach((checkBox, index) => checkBox.checked = arrayOfdays[index])

    }
};

jQuery.fn.setToUserTimeZone = function (timezone) {
    var regEx = new RegExp(timezone);

    $('option', $(this[0])).each(function (index, option) {

        var $option = $(option);

        if ($option.html().match(regEx)) {
            $option.prop({ selected: 'true' });
            return false;
        }
    });
};