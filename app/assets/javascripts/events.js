(function(){
  $('.readme-link').popover({trigger: 'focus'});

  var refreshHangoutsManagement = function() {
    $.get(window.location.href, function(data) {
      if(data.match('hangouts-details-well')) {
        $('#hg-management').html(data);
        WebsiteOne.renderHangoutButton();
        $('.readme-link').popover({trigger: 'focus'});
        clearInterval(intervalId);
      }
    })
  };
  var intervalId = setInterval(refreshHangoutsManagement, 10000);
})();
