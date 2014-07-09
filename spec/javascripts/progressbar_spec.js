describe('WebsiteOne ProgressBar module', function() {
  var onSpy;

  function getCalls() {
    return onSpy.calls.all().map(function(call) {
      return {
        eventName: call.args[0],
        callback: call.args[1]
      };
    });
  }

  beforeEach(function() {
    onSpy = spyOn($.fn, 'on');
    reloadScript('progressbar.js');
    $(document).trigger('page:load');
  });

  it('should create a new WebsiteOne module called "ProgressBar"', function() {
    expect(window.WebsiteOne.ProgressBar).toBeDefined();
  });

  describe('jQuery on method arguments', function() {
    it('should call the jQuery on method at least once', function() {
      expect(onSpy.calls.count()).toBeGreaterThan(0);
    });

    it('should attach NProgress.start to "page:fetch"', function() {
      var relevantCalls = getCalls().filter(function(call) {
        return call.eventName === 'page:fetch';
      });
      expect(relevantCalls.length).toEqual(1);
      expect(relevantCalls[0].callback).toEqual(NProgress.start);
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
});
