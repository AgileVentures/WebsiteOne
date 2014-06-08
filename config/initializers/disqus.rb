Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development? || Rails.env.test?
    DISQUS_SHORTNAME  = 'agileventures-dev'
  else
    DISQUS_SHORTNAME  = 'agileventures'
  end
end
