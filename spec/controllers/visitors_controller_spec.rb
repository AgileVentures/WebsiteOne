require 'spec_helper'

describe VisitorsController do
    it 'assignes the welcome message and renders index template' do
      get :index
      expect(assigns(:message)).to eq('Hello World')
      expect(response).to render_template('index')
    end
end
