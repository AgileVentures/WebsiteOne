$(document).ready(function(){
  $('#hg-container').on("mouseenter", ".card", function(){
    address = $(this).find('iframe').attr('src');
    $(this).find('iframe').attr('src', address.replace("autoplay=0", "autoplay=1"))
  });
  $('#hg-container').on("mouseleave", ".card", function(){
    address = $(this).find('iframe').attr('src');
    $(this).find('iframe').attr('src', address.replace("autoplay=1", "autoplay=0"))
  });
});
