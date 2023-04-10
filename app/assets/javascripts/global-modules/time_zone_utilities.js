WebsiteOne.define('timeZoneUtilities', function() {
    function timeZoneUtilities () {
    this.detectUserTimeZone = function () {
        return Intl.DateTimeFormat().resolvedOptions().timeZone; //moment.tz.guess();
    }
    this.init = function() {
    }
    };
    return new timeZoneUtilities();
});