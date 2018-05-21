
// read user id from cookie
function readCookie(cookieName) {
 var re = new RegExp('[; ]'+cookieName+'=([^\\s;]*)');
 var sMatch = (' '+document.cookie).match(re);
 if (cookieName && sMatch) return unescape(sMatch[1]);
 return '';
}

// set user id from current user
var userId = readCookie("user_id");

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-47795185-1', 'auto');
// sets google analytics userId
ga('set', 'userId', userId );
ga('send', 'pageview');
// session unification needs to be turned on in google analytics admin to link users before they sign up