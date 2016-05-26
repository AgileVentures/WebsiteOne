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
                     "http://disqus.com/api/3.0/timelines/getUnreadCount.json",
                     "https://ssl.google-analytics.com/__utm.gif",
                     "https://accounts.google.com/o/oauth2/postmessageRelay",
                     "https://talkgadget.google.com/talkgadget/_/widget",
                     'https://api.stripe.com/v1/tokens',
                     'https://q.stripe.com/',
                     'https://js.stripe.com/v2/',
                     'https://checkout.stripe.com/api/bootstrap',
                     'https://checkout.stripe.com/api/counter',
                     'https://api.mixpanel.com/track/',
                     'https://checkout.stripe.com/api/outer/manhattan',
                     'https://checkout.stripe.com/api/account/lookup',
                     'https://checkout.stripe.com/',
                     'https://checkout.stripe.com/v3/zLFRiPN3qLIm2QDkJZxBw.html',
                     'https://checkout.stripe.com/v3/data/locales/en_gb-TXHkb1MWMa7xOQfCZf1DFA.json',
                     'http://a.disquscdn.com/uploads/users/20073/6166/avatar92.jpg',
                     'https://checkout.stripe.com/v3/HciOQ9KeXgLe2kL0jWvVCg.html',
                     'https://checkout.stripe.com/v3/yiWszEIcz0H0K2eT1bmgQ.html',
                     'http://csi.gstatic.com/csi',
                     'https://csi.gstatic.com/csi',
  ]
  c.merge_cached_responses_whitelist = [
      /google\-analytics/,
      /disquscdn/,
      /www\.gravatar\.com/,
      /youtube\.com\/embed\/yt_video_id/,
  ]
  c.persist_cache = true
  c.non_successful_cache_disabled = false
  c.cache_path = 'features/support/fixtures/req_cache/'
end

