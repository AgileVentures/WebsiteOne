var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var players = {}
var iframe
var currentPlayerId = null
var currentPlayer = null

$('#hg-container').on("mouseenter", ".card", function () {
  if (currentPlayerId && players[currentPlayerId]) {
    players[currentPlayerId].pauseVideo();
  }
  currentPlayerId = $(this).find('iframe').attr('id');
  iframe = document.getElementById(currentPlayerId);

  if (!players[currentPlayerId]) {
    players[currentPlayerId] = new YT.Player(iframe, {
      playerVars: { 'autoplay': 1 },
      events: { 'onReady': onPlayerReady }
    });
  }
  else if (currentPlayerId && players[currentPlayerId]) {
    players[currentPlayerId].playVideo();
  } else {
    console.log("player not ready")
  }
});
function onPlayerReady(event) {
  event.target.playVideo()
}

function onYouTubeIframeAPIReady() {
}