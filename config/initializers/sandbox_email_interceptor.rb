if ENV['INTERCEPT_EMAILS'] == 'true'
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end
