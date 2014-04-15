var gapi = (typeof gapi === "undefined") ? {
  hangout: {
    render: function() {
      // dummy
    }
  }
} : gapi;

describe('WebsiteOne Projects module', function () {
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
    beforeEach(function () {
      this.apiCall = spyOn(gapi.hangout, 'render');
      setFixtures(sandbox({
        id: 'HOA-placeholder',
        'data-hoa-title': 'HOA-title'
      }));

      reloadScript('projects.js');

      $(document).trigger('page:load');
    });

    it('should define a new WSO module called "Projects"', function() {
      expect(WSO.Projects).toBeDefined();
    });

    it('scrolling causes heights to be calculated', function() {
      expect(this.apiCall).toHaveBeenCalled();
    });
  });
});
