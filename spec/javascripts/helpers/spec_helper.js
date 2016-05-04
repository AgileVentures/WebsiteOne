beforeEach(function() {
  // clears the WSO module's state
  WebsiteOne._clear();
  WebsiteOne._newPageLoaded = true;
});

function reloadScript(name) {
  jQuery.ajax({
    async: false,
    dataType: 'script',
    type: 'GET',
    // NOTE: replace is necessary in the new Jasmine... as of 2.4.1!
    url: $('script[src*="/' + name.replace('.js', '.self.js') + '"]').attr('src'),
    success: function (src) { eval(src); }
  });
}
