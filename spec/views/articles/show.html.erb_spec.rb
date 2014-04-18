require 'spec_helper'

describe 'articles/show', type: :view do
  before :each do
    @user = build_stubbed(:user, first_name: 'Thomas')
    @author = @user
    @article = build_stubbed(:article,
              	   id: 555,
		   slug: 'friendly_id',
		   title: "Ruby article",
		   tag_list: ["Ruby", "Rails"],
		   user: @user,
		   created_at: Time.now,
		   updated_at: Time.now
		   )
    downvotes = [stub_model(ActsAsVotable::Vote),stub_model(ActsAsVotable::Vote)]
    upvotes = [stub_model(ActsAsVotable::Vote)]
    allow(@article).to recieve(:upvotes).and_return(upvotes)
    allow(@article).to recieve(:downvotes).and_return(downvotes)
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
      expect(rendered).not_to have_link('Vote up')
      expect(rendered).not_to have_link('Vote down')
    end

    it 'should show article vote value' do
        render
        rendered.should have_content("Vote value: #{@article.upvotes.size-@article.downvotes.size}")
        rendered.should_not have_link('Vote up')
        rendered.should_not have_link('Vote down')
    end

  end

  context 'user is signed in' do
    before :each do
      allow(view).to receive(:current_user).and_return(@user)
      allow(view).to receive(:user_signed_in?).and_return(true)
    end

    it 'renders a edit button' do
      render
      expect(rendered).to have_link('edit article')
    end

    it 'renders the vote value and links' do
      render
      rendered.should have_link('Vote up')
      rendered.should have_link('Vote down')
      rendered.should have_content("Vote value: #{@article.upvotes.size-@article.downvotes.size}")
    end

  end

  describe 'renders Disqus section' do
    it_behaves_like 'commentable with Disqus' do
      let(:entity) { @article }
    end
  end
end
