# frozen_string_literal: true

Billy.configure do |c|
  c.cache = true
  c.cache_request_headers = false
  c.ignore_params = ['http://www.google-analytics.com/__utm.gif',
                     'https://r.twimg.com/jot',
                     'http://p.twitter.com/t.gif',
                     'http://p.twitter.com/f.gif',
                     'http://www.facebook.com/plugins/like.php',
                     'https://www.facebook.com/dialog/oauth',
                     'http://cdn.api.twitter.com/1/urls/count.json',
                     'http://disqus.com/embed/comments/',
                     'http://disqus.com/api/3.0/embed/threadDetails.json',
                     'http://disqus.com/api/3.0/discovery/listRelated.json',
                     'https://referrer.disqus.com/juggler/event.js',
                     'https://referrer.disqus.com/juggler/event.gif',
                     'http://disqus.com/api/3.0/discovery/listRelated.json',
                     'http://www.google-analytics.com/r/__utm.gif',
                     'http://disqus.com/api/3.0/timelines/getUnreadCount.json',
                     'https://ssl.google-analytics.com/__utm.gif',
                     'https://accounts.google.com/o/oauth2/postmessageRelay',
                     'https://talkgadget.google.com/talkgadget/_/widget',
                     'https://api.stripe.com/v1/tokens',
                     'https://q.stripe.com/',
                     'https://js.stripe.com/v2/',
                     'https://checkout.stripe.com/api/bootstrap',
                     'https://checkout.stripe.com/api/counter',
                     'https://api.mixpanel.com/track/',
                     'https://checkout.stripe.com/api/outer/manhattan',
                     'https://checkout.stripe.com/api/account/lookup',
                     'https://checkout.stripe.com/',
                     'https://checkout.stripe.com/v3/',
                     'https://checkout.stripe.com/v3/data/locales/en_gb-TXHkb1MWMa7xOQfCZf1DFA.json',
                     'https://checkout.stripe.com/v3/data/locales/en_us-tZLon0RoQY0knbOURjQ.json',
                     'https://checkout.stripe.com/v3/data/locales/en_gb-LkmkoD88BacHIqnX4OXm6w.json',
                     'http://a.disquscdn.com/uploads/users/20073/6166/avatar92.jpg',
                     'https://checkout.stripe.com/v3/BFV9gQSjIO6MQNzvbBr9GA.html',
                     'http://checkout.stripe.com/v3/BFV9gQSjIO6MQNzvbBr9GA.html',
                     'https://checkout.stripe.com/v3/MmIlwJCFOGIGxL58rFJw.html',
                     'http://checkout.stripe.com/v3/MmIlwJCFOGIGxL58rFJw.html',
                     'https://checkout.stripe.com/v3/n57eSArn7ygyGTkooaU7A.html',
                     'http://checkout.stripe.com/v3/n57eSArn7ygyGTkooaU7A.html',
                     'https://checkout.stripe.com/v3/n57eSArn7ygyGTkooaU7A.html',
                     'http://checkout.stripe.com/v3/n57eSArn7ygyGTkooaU7A.html',
                     'http://csi.gstatic.com/csi',
                     'https://csi.gstatic.com/csi']
  c.merge_cached_responses_whitelist = [
    /google-analytics/,
    /disquscdn/,
    /www\.gravatar\.com/,
    %r{youtube\.com/embed/yt_video_id}
  ]
  c.persist_cache = true
  c.cache_path = 'features/support/fixtures/req_cache/'
  c.non_successful_cache_disabled = false
end

Before('@billy_directories') do |scenario, _block|
  Billy.configure do |c|
    feature_name = scenario.feature.name.underscore
    scenario_name = scenario.name.underscore
    c.cache_path = "features/support/fixtures/req_cache/#{feature_name}/"
    Dir.mkdir(Billy.config.cache_path) unless File.exists?(Billy.config.cache_path)
    c.cache_path = "features/support/fixtures/req_cache/#{feature_name}/#{scenario_name}/"
  end
end
