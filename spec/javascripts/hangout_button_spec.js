describe('WebsiteOne #load_hangout_button', function() {

  beforeEach(function () {
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

  describe('Hangout button render', function() {
    it('attaches #load_hangout_button to WebsiteOne', function() {
      expect(WebsiteOne.load_hangout_button).toBeDefined();
    });

    it('renders hangout button with correct parameters', function() {
      WebsiteOne.load_hangout_button();

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

    it('does not render if api is not loaded', function() {
      gapi = undefined;
      expect(hangout.render).not.toHaveBeenCalled();
    });

    it('does not render if placeholder div is not loaded', function() {
      setFixtures('');
      expect(hangout.render).not.toHaveBeenCalled();
    });
  });

  describe('load hangout api', function() {

    it('loads api library for hangouts', function() {
      gapi = undefined;
      jQuery.ajax.and.callThrough();

      load_gapi();

      expect(jQuery.ajax).toHaveBeenCalledWith({
        url: 'https://apis.google.com/js/platform.js',
        dataType: "script",
        cache: true
      });
    });

    it('does not load api library if it is already loaded', function() {
      gapi = [];
      load_gapi();
      expect(jQuery.ajax).not.toHaveBeenCalled();
    });
  });
});

