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

    reloadScript('event_countdown.js');

    $(document).trigger('page:load');
  });

  it('should define a new WSO module called "EventCountdown"', function() {
    expect(WSO.EventCountdown).toBeDefined();
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