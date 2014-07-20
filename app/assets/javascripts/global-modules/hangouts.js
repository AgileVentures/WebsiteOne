WebsiteOne.renderHangoutButton = function() {
  var placeholderId = 'liveHOA-placeholder',
      hoaPlaceholder = $('#' + placeholderId);

  if ( typeof(gapi) !== 'undefined' && 
       hoaPlaceholder.length > 0 &&
       $('#' + placeholderId + ' iframe').length === 0 ) {

    var topic = hoaPlaceholder.data('topic'),
        eventId = hoaPlaceholder.data('event-id'),
        category = hoaPlaceholder.data('category'),
        hangoutId = hoaPlaceholder.data('hangout-id'),
        appId = hoaPlaceholder.data('app-id'),
        callbackUrl = hoaPlaceholder.data('callback-url');

    var startData = JSON.stringify({
      topic: topic,
      eventId: eventId,
      category: category,
      hangoutId: hangoutId,
      callbackUrl: callbackUrl
    });

    gapi.hangout.render(placeholderId, {
        render: 'createhangout',
        topic: topic,
        hangout_type: 'onair',
        initial_apps: [{
          app_id: appId,
          start_data: startData,
          app_type : 'LOCAL_APP'
        }],
        widget_size: 200
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
