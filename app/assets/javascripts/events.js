$('.readme-link').popover({trigger: 'focus'});
WebsiteOne.eventTz = {
    addEventTz: function () {
        var UTCTime;
        var localTime;
        if (new Date().getTimezoneOffset() !== 0) {
            $('ul.occurrence').find('li').each(function () {
                UTCTime = new Date($(this).data('event-time'));
                if (!isNaN(UTCTime.getTime())) {
                    localTime = WebsiteOne.eventTz.getLocalTime(UTCTime);
                    $(this).append(' / <p class="eventLocalTime">' + localTime + '</p>');
                }
            });
        }
    },

    getLocalTime: function (eventTime) {
        var options = {year: "numeric", month: "2-digit", day: "numeric", hour: '2-digit', minute: '2-digit', timeZoneName: 'short'};
        return eventTime.toLocaleString(navigator.language, options);
    }
};

$(WebsiteOne.eventTz.addEventTz);