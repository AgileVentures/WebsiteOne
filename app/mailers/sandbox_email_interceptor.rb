# frozen_string_literal: true

class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = ENV.fetch('USER_EMAIL', nil)
  end
end
