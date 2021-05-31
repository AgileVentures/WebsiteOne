# frozen_string_literal: true

describe SubscriptionsController, type: :controller do
  describe 'Attempt to get individual subscription/upgrade' do
    it 'raises URL Generation error' do
      expect { get '/subscriptions/upgrade' }.to raise_error(ActionController::UrlGenerationError)
    end
  end
end
