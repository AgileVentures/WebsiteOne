//= require ./wso

WSO.define('EventCountdown', function () {

    function EventCountdown() {
        var countdownClock, eventName, eventTime, eventUrl, textToAppend;

        this.format = function(num) {
            return (0 <= num && num < 10) ? '0' + num : num.toString();
        };

        this.update = function() {
            var timeToEvent = eventTime - new Date(),
                timeInSeconds = Math.floor(timeToEvent / 1000),
                timeInMins = Math.floor(timeInSeconds / 60),
                timeInHours = Math.floor(timeInMins / 60);

            if (timeInSeconds <= 0) {
                countdownClock.html('<a href="' + eventUrl + '">' + eventName + '</a> has started');
            } else {
                var tmp = '<p>';
                if (timeInHours > 0) {
                    tmp += this.format(timeInHours) + ':';
                }

                countdownClock.html(tmp + this.format(timeInMins % 60) +
                    ':' + this.format(timeInSeconds % 60) +
                    textToAppend);
                setTimeout(this.update, 1000);
            }
        };

        this.init = function() {
            clearTimeout(this.update);

            countdownClock = $('#next-event');
            if (countdownClock.length > 0) {
                eventTime = Date.parse(countdownClock.data('event-time'));
                eventUrl = countdownClock.data('event-url');
                eventName = countdownClock.data('event-name');
                textToAppend = ' to <a href="' + eventUrl + '">' + eventName + '</a></p>';

                this.update();
            } else {
                eventName = null;
                eventTime = null;
                eventUrl = null;
                textToAppend = null;
            }
        }
    }

    return new EventCountdown();
});