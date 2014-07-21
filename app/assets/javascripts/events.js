$('.readme-link').popover({trigger: 'focus'});
WebsiteOne.eventTz = {
    addEventTz: function() {
        $('ul.occurrence').find('li').each(function() {
            var UTCTime = new Date($(this).data('event-time'));
            console.log(UTCTime);
            if (!isNaN(UTCTime.getTime())) {
                var localTime = WebsiteOne.eventTz.getLocalTime(UTCTime);
                $(this).append(' / <p class="eventLocalTime">' + localTime + '</p>');
            }
        });
    },

    getLocalTime: function(eventTime) {
        var options = {year: "numeric", month: "2-digit", day: "numeric", hour: '2-digit', minute: '2-digit', timeZoneName: 'short'};
        return eventTime.toLocaleString(navigator.language, options);
    }
};

$(WebsiteOne.eventTz.addEventTz);