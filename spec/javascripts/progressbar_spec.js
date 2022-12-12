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
    reloadModule('ProgressBar');
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
      var relevantCalls = getCalls().filter(function(call) {
        return call.eventName === 'page:change';
      });
      expect(relevantCalls.length).toEqual(1);
      expect(relevantCalls[0].callback).toEqual(NProgress.done);
    });

    it('should attach NProgress.remove to "page:restore"', function() {
      var relevantCalls = getCalls().filter(function(call) {
        return call.eventName === 'page:restore';
      });
      expect(relevantCalls.length).toEqual(1);
      expect(relevantCalls[0].callback).toEqual(NProgress.remove);
    });
  });
});
