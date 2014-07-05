WebsiteOne.renderHangoutButton = function() {
  var placeholder = 'liveHOA-placeholder',
      hoa_placeholder = $('#' + placeholder);

  if ( typeof(gapi) != 'undefined' && 
       hoa_placeholder.length > 0 &&
       $('#' + placeholder + ' iframe').length == 0 ) {

    var topic = hoa_placeholder.data('topic'),
        app_id = hoa_placeholder.data('app-id'),
        callback_url = hoa_placeholder.data('callback-url');

    gapi.hangout.render(placeholder, {
        render: 'createhangout',
        topic: topic,
        hangout_type: 'onair',
        initial_apps: [{
          app_id: app_id,
          start_data: callback_url,
          app_type : 'LOCAL_APP'
        }],
        widget_size: 200
    });
  };
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
  }
});

WebsiteOne.loadHangoutsApi();

