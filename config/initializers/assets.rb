WebsiteOne::application.configure do
# ensure svg assets are compiled in production
 config.assets.precompile += %w[ jquery-1.7.js subscriptions.css lolex.js jasmine-jquery.js .svg ]

 # Version of your assets, change this if you want to expire all your assets.
 config.assets.version = '1.0'
end