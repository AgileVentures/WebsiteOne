WebsiteOne.define('editEventForm', function () {

    function editEventForm () {
    this.timezone = function () {
        return WebsiteOne.timeZoneUtilities.detectUserTimeZone();
    }
    this.handleUserTimeZone = function () {
        if ($("#start_time_tz").length) {
            $('#start_time_tz').setToUserTimeZone(this.timezone());
        }
        if ($('#start_datetime').length) {
            this.updateDateAndTimeToUserTimeZone($('#start_datetime'));
        }
    }
    this.updateDateAndTimeToUserTimeZone = function (start_datetime) {
        var normalized_start_date_time = moment.utc(start_datetime.val(), "YYYY-MM-DDThh:mm");
        var local_start_date_time = normalized_start_date_time.tz(this.timezone());
        start_datetime.val(local_start_date_time.format("YYYY-MM-DDTHH:mm"));
        if (normalized_start_date_time.toDate().getUTCDate() !== normalized_start_date_time.toDate().getDate())
            this.localizeDaysOfWeek(normalized_start_date_time._offset);
    }
    this.localizeDaysOfWeek = function (offset) {
        var daysOfWeek = document.querySelectorAll('#daysOfWeek>label>input')
        if (daysOfWeek) {
            var arrayOfdays = []
            daysOfWeek.forEach(function (checkBox) { arrayOfdays.push(checkBox.checked) })
            var tmp;
            if (offset > 0) {
                tmp = arrayOfdays.pop()
                arrayOfdays.unshift(tmp)
            } else {
                tmp = arrayOfdays.shift()
                arrayOfdays.push(tmp)
            }
            daysOfWeek.forEach(function (checkBox, index) { checkBox.checked = arrayOfdays[index] })
        }
    }
    this.init = function() {
        //this.handleUserTimeZone();
    }
    };
    return new editEventForm();
});

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