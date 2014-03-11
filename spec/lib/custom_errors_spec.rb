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
    Rails.stub_chain(:env, :production?).and_return(true)
  end

  specify 'should catch 404 errors' do
    routes.draw { get 'raise_404' => 'anonymous#raise_404' }

    get :raise_404
    expect(response).to render_template 'pages/not_found'
    expect(response.status).to eq 404
  end

  it 'should catch 500 errors' do
    routes.draw { get 'raise_500' => 'anonymous#raise_500' }

    get :raise_500
    expect(response).to render_template 'pages/internal_error'
    expect(response.status).to eq 500
  end

  it 'should be able to adjust log stack trace limit' do
    routes.draw { get 'raise_500' => 'anonymous#raise_500' }

    dummy = Class.new
    Rails.stub(logger: dummy)
    dummy.should_receive(:error).exactly(7)
    get :raise_500
  end
end