WebsiteOne.define('Documents', function(){
  function init(){
    //alert('this shit is on');
    $('#revisions-anchor').on('click', function(e){
      e.preventDefault();
      //$('#revisions').css('display', 'block');
      $('#revisions').slideToggle('slow');
      $("#arrow").toggleClass("fa-arrow-up").toggleClass("fa-arrow-down");
      //alert('ooh, it\'s ooon!');
    });
  }

  return {
    init: init
  }
});
