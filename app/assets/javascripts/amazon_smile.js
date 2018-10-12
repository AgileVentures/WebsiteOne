const markup = `
  <div id='amznCharityBannerInner'>
    <a target=_blank href='https://smile.amazon.co.uk/ch/1170963-0'>
      <div class='text' height=''>
        <div class='support-wrapper'>
          <div class='support'>
            Support
            <span id='charity-name' style='display: inline-block;'>AgileVentures Charity</span>
          </div>
        </div>
        <p class='when-shop'>When you shop at <b>smile.amazon.co.uk,</b></p>
        <p class='donates'>Amazon Donates</p>
      </div>
    </a>
  </div>
  <style>
#amznCharityBannerInner{
  background-image:url(https://m.media-amazon.com/images/G/02/x-locale/paladin/charitycentral/banner-background-image._CB494422932_.png);
  width:215px;
  height:250px;
  background-position: center top;
}
#amznCharityBannerInner a {
  display:block;
  width:100%;
  height:100%;
  position:relative;
  color:#000;
  text-decoration:none
}
.text {
  position:absolute;
  top:20px;
  left:15px;
  right:15px;
  bottom:100px
}
.support-wrapper {
  overflow:hidden;
  max-height:86px
}
.support {
  font-size: 25px;
  margin-top: 1px;
  margin-bottom: 1px;
  font-family:Arial,sans;
  font-weight:700;
  line-height:23px;
  font-size:20px;
  color:#333;
  text-align:center;
  margin:0;
  padding:0;
  background:0 0
}
.when-shop{
  font-family:Arial,sans;
  font-size:15px;
  font-weight:400;
  line-height:25px;
  color:#333;
  text-align:center;
  margin:0;
  padding:0;
  background:0 0
}
.donates{
  font-family:Arial,sans;
  font-size:15px;
  font-weight:400;
  line-height:21px;
  color:#333;
  text-align:center;
  margin:0;
  padding:0;
    background:0 0
}
  </style>
`
function amazonSmile() {
  var iFrame = document.createElement('iframe');
  iFrame.style.display = 'none';
  iFrame.style.border = "none";
  iFrame.width = 215;
  iFrame.height = 256;
  iFrame.setAttribute && iFrame.setAttribute('scrolling', 'no');
  iFrame.setAttribute('frameborder', '0');
  setTimeout(
    function() {
      var contents = (iFrame.contentWindow) ?
        iFrame.contentWindow :
        (iFrame.contentDocument.document) ?
        iFrame.contentDocument.document :
        iFrame.contentDocument;
      contents.document.open();
      contents.document.write(markup);
      contents.document.close();
      iFrame.style.display = 'block';
    }
  );
  document.getElementById('amznCharityBanner').appendChild(iFrame);
}

window.onload = amazonSmile;
