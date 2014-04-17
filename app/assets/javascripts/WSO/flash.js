//= require ./wso

WSO.define('FlashMessages', function() {
  return {
    init: function() {
      var flash = $('#flash-container');
      if (flash.length > 0) {
        window.setTimeout(function() {
          flash.fadeTo(500, 0).slideUp(500, function(){
            $(this).remove();
          });
        }, 5000);
      }
    }
  }
});
