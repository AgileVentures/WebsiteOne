require 'spec_helper'

describe VisitorsController do
    it 'renders index template' do
      get :index
      expect(response).to render_template('index')
    end
end
