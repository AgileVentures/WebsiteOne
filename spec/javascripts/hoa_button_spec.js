
var oldGapi = gapi;

describe('HOA button works with turbolinks', function () {
  var placeholder, apiCall;
  beforeEach(function () {
    gapi = {
      hangout: {
        render: function() {
          // dummy
        }
      }
    };
    setFixtures(sandbox({id: 'HOA-placeholder', 'data-hoa-title': 'HOA-title'}));
    placeholder = $('#HOA-placeholder');
    apiCall = spyOn(gapi.hangout, 'render');
    $(document).trigger('page:load');
  });

  afterEach(function() {
    gapi = oldGapi;
  });

  it('scrolling causes heights to be calculated', function() {
    expect(apiCall).toHaveBeenCalled();
  });
});
