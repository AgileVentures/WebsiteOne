if (Rails.env.development? || Rails.env.staging?) and ENV['INTERCEPT_EMAILS'] == 'true'
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end
