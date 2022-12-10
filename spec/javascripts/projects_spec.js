describe('projects', function () {

  it('should create a WebsiteOne module called "Projects"', function() {
    reloadScript('Projects');
    expect(window.WebsiteOne.Projects).toBeDefined();
  });

  describe('using in-page links', function() {
    var tabCall, windowHashCall;

    beforeEach(function() {
      setFixtures('<div class="nav-tabs" id="moons"><a href="#moon">Man</a></div>');

      reloadScript('Projects');

      tabCall = spyOn($.fn, 'tab').and.callThrough();
      $(document).trigger('page:load');
    });

    afterEach(function() {
      window.location.hash = "";
    });

    it('should not call jQuery tab("show") when the window hash is not present', function() {
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
});
