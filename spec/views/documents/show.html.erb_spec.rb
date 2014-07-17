require 'spec_helper'

describe 'documents/show', type: :view do

  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:project) { FactoryGirl.build_stubbed(:project) }
  let(:document) { FactoryGirl.build_stubbed(:document, user: user, project_id: project.id) }
  let(:version) { FactoryGirl.build_stubbed(:version, whodunnit: user.id, item_id: document.id) }
  let(:document_child) { FactoryGirl.build_stubbed(:document, user: user, parent: document, project_id: project.id) }

  before(:each) do
    @user = FactoryGirl.build_stubbed(:user, id: 1, first_name: 'John', last_name: 'Simpson', email: 'john@simpson.org')
    @project = Project.create(id: 1 , title:  'Project1', created_at:  Time.now)
    @version = PaperTrail::Version.new( item_type: "Document",
                                       event: "create",
                                       whodunnit: @user.id,
                                       object: nil,
                                       created_at: "2014-02-25 11:50:56"
                                      )
    @document = FactoryGirl.build_stubbed(:document,
                                          :user => @user,
                                          :id => 1,
                                          :title => "Title",
                                          :body => "Content",
                                          :project_id => 1 ,
                                          :created_at => Time.now,
                                          :versions => [@version],
                                         )

    @document_child = FactoryGirl.build_stubbed(:document,
                                 :user => @user,
                                 :title => "Child Title",
                                 :body => "Child content",
                                 :project_id => 1,
                                 :parent_id => 1,
                                 :created_at => Time.now,
                                 :versions => [@version]
                                )

    allow(view).to receive(:created_by).and_return(@created_by)
    assign :children, [ @document_child ]

    allow(controller).to receive(:user_signed_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    allow(project).to receive(:friendly_id).and_return(project.title.parameterize)
    allow(document).to receive(:friendly_id).and_return(document.title.parameterize)
  end

  context 'document is root' do
    it 'render content and child of root document' do
      render
      expect(rendered).to have_content document.title
      expect(rendered).to have_content document.body
      expect(rendered).to have_content document_child.title
    end

    it 'sets Mercury editable region format to markdown' do
      @document.format = 'markdown'
      render
      expect(rendered).to have_css('#document_body[data-mercury="markdown"]')
    end

    it 'renders document in Markdown format' do
      @document.body = '**Body Text**'
      @document.format = 'markdown'
      render
      expect(rendered).to have_content('Body Text')
      expect(rendered).not_to have_content('**Body Text**')
    end

    it 'should not render document revisions history for new documents' do
      render
      expect(rendered).to_not have_text 'Revisions'
    end

    it 'should render document revisions history for documents with more than 1 revision' do
      allow(document).to receive(:versions).and_return([ version, version ])
      render
      expect(rendered).to have_text 'Revisions'
    end

    context 'user signed-in' do
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

  describe 'renders Disqus section', type: :view do

    it_behaves_like 'commentable with Disqus' do
      let(:entity) { document }
    end

    it 'does not render Disqus when inside Mercury editor' do
      allow(controller.request).to receive(:original_url).and_return('mercury_frame=true')
      render
      expect(rendered).not_to have_css('#disqus_thread')
    end
  end
end
