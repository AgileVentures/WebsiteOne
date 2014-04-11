
WSO.define('Projects', function() {
  function init() {
    var hash = window.location.hash;
    hash && $(hash + 's a').tab('show');
    $('html,body').scrollTop($('body').scrollTop());

    $('.nav-tabs a').click(function (e) {
      $(this).tab('show');
      window.location.hash = this.hash.replace("s_list", "");
      $('html,body').scrollTop($('body').scrollTop());
    });

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
  }

  return {
    init: init
  }
});
