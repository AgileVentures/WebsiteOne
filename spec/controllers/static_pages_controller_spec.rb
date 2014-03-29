require 'spec_helper'

describe StaticPagesController do
  let(:user) { @user }
  let(:page) { @page }
  let(:valid_attributes) { {
      'title' => 'MyString',
      'body' => 'MyText'
  } }
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
end
