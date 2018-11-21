if ENV['INTERCEPT_EMAILS']
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end
