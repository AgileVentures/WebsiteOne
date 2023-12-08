require 'paypal-sdk-core'

module PayPal::SDK::Core
  module OpenIDConnect
    module DataTypes
      class Base < PayPal::SDK::Core::API::DataTypes::Base
      end

      class Address < Base
        def self.load_members
          object_of :street_address, String
          object_of :locality, String
          object_of :region, String
          object_of :postal_code, String
          object_of :country, String
        end
      end

      class Userinfo < Base
        def self.load_members
          object_of :user_id, String
          object_of :sub, String
          object_of :name, String
          object_of :given_name, String
          object_of :family_name, String
          object_of :middle_name, String
          object_of :picture, String
          object_of :email, String
          object_of :email_verified, Boolean
          object_of :gender, String
          object_of :birthday, String
          object_of :zoneinfo, String
          object_of :locale, String
          object_of :language, String
          object_of :verified, Boolean
          object_of :phone_number, String
          object_of :address, Address
          object_of :verified_account, Boolean
          object_of :account_type, String
          object_of :account_creation_date, String
          object_of :age_range, String
          object_of :payer_id, String
        end
      end

      class Tokeninfo < Base
        def self.load_members
          object_of :scope, String
          object_of :access_token, String
          object_of :refresh_token, String
          object_of :token_type, String
          object_of :id_token, String
          object_of :expires_in, Integer
        end
      end

      class Error < Base
        def self.load_members
          object_of :error, String
          object_of :error_description, String
          object_of :error_uri, String
        end
      end


      constants.each do |data_type_klass|
        data_type_klass = const_get(data_type_klass)
        data_type_klass.load_members if defined? data_type_klass.load_members
      end

    end
  end
end
