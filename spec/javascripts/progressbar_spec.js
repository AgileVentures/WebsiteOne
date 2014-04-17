describe('WSO ProgressBar module', function() {
  var onSpy;
  beforeEach(function() {
    onSpy = spyOn($.fn, 'on');
    reloadScript('progressbar.js');
    $(document).trigger('page:load');
  });

  it('should create a new WSO module called "ProgressBar"', function() {
    expect(window.WSO.ProgressBar).toBeDefined();
  });

  describe('jQuery on method arguments', function() {
    it('should call the jQuery on method at least once', function() {
      expect(onSpy.calls.count()).toBeGreaterThan(0);
    });

    it('should attach NProgress.start to "page:fetch"', function() {
      var call = onSpy.calls.all()[0];
      expect(call.args[0]).toEqual('page:fetch');
      expect(call.args[1]).toEqual(NProgress.start);
    });

    it('should attach NProgress.done to "page:change"', function() {
      var call = onSpy.calls.all()[1];
      expect(call.args[0]).toEqual('page:change');
      expect(call.args[1]).toEqual(NProgress.done);
    });

    it('should attach NProgress.remove to "page:restore"', function() {
      var call = onSpy.calls.all()[2];
      expect(call.args[0]).toEqual('page:restore');
      expect(call.args[1]).toEqual(NProgress.remove);
    });
  });

  it('should not trigger the event registration more than once', function() {
    $(document).trigger('page:load');
    expect(onSpy.calls.count()).toEqual(3);
  });
});
