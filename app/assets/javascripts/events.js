WebsiteOne.define('Events', function() {
  return {
    init: function() {
      WebsiteOne.renderHangoutButton();
    }
  }
});

WebsiteOne.loadHangoutsApi();
