require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'time'

module LiveStreamService
  # This OAuth 2.0 access scope allows for read-only access to the authenticated
  # user's account, but not other types of account access.
  YOUTUBE_READONLY_SCOPE = 'https://www.googleapis.com/auth/youtube'
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'
  
  def self.get_authenticated_service
    client = Google::APIClient.new(
      :application_name => $PROGRAM_NAME,
      :application_version => '1.0.0'
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
  
    file_storage = Google::APIClient::FileStorage.new("#{$PROGRAM_NAME}-oauth2.json")
    if file_storage.authorization.nil?
      client_secrets = Google::APIClient::ClientSecrets.load
      flow = Google::APIClient::InstalledAppFlow.new(
        :client_id => client_secrets.client_id,
        :client_secret => client_secrets.client_secret,
        :scope => [YOUTUBE_READONLY_SCOPE]
      )
      client.authorization = flow.authorize(file_storage)
    else
      client.authorization = file_storage.authorization
    end
  
    return client, youtube
  end
  
  # Create a liveBroadcast resource and set its title, scheduled start time,
  # scheduled end time, and privacy status.
  def self.insert_broadcast(client, youtube, options)
    insert_broadcast_response = client.execute!(
      api_method: youtube.live_broadcasts.insert,
      parameters: {
        part: 'snippet,status'
      },
      body_object: {
        snippet: {
          title: options[:broadcast_title],
          scheduledStartTime: options[:start_time],
          scheduledEndTime: options[:end_time]
        },
        status: {
          privacyStatus: options[:privacy_status]
        }
      }
    )
  
    p "Broadcast: #{insert_broadcast_response.data.id}"
    return insert_broadcast_response.data.id
  end
  
  # Create a liveStream resource and set its title, format, and ingestion type.
  # This resource describes the content that you are transmitting to YouTube.
  def self.insert_stream(client, youtube, options)
    insert_stream_response = client.execute!(
      api_method: youtube.live_streams.insert,
      parameters: {
        part: "snippet,cdn",
      },
      body_object: {
        snippet: {
          title: options[:stream_title]
        },
        cdn: {
          format: "1080p",
          ingestionType: "rtmp"
        }
      }
    )
  
    p "Stream: #{insert_stream_response.data.cdn.ingestionInfo.streamName}"
    return insert_stream_response.data.id
  end
  
  # Bind the broadcast to the video stream. By doing so, you link the video that
  # you will transmit to YouTube to the broadcast that the video is for.
  def self.bind_broadcast(client, youtube, broadcast_id, stream_id)
    # bind_broadcast_response = youtube.liveBroadcasts().bind(
    #   part="id,contentDetails",
    #   id=broadcast_id,
    #   streamId=stream_id
    # ).execute()
    
    bind_broadcast_response = client.execute!(
      api_method: youtube.live_broadcasts.bind,
      parameters: {
        part: 'id,contentDetails',
        id: broadcast_id,
        streamId: stream_id
      }
    )
  
    p "Broadcast #{bind_broadcast_response.data.id}"\
      "was bound to stream #{bind_broadcast_response.data.contentDetails.boundStreamId}"
  end
  
  
  options = {
    stream_title: 'test',
    broadcast_title: 'test',
    start_time: Time.now.getutc.iso8601(3),
    end_time: '2018-01-30T00:01:00.000Z',
    privacy_status: 'private'
  }
  
  client, youtube = get_authenticated_service
  stream_id = insert_stream(client, youtube, options)
  broadcast_id = insert_broadcast(client, youtube, options)
  # stream_id = 'CNSDdM72mVvwG_Tn6ptkog1501146171928817'
  # broadcast_id = 'iRpcISisx1g'
  bind_broadcast(client, youtube, broadcast_id, stream_id)
  

end