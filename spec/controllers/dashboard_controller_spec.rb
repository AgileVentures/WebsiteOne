# frozen_string_literal: true

describe DashboardController, type: :controller do
  describe 'GET index' do
    it 'renders the correct template' do
      get :index
      expect(response).to render_template 'dashboard/index'
    end

    it 'assigns stats variable' do
      allow(controller).to receive(:get_stats).and_return('test')
      get :index
      expect(assigns(:stats)).to eq 'test'
    end
  end
end
