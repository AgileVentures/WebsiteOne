require 'spec_helper'

describe ScrumsController do
  let(:query) { double :youtube_query }

  before do
    expect(YouTubeIt::Client).to receive(:new) { query }
    expect(query).to receive(:videos_by) { query }
    expect(query).to receive(:videos).and_return([
      {},
      {},
      {},
    ])
  end

  it 'test' do
    get :index
  end
end
