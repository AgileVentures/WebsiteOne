Billy.configure do |c|
  c.cache = true
  c.cache_request_headers = false
  c.ignore_params = ["http://www.google-analytics.com/__utm.gif",
                     "https://r.twimg.com/jot",
                     "http://p.twitter.com/t.gif",
                     "http://p.twitter.com/f.gif",
                     "http://www.facebook.com/plugins/like.php",
                     "https://www.facebook.com/dialog/oauth",
                     "http://cdn.api.twitter.com/1/urls/count.json",
                     "http://disqus.com/embed/comments/",
                     "http://disqus.com/api/3.0/embed/threadDetails.json",
                     "http://disqus.com/api/3.0/discovery/listRelated.json",
                     "https://referrer.disqus.com/juggler/event.js",
                     "https://referrer.disqus.com/juggler/event.gif",
                     "http://disqus.com/api/3.0/discovery/listRelated.json",
                     "http://www.google-analytics.com/r/__utm.gif",

  ]
  c.merge_cached_responses_whitelist = [/www\.google\-analytics\.com/]
  c.persist_cache = true
  c.non_successful_cache_disabled = false
  c.cache_path = 'features/support/fixtures/req_cache/'
end