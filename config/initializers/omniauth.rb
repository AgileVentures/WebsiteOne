Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :gplus, ENV['GPLUS_KEY'], ENV['GPLUS_SECRET']
end
