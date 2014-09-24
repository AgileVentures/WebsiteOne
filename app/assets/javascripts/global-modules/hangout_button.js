WebsiteOne.renderHangoutButton = function() {
  var placeholderId = 'liveHOA-placeholder',
      hoaPlaceholder = $('#' + placeholderId);

  if ( typeof(gapi) !== 'undefined' && 
       hoaPlaceholder.length > 0 &&
       $('#' + placeholderId + ' iframe').length === 0 ) {

    var title = hoaPlaceholder.data('title'),
        projectId = hoaPlaceholder.data('project-id'),
        eventId = hoaPlaceholder.data('event-id'),
        category = hoaPlaceholder.data('category'),
        hostId = hoaPlaceholder.data('host-id'),
        hangoutId = hoaPlaceholder.data('hangout-id'),
        appId = hoaPlaceholder.data('app-id'),
        callbackUrl = hoaPlaceholder.data('callback-url');

    var startData = JSON.stringify({
      title: title,
      projectId: projectId,
      eventId: eventId,
      category: category,
      hostId: hostId,
      hangoutId: hangoutId,
      callbackUrl: callbackUrl
    });

    gapi.hangout.render(placeholderId, {
        render: 'createhangout',
        topic: title,
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
