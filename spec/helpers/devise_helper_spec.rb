require 'spec_helper'

describe DeviseHelper do

  describe 'devise_error_messages_flash' do

    it 'when no error' do
      helper.stub_chain(:resource, :errors, :empty?).and_return true
      result = helper.devise_error_messages_flash
      expect(result).to eq ""
    end

    it 'when there are errors' do
      messages = ["error 1","error 2" ]
      sentence = "There are 2 errors"

      helper.stub_chain(:resource, :errors, :empty?).and_return false
      helper.stub_chain(:resource, :errors, :full_messages).and_return messages
      helper.stub_chain(:resource, :errors, :count).and_return messages.size
      helper.stub_chain(:resource, :class, :model_name, :human).and_return "devise"
      I18n.should_receive(:t).and_return sentence


      result = helper.devise_error_messages_flash
      expect(result).to have_css ('.alert.alert-danger')
      expect(result).to have_text (sentence)
      messages.each { |msg| expect(result).to have_text (msg) }
    end
  end
end