//= require ./wso

WSO.define('EventCountdown', function () {

    function EventCountdown() {
        var countdownClock, eventName, eventTime, eventUrl, textToAppend;
        var self = this;

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
                    tmp += self.format(timeInHours) + ':';
                }

                countdownClock.html(tmp + self.format(timeInMins % 60) +
                    ':' + self.format(timeInSeconds % 60) +
                    textToAppend);
                setTimeout(self.update, 1000);
            }
        };

        this.init = function() {
            clearTimeout(self.update);

            countdownClock = $('#next-event');
            if (countdownClock.length > 0) {
                eventTime = Date.parse(countdownClock.data('event-time'));
                eventUrl = countdownClock.data('event-url');
                eventName = countdownClock.data('event-name');
                textToAppend = ' to <a href="' + eventUrl + '">' + eventName + '</a></p>';

                self.update();
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
