class ScrumsController < ApplicationController
  def index
    #@scrums = Scrum.all

    client = YouTubeIt::Client.new(:dev_key => "AIzaSyAh0CZ-jWpREV-3WtQ-4thTW0T-qU6_zrc")
    query = client.videos_by(:query => "agile ventures scrums", :page => 10)
    @scrums = query.videos.map(&:video_id).map{ |str| str.scan(/tag:youtube.com,\d+:video:(.+)/).last.first}
  end
end

