require 'spec_helper'

describe ErrorsController do
  describe 'GET not_found' do
    it 'should return the 404 error page' do
      get :not_found
      response.should render_template 'static_pages/not_found'
      response.status.should eq 404
    end
  end
end