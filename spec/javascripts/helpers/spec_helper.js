
beforeEach(function() {
  // clears the WSO module's state
  WebsiteOne._clear();
  WebsiteOne._newPageLoaded = true;
});

function reloadScript(name) {
  jQuery.ajax({
    url: $('script[src*="/' + name + '"]').attr('src'),
    success: function(src) { eval(src); },
    async: false
  });
}
