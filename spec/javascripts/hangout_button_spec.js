describe('hangouts', function(){

  describe('#renderHangoutButton', function() {

    var oldGapi;

    beforeEach(function () {
      oldGapi = (typeof(gapi) === 'undefined') ? undefined : gapi;
      gapi = undefined;
    });

    afterEach(function() {
      gapi = oldGapi;
    });

    describe('WebsiteOne #renderHangoutButton', function() {
      beforeEach(function () {
        setFixtures(sandbox({
          'id': 'liveHOA-placeholder',
          'data-start-data': '{"title":"Topic","category":"category_1234","projectId": "project_1234","eventId":"event_1234","hostId": "host_1234","hangoutId": "hangout_1234","callbackUrl": "http://test.com/hangout_id"}',
          'data-app-id': 'id_12346',
        }));

        hangout = jasmine.createSpyObj('hangout', ['render']);
        gapi = { hangout: hangout };
      });

      describe('renders hangout button', function() {

        it('renders hangout button with correct parameters', function() {
          WebsiteOne.renderHangoutButton();
          var startData = {
            title: 'Topic',
            category: 'category_1234',
            projectId: 'project_1234',
            eventId: 'event_1234',
            hostId: 'host_1234',
            hangoutId: 'hangout_1234',
            callbackUrl: 'http://test.com/hangout_id'
          };

          expect(hangout.render).toHaveBeenCalledWith( 'liveHOA-placeholder', {
            render: 'createhangout',
            topic: 'Topic',
            hangout_type: 'onair',
            initial_apps: [{
              app_id : 'id_12346',
              start_data : startData,
              app_type : 'LOCAL_APP'
            }],
            widget_size: 175
          });
        });
      });

      it('does not render hangout button', function() {
        it('if placeholder div is not loaded', function() {
          setFixtures('');
          WebsiteOne.renderHangoutButton();
          expect(hangout.render).not.toHaveBeenCalled();
        });

        it('if hangouts api is not loaded', function() {
          gapi = undefined;
          WebsiteOne.renderHangoutButton();
          expect(hangout.render).not.toHaveBeenCalled();
        });

        it('if hangout button has been already rendered', function() {
          $('#liveHOA-placeholder').html('<iframe></iframe>')
          WebsiteOne.renderHangoutButton();
          expect(hangout.render).not.toHaveBeenCalled();
        });
      });
    });

    describe('#loadHangoutsApi', function() {

      beforeEach(function () {
        spyOn(jQuery, 'ajax').and.returnValue(
          { done: function(callback) { callback(); } }
        );
      });

      describe('hangouts api is not yet loaded', function() {
        it('loads api library for hangouts', function() {
          WebsiteOne.loadHangoutsApi();

          expect(jQuery.ajax).toHaveBeenCalledWith({
            url: 'https://apis.google.com/js/platform.js',
            dataType: "script",
            cache: true
          });
        });

        it('renders HangoutButton on api load', function() {
          spyOn(WebsiteOne, 'renderHangoutButton');
          WebsiteOne.loadHangoutsApi();
          expect(WebsiteOne.renderHangoutButton).toHaveBeenCalled();
        });
      });

      describe('hangouts api is not yet loaded', function() {
        it('does not load api library if it is already loaded', function() {
          gapi = [];
          WebsiteOne.loadHangoutsApi();
          expect(jQuery.ajax).not.toHaveBeenCalled();
        });
      });
    });
  });

  describe('Hangouts module for WebsiteOne', function() {

    beforeEach(function() {
      reloadScript('hangout_button.js');
    });

    it('defines Hangouts module for WebsiteOne', function() {
      expect(window.WebsiteOne.Hangouts).toBeDefined();
    });

    it('calls #renderHangoutButton', function() {
      spyOn(WebsiteOne, 'renderHangoutButton');

      WebsiteOne.Hangouts.init();
      expect(WebsiteOne.renderHangoutButton).toHaveBeenCalled();
    });

  });
});
