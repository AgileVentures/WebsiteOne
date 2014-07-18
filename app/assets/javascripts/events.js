$('.readme-link').popover({trigger: 'focus'});
var eventTz = {
    addEventTz: function() {

        $('li.occurrence').each(function() {
            var UTCTime = new Date($(this).data('event-time'));
            if (!isNaN(UTCTime.getTime())) {
                var localTime = eventTz.getLocalTime(UTCTime);
                $(this).append(' / <p class="eventLocalTime">' + localTime + '</p>');
            }
        });
    },

    getLocalTime: function(eventTime) {
        var options = {year: "numeric", month: "2-digit", day: "numeric", hour: '2-digit', minute: '2-digit', timeZoneName: 'short'};
        return eventTime.toLocaleString(navigator.language, options);
    }
};

$(eventTz.addEventTz);