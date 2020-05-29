require 'spec_helper'

describe DocumentsController do
  let(:user) { @user }
  let(:document) { @document }
  let(:valid_attributes) { {
      'title' => 'MyString',
      'body' => 'MyText',
      'user_id' => "#{user.id}"
  } }
  let(:valid_session) { {} }
  let(:categories) do 
    [
    FactoryBot.create(:document, id: 555, project_id: document.project_id, parent_id: nil, title: "Title-1"),
    FactoryBot.create(:document, id: 556, project_id: document.project_id, parent_id: nil, title: "Title-2")
    ]
  end
  let(:params) { {:id => categories.first.to_param, project_id: document.project.friendly_id, categories: 'true'} }

  before(:each) do
    @user = FactoryBot.create(:user)
    request.env['warden'].stub :authenticate! => user
    controller.stub :current_user => user
    @document = FactoryBot.create(:document)
    allow(@document).to receive(:create_activity)
  end

  it 'should raise an error if no project was found' do
    expect {
      get :show, params: { id: @document.id, project_id: @document.project.id + 3 }.merge(valid_session)
    }.to raise_error ActiveRecord::RecordNotFound
  end

  describe 'GET show' do

    context 'with a single project' do
      before(:each) do
        get :show, params: {:id => document.to_param, project_id: document.project.friendly_id}.merge(valid_session)
      end

      it 'assigns the requested document as @document' do
        expect(assigns(:document)).to eq(document)
      end

      it 'renders the show template' do
        expect(response).to render_template 'show'
      end
    end

    context 'with more than one project' do
      before(:each) do
        @document_2 = FactoryBot.create(:document)
      end

      it 'should not mistakenly render the document under the wrong project' do
        expect {
          get :show, params: { id: document.to_param, project_id: @document_2.project.friendly_id }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'get_doc_categories' do
    context 'it has categories to show' do
      it 'renders the categories partial' do
        get :get_doc_categories, params: params
        expect(response).to render_template(:partial => '_categories')
      end

      it 'assigns the available categories to @categories' do
        get :get_doc_categories, params: params.merge({id: document.to_param})
        extended_categories = categories.push(document)
        expect(assigns(:categories)).to match_array extended_categories
      end
    end
  end
end
