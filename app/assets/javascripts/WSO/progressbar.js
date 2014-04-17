//= require ./wso

WSO.define('ProgressBar', function() {
  var firstTimeLoad = true;
  return {
    init: function() {
      if (firstTimeLoad) {
        $(document).on('page:fetch',   NProgress.start);
        $(document).on('page:change',  NProgress.done);
        $(document).on('page:restore', NProgress.remove);
        firstTimeLoad = false;
      }
    }
  }
});
