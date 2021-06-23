# frozen_string_literal: true

module DisqusHelper
  def get_disqus_sso(user)
    data = {}
    present user do |presenter|
      data = {
        id: user.id,
        username: user.display_name,
        email: user.email,
        avatar: presenter.gravatar_url,
        url: user_url(user)
      }.to_json
    end

    message = Base64.strict_encode64(data)
    timestamp = Time.now.to_i
    sig = OpenSSL::HMAC.hexdigest('sha1', Settings.disqus.secret_key, "#{message} #{timestamp}")

    %(<script id="disqus-sso" type="text/javascript">
              var disqus_config = function() {
              this.page.remote_auth_s3 = '#{message} #{sig} #{timestamp}';
              this.page.api_key = '#{Settings.disqus.api_key}';
              }
            </script>).html_safe
  end
end
