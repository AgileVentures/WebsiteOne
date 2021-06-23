# frozen_string_literal: true

ActionMailer::Base.register_interceptor(SandboxEmailInterceptor) if ENV['INTERCEPT_EMAILS']
