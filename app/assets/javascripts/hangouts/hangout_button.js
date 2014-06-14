$.ajax({
  url: 'https://apis.google.com/js/platform.js',
  dataType: "script",
  cache: true
}).done(function () {
  var placeholder = 'liveHOA-placeholder',
  hoa_placeholder = $('#' + placeholder),
  topic = hoa_placeholder.data('topic'),
  app_id = hoa_placeholder.data('app-id'),
  callback_url = hoa_placeholder.data('callback-url');

  var status = gapi.hangout.render(placeholder, {
    'render': 'createhangout',
    'topic': topic,
    'hangout_type': 'onair',
    'initial_apps': [{'app_id' : app_id,
      'start_data' :callback_url,
      'app_type' : 'ROOM_APP'
    }],
    'widget_size': 200
  });
});
