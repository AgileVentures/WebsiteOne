WebsiteOne.define('Projects', function() {
  var setHash = function(newHash) {
    window.location.hash = newHash;
  };

  var init = function() {
    var hash = window.location.hash;

    if (hash) { 
      $('a[data-hash="'+hash.replace('#','')+'"]').tab('show');
    } 

    $('.nav-tabs a').click(function (e) {
      setHash($(this).data('hash'));
      $(this).tab('show');
    });
  };

  return {
    init: init
  };
});
