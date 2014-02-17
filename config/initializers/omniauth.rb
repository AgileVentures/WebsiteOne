Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development? || Rails.env.test?
    ENV['GPLUS_KEY'] = '93078677782-mhhq9ebbmec4rr38adrucvmg3f3kra4d.apps.googleusercontent.com'
    ENV['GPLUS_SECRET'] = 'L3KWw2Q4xYLvJE_gn-NL9ps3'

    ENV['GITHUB_KEY']= 'e2ec6853e573588a381e'
    ENV['GITHUB_SECRET'] = '5c4673f8f49fcb7c3f896b3d5e6a230bedd07cfa'
  end

  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :gplus, ENV['GPLUS_KEY'], ENV['GPLUS_SECRET'],
           :setup => ->(env) {
             if (params = env['rack.session']['omniauth.params']) && params.fetch('youtube', false)
               env['omniauth.strategy'].options[:scope] = 'youtube,userinfo.email'
             end
           }
end
