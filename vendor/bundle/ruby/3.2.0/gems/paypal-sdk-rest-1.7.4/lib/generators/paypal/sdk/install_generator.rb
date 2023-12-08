module Paypal
  module Sdk
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def copy_config_file
          copy_file "paypal.yml", "config/paypal.yml"
        end

        def copy_initializer_file
          copy_file "paypal.rb",  "config/initializers/paypal.rb"
        end
      end
    end
  end
end
