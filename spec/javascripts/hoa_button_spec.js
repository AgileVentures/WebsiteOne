
var gapi = (typeof gapi === "undefined") ? {
  hangout: {
    render: function() {
      // dummy
    }
  }
} : gapi;

describe('HOA button works with turbolinks', function () {
  var placeholder, apiCall;
  beforeEach(function () {
    setFixtures(sandbox({id: 'HOA-placeholder', 'data-hoa-title': 'HOA-title'}));
    placeholder = $('#HOA-placeholder');
    apiCall = spyOn(gapi.hangout, 'render');
    $(document).trigger('page:load');
  });

  it('scrolling causes heights to be calculated', function() {
    expect(apiCall).toHaveBeenCalled();
  });
});
