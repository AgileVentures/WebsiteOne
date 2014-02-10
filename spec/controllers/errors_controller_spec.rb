require 'spec_helper'

describe ErrorsController do
  describe 'GET not_found' do
    it 'should return the 404 error page' do
      get :not_found
      response.should render_template 'pages/not_found'
      response.status.should eq 404
    end
  end

  describe 'GET 500' do
    it 'should return the 500 error page' do
      get :internal_error
      response.should render_template 'pages/internal_error'
      response.status.should eq 500
    end

    it '' do
      ErrorsController.any_instance.should_receive(:not_found).and_raise(Exception)
      get :not_found
      response.should render_template 'pages/internal_error'
      response.status.should eq 500
    end
  end
end