module PayPal::SDK
  module Core
    module OpenIDConnect
      module GetAPI
        # Get API object
        # === Example
        #   Payment.api
        #   payment.api
        def api
          @api || parent_api
        end

        # Parent API object
        def parent_api
          superclass.respond_to?(:api) ? superclass.api : RequestDataType.api
        end

        def client_id
          api.config.openid_client_id || api.config.client_id
        end

        def client_secret
          api.config.openid_client_secret || api.config.client_secret
        end
      end
    end
  end
end
