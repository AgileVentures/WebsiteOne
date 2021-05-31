# frozen_string_literal: true

describe DeviseHelper do
  describe 'when no error' do
    before(:each) do
      helper.stub_chain(:resource, :errors, :empty?).and_return true
    end

    it '#devise_error_messages_flash' do
      acts_well_when_no_error?('devise_error_messages_flash')
    end

    it '#devise_error_simple_message' do
      acts_well_when_no_error?('devise_error_simple_message')
    end
  end

  describe 'when there are errors' do
    before(:each) do
      @messages = ['error 1', 'error 2']
      helper.stub_chain(:resource, :errors, :empty?).and_return false
      helper.stub_chain(:resource, :errors, :full_messages).and_return @messages
    end

    it '#devise_error_messages_flash' do
      sentence = 'There are 2 errors'
      helper.stub_chain(:resource, :errors, :count).and_return @messages.size
      helper.stub_chain(:resource, :class, :model_name, :human).and_return 'devise'
      expect(I18n).to receive(:t).and_return sentence
      result = helper.devise_error_messages_flash
      expect(result).to have_text(sentence)
      expect(result).to have_css('.alert.alert-danger')
      @messages.each { |msg| expect(result).to have_text(msg) }
    end
    it '#devise_error_simple_message' do
      result = helper.devise_error_simple_message
      expect(result).to have_css('.alert.alert-danger')
      @messages.each { |msg| expect(result).to have_text(msg) }
    end
  end
end

def acts_well_when_no_error?(method_name)
  result = helper.send(method_name)
  expect(result).to eq ''
end
