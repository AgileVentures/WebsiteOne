require 'spec_helper'

describe Settings, type: 'model' do
  describe 'in production' do
    before do
      ENV['PRIVILEGED_USERS'] = "one@example.com, two@example.com"
    end

    it 'has specific privileged_users fed through ENV' do
      Settings.privileged_users = ENV['PRIVILEGED_USERS']
      expect(Settings.privileged_users.split(',').length).to eq(2)
      expect(Settings.privileged_users).to eq('one@example.com, two@example.com')
    end
  end
end
