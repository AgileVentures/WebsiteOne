require 'spec_helper'

describe VisitorsController do
    it 'assignes the welcome message and renders index template' do
      get :index
      assigns(:message).should eql 'Hello World'
      expect(response).to render_template('index')
    end
end
