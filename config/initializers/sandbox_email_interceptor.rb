if Rails.env.development? || Rails.env.staging?
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end
