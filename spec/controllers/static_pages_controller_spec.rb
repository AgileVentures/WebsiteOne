# frozen_string_literal: true

describe StaticPagesController, type: :controller do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:page) { FactoryBot.create(:static_page) }
  let(:valid_attributes) do
    {
      'title' => 'MyString',
      'body' => 'MyText'
    }
  end
  let(:valid_session) { {} }

  before(:each) do
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user) { user }
    allow(user).to receive(:touch)
  end

  describe 'GET show' do
    before(:each) do
      get :show, params: { id: page.to_param }.merge(valid_session)
    end

    it 'assigns the requested page as page' do
      expect(assigns(:page)).to eq(page)
    end

    it 'renders the show template' do
      expect(response).to render_template 'show'
    end

    it 'assigns the requested page ancestry as the page.title' do
      expect(assigns(:ancestry)).to eq([page.title])
    end

    it 'assigns the requested child page ancestry as @ancestry' do
      page_child = FactoryBot.create(:static_page, parent_id: page.id)
      get :show, params: { id: page_child.to_param }.merge(valid_session)
      expect(assigns(:ancestry)).to eq([page.title, page_child.title])
    end
  end
end
