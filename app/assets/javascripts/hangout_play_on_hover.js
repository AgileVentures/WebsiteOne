$(document).ready(function(){
  var nowPlaying = "none";
  $('.card').hover(function(){
    nowPlaying = $(this).find('iframe').attr('src');
    $(this).find('iframe').attr('src',nowPlaying+'&autoplay=1');
  }, function(){
    $(this).find('iframe').attr('src',nowPlaying);
  });
});

//TODO it's not working for newly loaded hangout cards
