require 'spec_helper'

describe ApplicationController do
  describe '#configure_permitted_parameters' do
    it 'should call devise_parameter_sanitizer' do
      fake_sanitizer = double(for: Object.new)
      controller.should_receive(:devise_parameter_sanitizer).and_return(fake_sanitizer)
      fake_sanitizer.should_receive(:for).with(:account_update)
      controller.send(:configure_permitted_parameters)
    end
  end
end

