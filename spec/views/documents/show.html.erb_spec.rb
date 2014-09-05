require 'spec_helper'

describe 'documents/show', type: :view do

  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:project) { FactoryGirl.build_stubbed(:project) }
  let(:document) { FactoryGirl.build_stubbed(:document, user: user, project_id: project.id) }
  let(:version) { FactoryGirl.build_stubbed(:version, whodunnit: user.id, item_id: document.id) }
  let(:document_child) { FactoryGirl.build_stubbed(:document, user: user, parent: document, project_id: project.id) }

  before(:each) do
    assign :document, document
    assign :project, project
    assign :document_child, document_child
    assign :children, [ document_child ]

    allow(controller).to receive(:user_signed_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    allow(project).to receive(:friendly_id).and_return(project.title.parameterize)
    allow(document).to receive(:friendly_id).and_return(document.title.parameterize)
  end

  context 'when document is root' do

    it 'should render title, content and child of root document' do
      render
      expect(rendered).to have_content document.title
      expect(rendered).to have_content document.body
      expect(rendered).to have_content document_child.title
    end

    it 'should not render document revision history for new documents' do
      render
      expect(rendered).to_not have_text 'Revisions'
    end

    it 'should render document revisions history for documents with more than 1 revision' do
      allow(document).to receive(:versions).and_return([ version, version ])
      render
      expect(rendered).to have_text 'Revisions'
    end

    context 'when user is signed-in' do

      before { render }

      it 'should render an Edit link' do
        rendered.within('#edit_link') do |link|
          expect(link).to have_css('i[class="fa fa-pencil-square-o"]')
        end
      end

      it 'should render a New Sub-document link' do
        rendered.within('#new_document_link') do |link|
          expect(link).to have_css('i[class="fa fa-file-text-o"]')
        end
      end

      it 'renders a Change section link' do
        rendered.within("#change_parent_link") do |link|
          expect(link).to have_css('i[class="fa fa-cogs"]')
        end
      end

      it 'renders a Change section popup when the link is clicked' do
        allow(view).to receive(:params).and_return(:change_parent => '1')
        render
        expect(rendered).to have_css('div[class="modal-dialog"]')
      end
    end

    context 'when document is a child' do
      before do
        assign :document, document_child
        assign :children, []
        render
      end

      it 'should render title and content of document' do
        expect(rendered).to have_content document_child.title
        expect(rendered).to have_content document_child.body
      end

      it 'should not render New Sub-document link' do
        expect(rendered).not_to have_css '#new_document_link'
      end
    end
  end

  describe 'rendering Disqus section', type: :view do

    it_behaves_like 'commentable with Disqus' do
      let(:entity) { document }
    end

    it 'does not render Disqus when inside Mercury editor' do
      allow(controller.request).to receive(:original_url).and_return('mercury_frame=true')
      render
      expect(rendered).not_to have_css('#disqus_thread')
    end
  end

  context 'when user is not logged in' do
    before :each do
      allow(view).to receive(:user_signed_in?).and_return(false)
    end

    it 'does not render an Edit link' do
      expect(rendered).not_to have_css('i[class="fa fa-pencil-square-o"]')
    end

    it 'does not render a New Sub-document link' do
      expect(rendered).not_to have_css('i[class="fa fa-file-text-o"]')
    end

    it 'does not render a Change Section link' do
      expect(rendered).not_to have_css('i[class="fa fa-cogs"]')
    end
  end

end
