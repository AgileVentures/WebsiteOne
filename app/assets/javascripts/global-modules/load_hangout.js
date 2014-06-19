 WebsiteOne.loadHangouts = function(renderHangoutCallback) {
   if (typeof(gapi) === 'undefined') {
     $.ajax({
       url: 'https://apis.google.com/js/platform.js',
       dataType: "script",
       cache: true
     }).done(renderHangoutCallback);
   } else {
     renderHangoutCallback();
   }
};
