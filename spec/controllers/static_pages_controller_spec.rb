require 'spec_helper'

describe StaticPagesController, :type => :controller do

  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:page) { FactoryGirl.create(:static_page) }
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
  end

  describe 'GET show' do

    before(:each) do
      get :show, {:id => page.to_param }, valid_session
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
      page_child = FactoryGirl.create(:static_page, parent_id: page.id)
      get :show, {:id => page_child.to_param}, valid_session
      expect(assigns(:ancestry)).to eq([page.title, page_child.title])
    end
  end

  describe 'POST mercury_update' do
    before(:each) do
      allow(StaticPage).to receive(:friendly).and_return(page)
      allow(page).to receive(:find).and_return(page)
    end

    it 'assigns the requested page as @page' do
      post :mercury_update, id: page.slug, content: { static_page_title: { value: 'MyTitle' }, static_page_body: { value: 'MyBody' } }
      expect(assigns(:page)).to eq(page)
    end

    context 'with valid params' do
      before(:each) do
        allow(page).to receive(:update_attributes).with(title: 'MyTitle', body: 'MyBody').and_return true
        post :mercury_update, id: page.slug, content: { static_page_title: { value: 'MyTitle' }, static_page_body: { value: 'MyBody' } }
      end

      it 'should render a blank string' do
        expect(response.body).to be_empty
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(page).to receive(:update_attributes).and_return false
        post :mercury_update, id: page.slug, content: { static_page_title: { value: '' }, static_page_body: { value: '' } }
      end

      it 'should not render anything' do
        # render nothing actually renders a space
        expect(response.body).to be_empty
      end
    end
  end

  describe 'GET mercury_saved' do
    before(:each) do
      get :mercury_saved, id: page.slug
    end

    it 'should redirect to the static_page_path' do
      expect(response).to redirect_to static_page_path(page)
    end

    it 'should display a flash message "The page has been successfully updated."' do
      expect(flash[:notice]).to eq 'The page has been successfully updated.'
    end
  end
end
