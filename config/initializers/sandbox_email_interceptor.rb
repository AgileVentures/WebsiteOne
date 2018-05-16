unless ENV['ALLOW_EMAILS']
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end
