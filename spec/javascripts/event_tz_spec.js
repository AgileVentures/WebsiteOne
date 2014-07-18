describe('Events', function () {
    describe('adding user local time to event', function () {

        beforeEach(function () {
            setFixtures('<ul>');
            appendSetFixtures('<li class="occurrence" data-event-time="2014-07-21 09:00 AM UTC" id="correct">Monday, 21st Jul 09:00 am (UTC)</li>');
            appendSetFixtures('<li class="occurrence" data-event-time="2014-07-21 at 09:00AM UTC" id="incorrect">Monday, 21st Jul 09:00 am (UTC)</li>');
            appendSetFixtures('</ul>');
            eventTz.addEventTz();
        });

        it('appends local time if time format is correct', function () {
            expect($('#correct').html()).toMatch(/<p class="eventLocalTime">/);
        });

        it('does not append anything if time format is incorrect', function () {
            expect($('#incorrect').html()).not.toMatch(/<p class="eventLocalTime">/);
        });
    });
});