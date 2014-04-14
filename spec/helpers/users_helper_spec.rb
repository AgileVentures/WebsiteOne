require 'spec_helper'


describe UsersHelper do
  describe '#user_display_name' do
    it 'should return the first part of the users email when first name and last name are empty' do
      user = mock_model(User, email: 'jsimp@work.co.uk')
      result = helper.user_display_name(user)
      expect(result).to eq 'jsimp'
    end

    it 'should return John when first name is John and last name is empty' do
      user = mock_model(User, first_name: 'John')
      result = helper.user_display_name(user)
      expect(result).to eq "John"
    end

    it 'should return Simpson when first name is empty and last name is Simpson' do
      user = mock_model(User, last_name: 'Simpson')
      result = helper.user_display_name(user)
      expect(result).to eq "Simpson"
    end

    it 'should return Test User when first name is Test and last name is User' do
      user = FactoryGirl.build(:user)
      result = helper.user_display_name(user)
      expect(result).to eq "Test User"
    end
  end

  it 'creates a "link to youtube" button' do
    link = '/auth/gplus/?youtube=true&amp;origin=video_url'
    expect(helper.link_to_youtube_button('video_url')).to include(link)
  end

  it 'creates an "unlink from youtube" button' do
    link = '/auth/destroy/youtube?origin=video_url'
    expect(helper.unlink_from_youtube_button('video_url')).to include(link)
  end

  it 'creates a link to video' do
    video = { title: 'title', url: 'video_url', id: 'id_1', content: 'description' }
    link_attr = %w{class="yt_link" data-content="description" href="video_url" id="id_1" title}
    expect(helper.video_link(video)).to include(*link_attr)
  end

  it 'creates a link to youtube player' do
    video = { id: 'id_1' }
    link = 'http://www.youtube.com/embed/id_1?enablejsapi=1'
    expect(helper.video_embed_link(video)).to eq(link)
  end
end