
beforeEach(function() {
  // clears the WSO module's state
  WSO._clear();
  WSO._newPageLoaded = true;
});

function reloadScript(name) {
  jQuery.ajax({
    url: $('script[src*="/' + name + '"]').attr('src'),
    success: function(src) { eval(src); },
    async: false
  });
}
