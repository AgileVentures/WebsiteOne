WebsiteOne.renderHangoutButton = function() {
  var placeholderId = 'liveHOA-placeholder',
      hoaPlaceholder = $('#' + placeholderId);

  if ( typeof(gapi) !== 'undefined' && 
       hoaPlaceholder.length > 0 &&
       $('#' + placeholderId + ' iframe').length === 0 ) {

    var startData = hoaPlaceholder.data('start-data');

    gapi.hangout.render(placeholderId, {
        render: 'createhangout',
        topic: startData.title,
        hangout_type: 'onair',
        initial_apps: [{
          app_id: hoaPlaceholder.data('app-id'),
          start_data: startData,
          app_type : 'LOCAL_APP'
        }],
        widget_size: 72
    });
  }
};

WebsiteOne.loadHangoutsApi = function() {
  if (typeof(gapi) === 'undefined') {
    $.ajax({
      url: 'https://apis.google.com/js/platform.js',
      dataType: "script",
      cache: true
    }).done(WebsiteOne.renderHangoutButton);
  }
};

WebsiteOne.define('Hangouts', function() {
  return {
    init: function() {
      WebsiteOne.renderHangoutButton();
    }
  };
});

WebsiteOne.loadHangoutsApi();
