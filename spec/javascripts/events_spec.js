describe('Events', function () {
    describe('adding user local time to event', function () {

        beforeEach(function () {
            setFixtures('<ul class="occurrence"> \
            <li data-event-time="2014-07-21T09:00:00Z" id="correct">Monday, 21st Jul 09:00 am (UTC)</li> \
            <li data-event-time="2014-07-21 at 09:00AM UTC" id="incorrect">Monday, 21st Jul 09:00 am (UTC)</li> \
            </ul>');
        });

        it('appends nothing if user is in UTC time zone', function () {
            spyOn(Date.prototype, 'getTimezoneOffset').and.returnValue(0);
            WebsiteOne.eventTz.addEventTz();
            expect($('body').html()).not.toMatch(/<p class="eventLocalTime">/);
        });

        it('appends local time if time format is correct', function () {
            spyOn(Date.prototype, 'getTimezoneOffset').and.returnValue(-180);
            WebsiteOne.eventTz.addEventTz();
            expect($('#correct').html()).toMatch(/<p class="eventLocalTime">/);
        });

        it('appends nothing if time format is incorrect', function () {
            spyOn(Date.prototype, 'getTimezoneOffset').and.returnValue(-180);
            WebsiteOne.eventTz.addEventTz();
            expect($('#incorrect').html()).not.toMatch(/<p class="eventLocalTime">/);
        });
    });
});