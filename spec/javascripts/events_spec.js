describe('Events', function () {
    describe('adding user local time to event', function () {

        beforeEach(function () {
            setFixtures('<ul class="occurrence"> \
            <li data-event-time="2014-07-21T09:00:00Z" id="correct">Monday, 21st Jul 09:00 am (UTC)</li> \
            <li data-event-time="2014-07-21 at 09:00AM UTC" id="incorrect">Monday, 21st Jul 09:00 am (UTC)</li> \
            </ul>');
        });

        it('appends local time if time format is correct', function () {
            WebsiteOne.eventTz.addEventTz();
            expect($('#correct').html()).toMatch(/<p class="eventLocalTime">/);
        });

        it('does not append anything if time format is incorrect', function () {
            WebsiteOne.eventTz.addEventTz();
            expect($('#incorrect').html()).not.toMatch(/<p class="eventLocalTime">/);
        });
    });
});