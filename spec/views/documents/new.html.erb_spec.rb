require 'spec_helper'

describe 'documents/new', type: :view do
  before(:each) do
    @project = FactoryGirl.build_stubbed(:project)
    @document = assign(:document, Document.new)
  end

  context 'when user is signed in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(true)
    end

    it 'renders new document form' do
      render
      expect(rendered).to have_selector 'form', action: project_documents_path(@project), method: 'post' do
        expect(rendered).to have_selector 'input', id: 'document_parent_id', name: 'document[parent_id]'
        expect(rendered).to have_selector 'input', id: 'document_title', name: 'document[title]'
        expect(rendered).to have_selector 'input', id: 'document_project_id', name: 'document[project_id]'
      end
    end

    it 'renders a back button' do
      render
      expect(rendered).to have_link('Back', href: project_path(@project))
    end
  end
end
