var gapi = (typeof gapi === "undefined") ? {
  hangout: {
    render: function() {
      // dummy
    }
  }
} : gapi;

describe('WebsiteOne Projects module', function () {
  beforeEach(function () {
    this.apiCall = spyOn(gapi.hangout, 'render');
    setFixtures(sandbox({id: 'HOA-placeholder', 'data-hoa-title': 'HOA-title'}));

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
