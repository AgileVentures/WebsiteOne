WebsiteOne.define('GoogleAnalytics', function() {
  window._gaq = [];
  window._gaq.push(['_setAccount', 'UA-47795185-1'])
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);

  function init() {
    window._gaq.push(['_trackPageview']);
  }
  function() {
    try {
      var trackers = ga.getAll();
      var i, len;
      for (i = 0, len = trackers.length; i < len; i += 1) {
        if (trackers[i].get('trackingId') === 'UA-47795185-1') {
          return trackers[i].get('clientId');
        }
      }
    } catch(e) {}
    return 'false';
  }
  return {
    init: init
  };
});
