Billy.configure do |c|
  c.cache = true
  c.cache_request_headers = false
  c.ignore_params = ["http://www.google-analytics.com/__utm.gif",
                     "https://r.twimg.com/jot",
                     "http://p.twitter.com/t.gif",
                     "http://p.twitter.com/f.gif",
                     "http://www.facebook.com/plugins/like.php",
                     "https://www.facebook.com/dialog/oauth",
                     "http://cdn.api.twitter.com/1/urls/count.json"]
  c.persist_cache = true
  c.non_successful_cache_disabled = false
  c.cache_path = 'features/support/fixtures/req_cache/'
end