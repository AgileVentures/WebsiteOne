describe('Event Countdown', function () {

    var url, name;

    beforeEach(function () {
        url = 'https://coming.home';
        name = 'Homecoming';

        setFixtures(sandbox({
            id: 'next-event',
            'data-event-time': '',
            'data-event-url': url,
            'data-event-name': name
        }));
        this.countdownClock = $('#next-event');
        this.data = spyOn(jQuery, 'data').and.callThrough();


        reloadScript('event_countdown.js');
        this.update = spyOn(WSO.EventCountdown, 'update').and.callThrough();
        this.clearTimeout = spyOn(window, 'clearTimeout').and.callThrough();
        this.dateParse = spyOn(Date, 'parse').and.callThrough();
        $(document).trigger('page:load');
    });

    it('should define a new WSO module called "EventCountdown"', function () {
        expect(WSO.EventCountdown).toBeDefined();
    });

    describe('init()', function () {
        it('should clear any current instance of setTimeout', function () {
            expect(this.clearTimeout).toHaveBeenCalledWith(this.update)
        });

        describe('when the clock is present', function () {
            it('parses the time into a date object', function () {
                this.data.and.returnValue('fake date object');
                WSO.EventCountdown.init();

                expect(this.dateParse).toHaveBeenCalledWith('fake date object');
            });
            it('parses the event time, url, and name from the html', function () {
                this.data.calls.reset();
                WSO.EventCountdown.init();

                expect(this.data).toHaveBeenCalledWith(jasmine.any(Object), "event-time");
                expect(this.data).toHaveBeenCalledWith(jasmine.any(Object), "event-url");
                expect(this.data).toHaveBeenCalledWith(jasmine.any(Object), "event-name");
            });

            it('calls update', function () {
                this.update.calls.reset();
                WSO.EventCountdown.init();
                expect(this.update).toHaveBeenCalled()
            });
        });
        describe('when the clock is absent', function () {
            it('does not bother parsing the DOM', function () {
                this.data.calls.reset();
                setFixtures(); // clears all html
                WSO.EventCountdown.init();
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
            WSO.EventCountdown.init();
            floor = spyOn(Math, 'floor').and.callThrough();
            WSO.EventCountdown.update();
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
            WSO.EventCountdown.init();
            WSO.EventCountdown.update();
            expect(regex.test(this.countdownClock.text())).toBeTruthy()
        });

        it('otherwise only displays minutes and seconds in the countdown', function () {
            var regex = /^\d{2}:\d{2} /;
            expect(regex.test(this.countdownClock.text())).toBeTruthy()
        });

        it('displays a banner after it has started', function () {
            floor.and.returnValue(0);
            WSO.EventCountdown.update();
            expect(this.countdownClock.text()).toEqual('Homecoming has started')
        });

        it('recalculates the time every second unless the event has already started', function () {
            var setTimeout = spyOn(window, 'setTimeout');
            WSO.EventCountdown.update();
            expect(setTimeout).toHaveBeenCalledWith(this.update, 1000);
            floor.and.returnValue(0);
            setTimeout.calls.reset();
            WSO.EventCountdown.update();
            expect(setTimeout).not.toHaveBeenCalled()
        });

    });

    describe('format()', function() {
        it('pads numbers less than 10 with a zero', function() {
            expect(WSO.EventCountdown.format(9)).toEqual('09');
            expect(WSO.EventCountdown.format(0)).toEqual('00');
        });

        it('converts type from number to string', function() {
            expect(WSO.EventCountdown.format(9)).toEqual('09');
            expect(WSO.EventCountdown.format(10)).toEqual('10');
            expect(WSO.EventCountdown.format(-2)).toEqual('-2'); // less bad at least

        });
    });
});