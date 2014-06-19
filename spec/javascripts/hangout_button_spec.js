describe('WebsiteOne #load_hangout_button', function() {
  var oldGapi;

  beforeEach(function () {
    oldGapi = (typeof(gapi) === 'undefined') ? undefined : gapi;
    reloadScript('hangout_button.js')

    setFixtures(sandbox({
      id: 'liveHOA-placeholder',
      'data-topic': 'Topic',
      'data-app-id': 'id_1234',
      'data-callback-url': 'http://test.com'
    }));

    spyOn(jQuery, 'ajax');
    hangout = jasmine.createSpyObj('hangout', ['render']);
    gapi = { hangout: hangout };
  });

  afterEach(function() {
    gapi = oldGapi;
  });

  describe('Hangout button render', function() {
    it('attaches #HangoutButton function to WebsiteOne global object on first visit to the page', function() {
      expect(WebsiteOne.HangoutButton).toBeDefined();
    });

    it('renders hangout button with correct parameters', function() {
      WebsiteOne.HangoutButton.init();

      expect(hangout.render).toHaveBeenCalledWith( 'liveHOA-placeholder', {
        render: 'createhangout',
        topic: 'Topic',
        hangout_type: 'onair',
        initial_apps: [{
          app_id : 'id_1234',
          start_data :'http://test.com',
          app_type : 'ROOM_APP'
        }],
        widget_size: 200
      });
    });

    it('does not render if placeholder div is not loaded', function() {
      setFixtures('');
      WebsiteOne.HangoutButton.init();
      expect(hangout.render).not.toHaveBeenCalled();
    });
  });

});
