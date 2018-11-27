$(document).ready(function(){
  var address = "none";
  $('#hg-container').on("mouseenter", ".card", function(){
    address = $(this).find('iframe').attr('src');
    $(this).find('iframe').attr('src',address+'&autoplay=1');
  })
  $('#hg-container').on("mouseleave", ".card", function(){
    address = $(this).find('iframe').attr('src');
    $(this).find('iframe').attr('src',address.slice(0, -11));
  });
});

//TODO it's not working for newly loaded hangout cards
