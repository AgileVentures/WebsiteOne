var timeZoneUtilities = {
    detectUserTimeZone: function () {
        return moment.tz.guess();
    }
};