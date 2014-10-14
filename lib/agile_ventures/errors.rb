module AgileVentures
  class Error < RuntimeError
  end

  class AccessDenied < Error
    def initialize(user, request)
      @user, @request = user, request     
    end
  end
end
