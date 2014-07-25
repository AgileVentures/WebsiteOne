describe('Events', function () {
    describe('adding user local time to event', function () {

        it('appends local time if data-event-time format is correct', function () {
            setFixtures('<ul id="occurrences"> \
            <li data-event-time="2014-07-21T09:00:00Z" id="correct">Monday, 21st Jul 09:00 am (UTC)</li> \
            </ul>');
            spyOn(Date.prototype, 'getTimezoneOffset').and.returnValue(-180);
            WebsiteOne.eventTz.addEventTz();
            expect($('#correct').html()).toMatch(/<p class="eventLocalTime">/);
        });

        it('appends nothing if data-event-time format is incorrect', function () {
            setFixtures('<ul id="occurrences"> \
            <li data-event-time="2014-07-21 at 09:00AM UTC" id="incorrect">Monday, 21st Jul 09:00 am (UTC)</li> \
            </ul>');
            spyOn(Date.prototype, 'getTimezoneOffset').and.returnValue(-180);
            WebsiteOne.eventTz.addEventTz();
            expect($('#incorrect').html()).not.toMatch(/<p class="eventLocalTime">/);
        });

        it('appends nothing if user is in UTC time zone', function () {
            setFixtures('<ul id="occurrences"> \
            <li data-event-time="2014-07-21T09:00:00Z" id="correct">Monday, 21st Jul 09:00 am (UTC)</li> \
            </ul>');
            spyOn(Date.prototype, 'getTimezoneOffset').and.returnValue(0);
            WebsiteOne.eventTz.addEventTz();
            expect($('body').html()).not.toMatch(/<p class="eventLocalTime">/);
        });
    });
});