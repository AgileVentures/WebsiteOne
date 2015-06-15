require 'google/api_client'

class YouTube
  DEVELOPER_KEY = ENV['YOUTUBE_KEY'] || 'AIzaSyAYXJjUwwDKVEliqBxQ8AMbk7ocWJ-z4zw'
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def initialize(query, count)
    @query = query
    @count = count.to_i
  end

  def get_service
    client = Google::APIClient.new(
        key: DEVELOPER_KEY,
        authorization: nil,
        application_name: $PROGRAM_NAME,
        application_version: '1.0.0'
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    return client, youtube
  end

  def perform_query
    opts = {q: @query, max_results: @count, help: false}

    client, youtube = get_service

    begin
      search_response = client.execute!(
          api_method: youtube.search.list,
          parameters: {
              part: 'snippet',
              q: opts[:q],
              maxResults: opts[:max_results]
          }
      )
      videos = []

      search_response.data.items = search_response.data.items.sort {|vn1, vn2| vn2['snippet']['publishedAt'] <=> vn1['snippet']['publishedAt']}

      search_response.data.items.each do |search_result|
        search_result = search_result.as_json
        case search_result['id']['kind']
          when 'youtube#video'
            videos << {
                author: check_channel(search_result['snippet']['channelId']),
                id: search_result['id']['videoId'],
                published: search_result['snippet']['publishedAt'].to_date,
                title: search_result['snippet']['title'],
                content: search_result['snippet']['description'],
                url: "http://youtu.be/#{search_result['id']['videoId']}"}
        end
      end
       videos
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
  end

  def check_channel(channel)
    @query = channel
    opts = {q: @query, max_results: @count, help: false}

    client, youtube = get_service
    begin
      search_response = client.execute!(
          api_method: youtube.search.list,
          parameters: {
              part: 'snippet',
              q: opts[:q],
              maxResults: opts[:max_results]
          }
      )
      channels = []
      search_response.data.items.each do |search_result|
        search_result = search_result.as_json
        case search_result['id']['kind']
          when 'youtube#channel'
            channels << {
                author: search_result['snippet']['title']
            }
        end
      end
      channels.first[:author]
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
  end
end


