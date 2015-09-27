WebsiteOne.runOnce("AnimatedPages", function() {
  function animatePageIn() {
    var mainAndFooter = $("#main, #footer");
    mainAndFooter.hide();
    mainAndFooter.fadeIn(300);
  }

  // animate in pages
  $(document).on('page:change', animatePageIn);
  $(document).on('page:restore', animatePageIn);
});
