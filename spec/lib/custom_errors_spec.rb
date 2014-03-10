require 'spec_helper'
require 'custom_errors.rb'

describe CustomErrors, type: 'controller' do
  controller do
    include CustomErrors.setup '404' => { template: 'pages/not_found' },
                               '500' => { template: 'pages/internal_error' },
                               'log-limit' => 7

    attr_accessor :error

    def index
      raise error
    end
  end

  before(:each) do
    Rails.stub_chain(:env, :production?).and_return(true)
    controller.error = nil
  end

  it 'should catch 404 errors' do
    controller.error = ActiveRecord::RecordNotFound
    get :index
    expect(response).to render_template 'pages/not_found'
    expect(response.status).to eq 404
  end

  it 'should catch 500 errors' do
    controller.error = Exception
    get :index
    expect(response).to render_template 'pages/internal_error'
    expect(response.status).to eq 500
  end

  it 'should be able to adjust log stack trace limit' do
    controller.error = Exception
    dummy = Class.new
    Rails.stub(logger: dummy)
    dummy.should_receive(:error).exactly(9)
    get :index
  end
end