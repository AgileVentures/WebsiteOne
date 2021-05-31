# frozen_string_literal: true

module AgileVentures
  class Error < RuntimeError
  end

  class AccessDenied < Error
    def initialize(user, request)
      @user = user
      @request = request
    end
  end
end
