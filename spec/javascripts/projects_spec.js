describe('WebsiteOne Projects module', function () {

  it('should create a WSO module called "Projects"', function() {
    reloadScript('projects.js');
    expect(window.WSO.Projects).toBeDefined();
  });

  describe('using in-page links', function() {
    var tabCall, windowHashCall;

    beforeEach(function() {
      setFixtures('<div class="nav-tabs" id="moons"><a href="#moon">Man</a></div>');

      reloadScript('projects.js');

      tabCall = spyOn($.fn, 'tab').and.callThrough();
      $(document).trigger('page:load');
    });

    afterEach(function() {
      window.location.hash = "";
    });

    it('should not call jQuery tab("show") when the window has is not present', function() {
      expect(tabCall).not.toHaveBeenCalled();
    });

    it('should call jQuery tab method when the window hash is present', function() {
      window.location.hash = 'moon';
      $(document).trigger('page:load');
      expect(tabCall).toHaveBeenCalledWith('show');
    });

    it('should call the jQuery tab method on each nav-tab link', function() {
      $('.nav-tabs a').click();
      expect(tabCall).toHaveBeenCalledWith('show');
    });
  });

  describe('loading the HOA button', function() {
    var hangout;

    beforeEach(function() {
      hangout = jasmine.createSpyObj('hangout', ['render'])
      var executor = {
        done: function(func) {
          var gapi = { hangout: hangout };
          eval('(' + func.toString() + ')()');
        }
      };
      reloadScript('projects.js');

      this.ajaxSpy = spyOn(jQuery, 'ajax').and.returnValue(executor);
    });

    describe('without the HOA button present', function() {
      beforeEach(function() {
        $(document).trigger('page:load');
      });

      it('should not load the script when the HOA-placeholder is not present', function() {
        expect(this.ajaxSpy).not.toHaveBeenCalled();
      });
    });

    describe('with the HOA button present', function() {
      beforeEach(function () {
        setFixtures(sandbox({
          id: 'HOA-placeholder',
          'data-hoa-title': 'HOA-title'
        }));

        $(document).trigger('page:load');
      });

      it('should define a new WSO module called "Projects"', function() {
        expect(WSO.Projects).toBeDefined();
      });

      it('should call jQuery.ajax to get the google HOA script', function() {
        expect(this.ajaxSpy).toHaveBeenCalledWith({
          url: 'https://apis.google.com/js/platform.js',
          dataType: 'script',
          cache: true
        });
      });

      it('should call the gapi.hangout.render function', function() {
        expect(hangout.render).toHaveBeenCalled();
      });
    });
  });
});
