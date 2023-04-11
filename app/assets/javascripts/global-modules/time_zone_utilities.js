WebsiteOne.define('timeZoneUtilities', function() {
    function timeZoneUtilities () {
    this.detectUserTimeZone = function () {
        return moment.tz.guess();
    }
    this.init = function() {
    }
    };
    return new timeZoneUtilities();
});