require 'spec_helper'

describe UsersHelper do
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
