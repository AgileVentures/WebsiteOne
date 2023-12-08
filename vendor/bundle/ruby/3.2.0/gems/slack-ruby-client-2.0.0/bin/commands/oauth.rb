# frozen_string_literal: true
# This file was auto-generated by lib/tasks/web.rake

desc 'Oauth methods.'
command 'oauth' do |g|
  g.desc 'Exchanges a temporary OAuth verifier code for an access token.'
  g.long_desc %( Exchanges a temporary OAuth verifier code for an access token. )
  g.command 'access' do |c|
    c.flag 'client_id', desc: 'Issued when you created your application.'
    c.flag 'client_secret', desc: 'Issued when you created your application.'
    c.flag 'code', desc: 'The code param returned via the OAuth callback.'
    c.flag 'redirect_uri', desc: 'This must match the originally submitted URI (if one was sent).'
    c.flag 'single_channel', desc: 'Request the user to add your app only to a single channel. Only valid with a legacy workspace app.'
    c.action do |_global_options, options, _args|
      puts JSON.dump($client.oauth_access(options))
    end
  end
end
