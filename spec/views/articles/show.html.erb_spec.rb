require 'spec_helper'

describe 'articles/show', type: :view do
  before :each do
    @user = build_stubbed(:user, first_name: 'Thomas')
#    @author = stub_model(User, display_name: 'Shakespeare')
    @author = build_stubbed(:user, first_name: 'William')
    @article = build_stubbed(:article,
                   id: 555,
       slug: 'friendly_id',
       title: "Ruby article",
       tag_list: ["Ruby", "Rails"],
       user: @author,
       created_at: Time.now,
       updated_at: Time.now
       )
    downvotes = [stub_model(ActsAsVotable::Vote),stub_model(ActsAsVotable::Vote)]
    upvotes = [stub_model(ActsAsVotable::Vote)]
    allow(@article).to receive(:get_upvotes).and_return(upvotes)
    allow(@article).to receive(:get_downvotes).and_return(downvotes)
  end

  context 'user is not signed in' do
    before :each do
      allow(view).to receive(:user_signed_in?).and_return(false)
    end

    it 'should show article content' do
      render
      expect(rendered).to have_css('div#doc-box')
      expect(rendered).to have_text(@article.title)
      expect(rendered).to have_content("Created on #{@article.created_at.strftime('%d %B %y')}")
      expect(rendered).to have_content("Last updated #{time_ago_in_words(@article.updated_at)}")
      expect(rendered).to have_text(@article.tag_list.join(', '))
      expect(rendered).not_to have_link('edit article')
    end

    it 'should show article vote value' do
        render
        expect(rendered).to have_content("Votes: #{@article.get_upvotes.size-@article.get_downvotes.size}")
        expect(rendered).not_to have_link('Up Vote')
        expect(rendered).not_to have_link('Down Vote')
    end
  end

  context 'user is signed in' do
    before :each do
      allow(view).to receive(:current_user).and_return(stub_model(User))
      allow(view).to receive(:user_signed_in?).and_return(true)
#      assign(:current_user, @user)

    end

    it 'renders a edit button' do
      render
      expect(rendered).to have_link('edit article')
    end

    it 'renders the vote value and vote links' do
      render
      expect(rendered).to have_link('Up Vote')
      expect(rendered).to have_link('Down Vote')
      expect(rendered).to have_content("Votes: #{@article.get_upvotes.size-@article.get_downvotes.size}")
    end

  end

  describe 'renders Disqus section' do
    it_behaves_like 'commentable with Disqus' do
      let(:entity) { @article }
    end
  end

  context 'author is signed in' do
    before :each do
      allow(view).to receive(:current_user).and_return(@author)
      allow(view).to receive(:user_signed_in?).and_return(true)
      assign(:current_user, @author)
#
#      view.stub(:user_signed_in?).and_return(true)
#      assign(:current_user, @author)
    end

    it 'renders a edit button' do
      render
      expect(rendered).to have_link('edit article')
    end

    it 'renders the vote value and no vote links' do
      render

      expect(rendered).not_to have_link('Up Vote')
      expect(rendered).not_to have_link('Down Vote')
      expect(rendered).to have_content("Votes: #{@article.get_upvotes.size-@article.get_downvotes.size}")

    end

  end

end
