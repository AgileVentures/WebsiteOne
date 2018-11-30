var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var players = {}
var player
var currentPlayerId = null
var currentPlayer = null

$(document).ready(function(){
  $('#hg-container').on("mouseenter", ".card", function(){
    currentPlayerId = $(this).find('iframe').attr('id');
    player = $(this).find('iframe')[0];

    if (!players[currentPlayerId]){
      players[currentPlayerId] = new YT.Player(player, {
        playerVars: { 'autoplay': 1 },
        events: {'onReady': onPlayerReady }
      });
    }
    else{
      currentPlayer = players[currentPlayerId]
      currentPlayer.playVideo();
    }
  });

  $('#hg-container').on("mouseleave", ".card", function(){
    currentPlayer.pauseVideo();
    currentPlayer = null;
  });
});
function onPlayerReady(event) {
  currentPlayer = players[currentPlayerId]
  currentPlayer.seekTo(10);
  currentPlayer.playVideo();
}
