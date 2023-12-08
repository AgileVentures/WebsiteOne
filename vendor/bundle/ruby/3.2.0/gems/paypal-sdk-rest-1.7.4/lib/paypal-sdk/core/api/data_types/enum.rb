module PayPal::SDK::Core
  module API
    module DataTypes

      class Enum < SimpleTypes::String
        class << self
          def options
            @options ||= []
          end

          def options=(options)
            if options.is_a? Hash
              options.each do |const_name, value|
                const_set(const_name, value)
              end
              @options = options.values
            else
              @options = options
            end
          end
        end
      end

    end
  end
end
