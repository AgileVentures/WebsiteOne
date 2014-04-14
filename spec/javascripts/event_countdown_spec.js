describe('Event Countdown', function() {

  var url, name, time;

  beforeEach(function() {
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

  it('should define a new WSO module called "EventCountdown"', function() {
    expect(WSO.EventCountdown).toBeDefined();
  });

  describe('._init', function() {
      it('should clear any current instance of setTimeout', function() {
          expect(this.clearTimeout).toHaveBeenCalledWith(this.update)
      });

      describe('when the clock is present', function() {
          it('parses the event time from the html', function() {
              expect(this.data).toHaveBeenCalledWith('event-time');
              expect(this.dateParse).toHaveBeenCalledWith(this.countdownClock.data)
          });

          it('parses the event url from the html', function() {
              expect(this.data).toHaveBeenCalledWith('event-url');
          });

          it('parses the event name from the html', function() {
              expect(this.data).toHaveBeenCalledWith('event-name');
          });

          it('calls update', function() {
              expect(this.update).toHaveBeenCalled()
          });
      });
  });

  describe('the Countdown Clock', function() {
    beforeEach(function() {
      this.clock = WSO.EventCountdown.getCountdownClock();
    });

    it('should find the countdown clock', function() {
      expect(this.clock.length).toEqual(1);
    });

    it('should display a link to the event', function() {
      expect(this.clock.find('a[href="' + url + '"]'));
    });

    it('should have the link text set to the event name', function() {
      expect(this.clock.find('a').text()).toMatch(new RegExp(name, 'i'));
    });

    // TODO: write specs for checking event-time updates
  });
});