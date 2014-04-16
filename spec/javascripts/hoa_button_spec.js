describe('HOA button works with turbolinks', function () {
  var placeholder, apiCall;
  beforeEach(function(done) {
      setFixtures(sandbox({id: 'HOA-placeholder', 'data-hoa-title': 'HOA-title'}));
      apiCall = spyOn(gapi.hangout, 'render');
      // copy-pasted from projects.js ... which won't be necessary when we get Bryan's spike :)
      $.ajax({
          url: 'https://apis.google.com/js/platform.js',
          dataType: "script",
          cache: true
      }).done(function () {
          var button = $('#HOA-placeholder');
          if (button != null && typeof gapi !== "undefined") {
              gapi.hangout.render('HOA-placeholder', {
                  'topic': button.data('hoa-title'),
                  'render': 'createhangout',
                  'hangout_type': 'onair',
                  'initial_apps': [
                      { 'app_type': 'ROOM_APP' }
                  ]
              });
          }
          done();
      });
  });

  it('scrolling causes heights to be calculated', function() {
      expect(apiCall).toHaveBeenCalled();
  });
});
