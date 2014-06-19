describe('#loadHangouts', function() {

  var oldGapi;

  beforeEach(function () {
    oldGapi = (typeof(gapi) === 'undefined') ? undefined : gapi;
    gapi = undefined;

    reloadScript('load_hangout.js');

    spyOn(jQuery, 'ajax').and.returnValue(
      {
      done: function(renderHangoutCallback) {
        renderHangoutCallback();
      }
    });
  });

  afterEach(function() {
    gapi = oldGapi;
  });

  it('attaches #loadHangouts function to WebsiteOne global object', function() {
    expect(WebsiteOne.loadHangouts).toBeDefined();
  });

  describe('load hangouts api', function() {
    it('loads api library for hangouts', function() {
      WebsiteOne.loadHangouts(function(){});

      expect(jQuery.ajax).toHaveBeenCalledWith({
        url: 'https://apis.google.com/js/platform.js',
        dataType: "script",
        cache: true
      });
    });

    it('does not load api library if it is already loaded', function() {
      gapi = [];
      WebsiteOne.loadHangouts(function(){});
      expect(jQuery.ajax).not.toHaveBeenCalled();
    });
  });

  describe('renders Hangout button', function() {
    beforeEach(function() {
      renderHangoutCallback = jasmine.createSpy();
    });

    it('renders HangoutButton on api load', function() {
      WebsiteOne.loadHangouts(renderHangoutCallback);
      expect(renderHangoutCallback).toHaveBeenCalled();
    });

    it('renders HangoutButton if api is already loaded', function() {
      gapi = [];
      WebsiteOne.loadHangouts(renderHangoutCallback);
      expect(renderHangoutCallback).toHaveBeenCalled();
    });
  });
});
