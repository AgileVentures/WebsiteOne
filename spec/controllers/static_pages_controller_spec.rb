require 'spec_helper'

describe StaticPagesController do
  let(:user) { @user }
  let(:page) { @page }
  let(:valid_attributes) do
    {
        'title' => 'MyString',
        'body' => 'MyText'
    }
  end
  let(:valid_session) { {} }
  before(:each) do
    @user = FactoryGirl.create(:user)
    request.env['warden'].stub :authenticate! => user
    controller.stub :current_user => user
    @page = FactoryGirl.create(:static_page)
  end

  describe 'GET show' do

    before(:each) do
      get :show, {:id => page.to_param}, valid_session
    end

    it 'assigns the requested page as @page' do
      assigns(:page).should eq(page)
    end

    it 'renders the show template' do
      expect(response).to render_template 'show'
    end

    it 'assigns the requested page ancestry as @ancestry' do
      assigns(:ancestry).should eq([page.title])
    end

    it 'assigns the requested child page ancestry as @ancestry' do
      page_child = FactoryGirl.create(:static_page, parent_id: @page.id)
      get :show, {:id => page_child.to_param}, valid_session
      assigns(:ancestry).should eq([page.title, page_child.title])
    end
  end

  describe 'POST mercury_update' do
    before(:each) do
      StaticPage.stub_chain(:friendly, :find).and_return(@page)
    end

    it 'assigns the requested page as @page' do
      post :mercury_update, id: @page.slug, content: { static_page_title: { value: 'MyTitle' }, static_page_body: { value: 'MyBody' } }
      assigns(:page).should eq(@page)
    end

    context 'with valid params' do
      before(:each) do
        @page.should_receive(:update_attributes).with(title: 'MyTitle', body: 'MyBody').and_return true
        post :mercury_update, id: @page.slug, content: { static_page_title: { value: 'MyTitle' }, static_page_body: { value: 'MyBody' } }
      end

      it 'should render a blank string' do
        response.body.should be_empty
      end
    end

    context 'with invalid params' do
      before(:each) do
        @page.should_receive(:update_attributes).and_return false
        post :mercury_update, id: @page.slug, content: { static_page_title: { value: '' }, static_page_body: { value: '' } }
      end

      it 'should not render anything' do
        # render nothing actually renders a space
        response.body.should eq ' '
      end
    end
  end

  describe 'GET mercury_saved' do
    before(:each) do
      get :mercury_saved, id: @page.slug
    end

    it 'should redirect to the static_page_path' do
      response.should redirect_to static_page_path(@page)
    end

    it 'should display a flash message "The page has been successfully updated."' do
      flash[:notice].should eq 'The page has been successfully updated.'
    end
  end
end
