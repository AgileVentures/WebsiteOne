module PayPal::SDK
  module Core
    module OpenIDConnect
      module RequestDataType

        # Get a local API object or Class level API object
        def api
          @api || self.class.api
        end

        class << self
          # Global API object
          # === Example
          #   RequestDataType.api
          def api
            @api ||= API.new({})
          end

          def client_id
            api.config.openid_client_id || api.config.client_id
          end

          def client_secret
            api.config.openid_client_secret || api.config.client_secret
          end

          # Setter for RequestDataType.api
          # === Example
          #   RequestDataType.set_config(..)
          include SetAPI

          # Configure depended module, when RequestDataType is include.
          # === Example
          #   class Payment < DataTypes
          #     include RequestDataType
          #   end
          #   Payment.set_config(..)
          #   payment.set_config(..)
          #   Payment.api
          #   payment.api
          def included(klass)
            klass.class_eval do
              extend GetAPI
              extend SetAPI
              include SetAPI
            end
          end
        end
      end
    end
  end
end
