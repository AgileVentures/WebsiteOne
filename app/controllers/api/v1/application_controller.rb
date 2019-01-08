module Api
  module V1
    class ApplicationController < ::ApplicationController
      include DeviseTokenAuth::Concerns::SetUserByToken
    end
  end
end
