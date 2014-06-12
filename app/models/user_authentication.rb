class UserAuthentication < ActiveRecord::Base
  belongs_to :user
  belongs_to :authentication_provider

  serialize :params

  def self.create_from_omniauth(params, user, provider)
    token_expires_at = params['credentials']['expires_at'] ? Time.at(params['credentials']['expires_at']).to_datetime : nil

    create(
      user: user,
      authentication_provider: provider,
      uid: params['uid'],
      token: params['credentials']['token'],
      token_expires_at: token_expires_at,
      params: params,
    )
  end
end
