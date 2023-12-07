require 'paypal-sdk-core'
require 'paypal-sdk/rest/version'

module PayPal
  module SDK
    module REST
      class API < Core::API::REST
#        include Services

        def initialize(environment = nil, options = {})
          super("", environment, options)
        end

        class << self
          def user_agent
            @user_agent ||= "PayPalSDK/PayPal-Ruby-SDK #{PayPal::SDK::REST::VERSION} (#{sdk_library_details})"
          end
        end
      end
    end
  end
end

