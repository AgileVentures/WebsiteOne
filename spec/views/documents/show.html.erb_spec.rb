require 'spec_helper'

describe "documents/show" do
  before(:each) do
    @user = stub_model(User, id: 1, first_name: 'John', last_name: 'Simpson', email: 'john@simpson.org', display_name: 'John Simpson')
    @project = assign(:project, stub_model(Project, id: 1 , title:  'Project1',
                                           friendly_id:  'cool-project', created_at:  Time.now))
    @version = stub_model(PaperTrail::Version,
                          item_type: "Document",
                          event: "create",
                          whodunnit: @user.id,
                          object: nil,
                          created_at: "2014-02-25 11:50:56"
                         )
    @document = stub_model(Document,
                           :user => @user,
                           :id => 1,
                           :title => "Title",
                           :body => "Content",
                           :project_id => 1 ,
                           :created_at => Time.now,
                           :versions => [@version],
                           :friendly_id => 'friendly_id'
                          )

    @document_child = stub_model(Document,
                                 :user => @user,
                                 :title => "Child Title",
                                 :body => "Child content",
                                 :project_id => 1,
                                 :parent_id => 1,
                                 :created_at => Time.now,
                                 :versions => [@version]
                                )

    allow(view).to receive(:created_by).and_return(@created_by)
    assign :document, @document
    assign :children, [ @document_child ]

    allow(controller).to receive(:user_signed_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(@user)
  end

  context 'document is root' do
    before do
      allow(@document_child).to receive(:user).and_return(@user)
    end

    it 'render content and child of root document' do
      render
      expect(rendered).to have_content @document.title
      expect(rendered).to have_content @document.body
      expect(rendered).to have_content @document_child.title
    end

    it 'should not render document revisions history for new documents' do
      render
      expect(rendered).to_not have_text 'Revisions'
    end

    it 'should render document revisions history for documents with more than 1 revision' do
      allow(@document).to receive(:versions).and_return([ @version, @version ])
      render
      expect(rendered).to have_text 'Revisions'
    end

    context 'user signed-in' do
      before :each do
        allow(controller).to receive(:user_signed_in?).and_return(true)
      end
      it 'should render an Edit link' do
        render
        rendered.within('#edit_link') do |link|
          expect(link).to have_css('i[class="fa fa-pencil-square-o"]')
        end
      end

      it 'should render a New Sub-document link' do
        render
        rendered.within('#new_document_link') do |link|
          expect(link).to have_css('i[class="fa fa-file-text-o"]')
        end
      end
    end

    context 'document is a child' do
      before do
        assign :document, @document_child
        assign :children, []
      end

      it 'render content of document' do
        render
        expect(rendered).to have_content @document_child.title
        expect(rendered).to have_content @document_child.body
      end
    end
  end

  describe 'renders Disqus section', type: :view do

    before :each do
      allow(view).to receive(:current_user).and_return(@user)
      allow(view).to receive(:user_signed_in?).and_return(true)
    end

    it_behaves_like 'commentable with Disqus' do
      let(:entity) { @document }
    end

    it 'does not render Disqus when inside Mercury editor ' do
      allow(controller.request).to receive(:original_url).and_return('mercury_frame=true')
      render
      expect(rendered).not_to have_css("#disqus_thread")
    end
  end
end
