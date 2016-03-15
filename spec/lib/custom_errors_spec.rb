require 'spec_helper'
require 'custom_errors.rb'

describe CustomErrors, type: 'controller' do
  controller do
    include CustomErrors

    def raise_404
      raise ActiveRecord::RecordNotFound
    end

    def raise_500
      raise Exception
    end
  end

  before(:each) do
    Features.custom_errors.enabled = true
  end

  context '404 errors' do
    before(:each) do
      routes.draw { get 'raise_404' => 'anonymous#raise_404' }
    end

    it 'should catch 404 errors' do

      get :raise_404
      expect(response).to render_template 'static_pages/not_found'
      expect(response.status).to eq 404
    end
  end

  context '500 errors' do
    before(:each) do
      routes.draw { get 'raise_500' => 'anonymous#raise_500' }
    end

    it 'should catch 500 errors' do
      get :raise_500
      expect(response).to render_template 'static_pages/internal_error'
      expect(response.status).to eq 500
    end

    it 'should be able to adjust log stack trace limit' do
      dummy = Class.new
      Rails.stub(logger: dummy)
      expect(dummy).to receive(:error).exactly(7)
      get :raise_500
    end

    it 'should send an error notification to the admin' do
      ActionMailer::Base.deliveries.clear
      get :raise_500

      expect(ActionMailer::Base.deliveries.size).to eq 1
      email = ActionMailer::Base.deliveries[0]
      expect(email.subject).to include 'ERROR'

      recipients = email.to
      expect(recipients.size).to eq 1
      expect(recipients[0]).to eq 'info@agileventures.org'
    end
  end
end
