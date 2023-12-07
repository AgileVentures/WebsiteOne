module PayPal
  module SDK
    module REST
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
      end
    end
  end
end
