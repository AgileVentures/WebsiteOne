# require 'rubygems'
# require 'base64'
# require 'cgi'
# require 'openssl'
# require "json"

module DisqusHelper
  def get_disqus_sso(user)
    data =  {
      id: user.id,
      username: user.display_name,
      email: user.email,
      #'avatar' => user['avatar'],
      #'url' => user['url']
    }.to_json

    message  = Base64.encode64(data).gsub("\n", "")
    timestamp = Time.now.to_i
    sig = OpenSSL::HMAC.hexdigest('sha1', Disqus::DISQUS_SECRET_KEY, '%s %s' % [message, timestamp])

    return "<script type=\"text/javascript\">
            var disqus_config = function() {
            this.page.remote_auth_s3 = \"#{message} #{sig} #{timestamp}\";
            this.page.api_key = \"#{Disqus::DISQUS_API_KEY}\";
            }
          </script>"
  end
end
