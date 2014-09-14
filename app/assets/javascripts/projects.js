WebsiteOne.define('Projects', function() {
  return {
    init: function() {

      var hash = window.location.hash;

      if (hash) { 
        $('a[data-hash="'+hash.replace('#','')+'"]').tab('show');
      } 

      $('.nav-tabs a').click(function (e) {
        setHash($(this).data('hash'));
        $(this).tab('show');
      });

      var setHash = function(newHash) {
        window.location.hash = newHash;
      };
    }
  }
});
