class ScrumsController < ApplicationController
  def index
    client = YouTubeIt::Client.new(:dev_key => Youtube::YOUTUBE_KEY)
    query = client.videos_by(:query => "AtlanticScrum|AmericasScrum|EuroScrum Pair Hookup", 
                             :order_by => :published,
                             :max_results => 20)
    @scrums = query.videos.map { |video| YoutubeHelper.video_data(video) }
  end
end
