var disqus_div = $('#disqus_thread'),
    disqus_shortname = disqus_div.data('disqus-shortname'),
    disqus_identifier = disqus_div.data('disqus-identifier'),
    disqus_title = disqus_div.data('disqus-title'),
    disqus_url = disqus_div.data('disqus-url');

//DISQUS EMBED SCRIPT
var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
(document.getElementsByTagName('head')[0] || 
 document.getElementsByTagName('body')[0]).appendChild(dsq);

