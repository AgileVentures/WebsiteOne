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
  end
end
