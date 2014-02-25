$(function() {
  function loadHOAButton() {
    var button = $('#HOA-placeholder');
    gapi.hangout.render('HOA-placeholder', {
      'topic': button.data('hoa-title'),
      'render': 'createhangout',
      'hangout_type': 'onair',
      'initial_apps': [
        { 'app_type': 'ROOM_APP' }
      ]
    });
  };
  $(document).ready(loadHOAButton);
  $(document).on('page:load', loadHOAButton);
});