$(function(){
  var hash = window.location.hash;
  hash && $(hash + 's a').tab('show');
  $('html,body').scrollTop($('body').scrollTop());

  $('.nav-tabs a').click(function (e) {
    $(this).tab('show');
    window.location.hash = this.hash.replace("s_list", "");
    $('html,body').scrollTop($('body').scrollTop());
  });
});
