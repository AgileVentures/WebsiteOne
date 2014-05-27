require 'spec_helper'
require 'user_sanitizer.rb'

describe ApplicationController do
  describe '#devise_parameter_sanitizer' do
    it 'creates a new parameter sanitizer object when resource is of type User' do
      controller.stub(resource_class: User)
      controller.params = {}
      expect(User::ParameterSanitizer).to receive(:new).with(User, :user, {})
      controller.instance_eval { devise_parameter_sanitizer }
    end

    it 'should call devise parameter sanitizer when resource is not :user' do
      module Devise::Controllers::Helpers
        extend self

        def devise_parameter_sanitizer *args
        end
      end
      controller.stub(resource_class: :employee)
      expect(controller).to receive(:old_devise_parameter_sanitizer)
      controller.instance_eval { devise_parameter_sanitizer }
    end
  end
end
