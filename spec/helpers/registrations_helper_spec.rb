require 'spec_helper'

describe RegistrationsHelper do
  describe '#display_email?' do
    it 'should be true when set true' do
      session[:display_email] = true
      expect(display_email?).to be_truthy
    end

    it 'should be false when false' do
      session[:display_email] = false
      expect(display_email?).to be_falsey
    end
  end
end