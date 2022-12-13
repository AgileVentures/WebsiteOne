describe('Event Countdown', function () {

    var url, name;

    beforeEach(function () {
        url = 'https://coming.home';
        name = 'Homecoming';
        duration = 30;

        setFixtures(sandbox({
            id: 'next-event',
            'data-event-time': '',
            'data-event-duration': duration,
            'data-event-url': url,
            'data-event-name': name
        }));
        this.countdownClock = $('#next-event');
        this.data = spyOn(jQuery, 'data').and.callThrough();


        reloadModule('EventCountdown');
        this.update = spyOn(WebsiteOne.EventCountdown, 'update').and.callThrough();
        this.clearTimeout = spyOn(window, 'clearTimeout').and.callThrough();
        this.dateParse = spyOn(Date, 'parse').and.callThrough();
        $(document).trigger('page:load');
    });

    it('should define a new WebsiteOne module called "EventCountdown"', function () {
        expect(WebsiteOne.EventCountdown).toBeDefined();
    });

    describe('init()', function () {
        it('should clear any current instance of setTimeout', function () {
            expect(this.clearTimeout).toHaveBeenCalledWith(this.update)
        });

        describe('when the clock is present', function () {
            it('parses the time into a date object', function () {
                this.data.and.returnValue('fake date object');
                WebsiteOne.EventCountdown.init();

                expect(this.dateParse).toHaveBeenCalledWith('fake date object');
            });
            it('parses the event time, url, and name from the html', function () {
                this.data.calls.reset();
                WebsiteOne.EventCountdown.init();

                expect(this.data).toHaveBeenCalledWith(this.countdownClock[0], "event-time");
                expect(this.data).toHaveBeenCalledWith(this.countdownClock[0], "event-url");
                expect(this.data).toHaveBeenCalledWith(this.countdownClock[0], "event-name");
                expect(this.data).toHaveBeenCalledWith(this.countdownClock[0], "event-duration");
            });

            it('calls update', function () {
                this.update.calls.reset();
                WebsiteOne.EventCountdown.init();
                expect(this.update).toHaveBeenCalled()
            });
        });
        describe('when the clock is absent', function () {
            it('does not bother parsing the DOM', function () {
                this.data.calls.reset();
                setFixtures(); // clears all html
                WebsiteOne.EventCountdown.init();
                expect(this.data).not.toHaveBeenCalled()
            });
        });
    });

    describe('update(): it calculates the time to the event', function () {
        var event, floor;

        beforeEach(function () {
            event = new Date;
            event.setMinutes(event.getMinutes() + 30); // event in 30 mins
            this.dateParse.and.returnValue(event);
            WebsiteOne.EventCountdown.init();
            floor = spyOn(Math, 'floor').and.callThrough();
            WebsiteOne.EventCountdown.update();
        });

        it('in seconds', function () {
            expect(floor.calls.argsFor([0])).toBeCloseTo(1800, 1);  // +/- 10%
        });

        it('in minutes', function () {
            expect(floor.calls.argsFor([1])).toBeCloseTo(30, 1)
        });

        it('in hours', function () {
            expect(floor.calls.argsFor([2])).toBeCloseTo(0.5, 1)
        });

        it('displays hours in the countdown only if there are any', function () {
            var regex = /^\d{2}:\d{2}:\d{2} /;
            expect(regex.test(this.countdownClock.text())).toBeFalsy();
            event.setMinutes(event.getMinutes() + 60); // event in 90 mins
            this.dateParse.and.returnValue(event);
            WebsiteOne.EventCountdown.init();
            WebsiteOne.EventCountdown.update();
            expect(regex.test(this.countdownClock.text())).toBeTruthy()
        });

        it('otherwise only displays minutes and seconds in the countdown', function () {
            var regex = /^\d{2}:\d{2} /;
            expect(regex.test(this.countdownClock.text())).toBeTruthy()
        });

        it('displays a banner after it has started', function () {
            floor.and.returnValue(0);
            WebsiteOne.EventCountdown.update();
            expect(this.countdownClock.text()).toEqual('Homecoming is live!')
        });

        it('recalculates the time every second', function () {
            var setTimeout = spyOn(window, 'setTimeout');
            WebsiteOne.EventCountdown.update();
            expect(setTimeout).toHaveBeenCalledWith(this.update, 1000);
        });

        it('reports that the event has ended after duration is up and does not recalculate time', function() {
          var setTimeout = spyOn(window, 'setTimeout');
          event.setMinutes(event.getMinutes() - 60); // event just ended
          WebsiteOne.EventCountdown.update();
          expect(setTimeout).not.toHaveBeenCalled()
          expect(this.countdownClock.text()).toEqual('Homecoming has ended.')
        });

        it('should still work calling it through the window object', function() {
            // implicitly binds the call to the window object
            expect(this.update).not.toThrow();
        });
    });

    describe('format()', function() {
        it('pads numbers less than 10 with a zero', function() {
            expect(WebsiteOne.EventCountdown.format(9)).toEqual('09');
            expect(WebsiteOne.EventCountdown.format(0)).toEqual('00');
        });

        it('converts type from number to string', function() {
            expect(WebsiteOne.EventCountdown.format(9)).toEqual('09');
            expect(WebsiteOne.EventCountdown.format(10)).toEqual('10');
            expect(WebsiteOne.EventCountdown.format(-2)).toEqual('-2'); // less bad at least

        });
    });
});
