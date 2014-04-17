describe('WSO FlashMessages module', function() {
  var timeoutSpy;

  beforeEach(function() {
    // immediately execute timeouts
    timeoutSpy = spyOn(window, 'setTimeout').and.callFake(function(func) {
      func();
    });

    reloadScript('flash.js');
  });

  it('should create a new WSO module called "FlashMessages"', function() {
    expect(window.WSO.FlashMessages).toBeDefined();
  });

  describe('with a flash message in the page', function() {
    var fadeSpy;

    beforeEach(function() {
      fadeSpy = spyOn($.fn, 'fadeTo').and.callThrough();
      setFixtures(sandbox({
        id: 'flash-container'
      }));
      $(document).trigger('page:load');
    });

    it('should trigger the flash reaction event after 5 seconds', function() {
      // it appears jasmine uses window.setTimeout internally, so run this again manually
      $(document).trigger('page:load');
      // checks second argument to window.setTimeout
      expect(timeoutSpy.calls.mostRecent().args[1]).toEqual(5000);
    });

    it('should cause the flash to fade over 0.5 seconds', function() {
      expect(fadeSpy).toHaveBeenCalled();
    });
  });
});
