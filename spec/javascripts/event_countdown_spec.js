describe('Event Countdown', function () {

    var url, name, time;

    beforeEach(function () {
        url = 'https://coming.home';
        name = 'Homecoming';
        var now = new Date();
        time = new Date(now.getTime() + 60 * 60 * 1000);

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

    describe('init', function () {
        it('should clear any current instance of setTimeout', function () {
            expect(this.clearTimeout).toHaveBeenCalledWith(this.update)
        });

        describe('when the clock is present', function () {
            it('parses the event time, url, and name from the html', function () {
                this.data.calls.reset();
                WSO.EventCountdown.init();

                expect(this.dateParse).toHaveBeenCalledWith(this.countdownClock.data);
                expect(this.data).toHaveBeenCalledWith(
                    [jasmine.any(Object), "event-time"],
                    [jasmine.any(Object), "event-url"],
                    [jasmine.any(Object), "event-name"]
                );
            });

            it('calls update', function() {
                expect(this.update).toHaveBeenCalled()
            });
        });
        describe('when the clock is absent', function () {
            it('test the effect of the null values elsewhere?');
        });
    });

    xdescribe('the Countdown Clock', function () {
        beforeEach(function () {
            this.clock = WSO.EventCountdown.getCountdownClock();
        });

        it('should find the countdown clock', function () {
            expect(this.clock.length).toEqual(1);
        });

        it('should display a link to the event', function () {
            expect(this.clock.find('a[href="' + url + '"]'));
        });

        it('should have the link text set to the event name', function () {
            expect(this.clock.find('a').text()).toMatch(new RegExp(name, 'i'));
        });

        // TODO: write specs for checking event-time updates
    });
});