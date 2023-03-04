# frozen_string_literal: true

class EventInstancesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: %i(edit update_link update)

  def update
    @event_instance = EventInstance.find_or_create_by(uid: params[:id])
    if @event_instance.try!(:update, whitelist_params)
      send_messages_to_social_media @event_instance, whitelist_params, hangout_url_changed?
      redirect_to(event_path(params[:event_id])) && return if local_event?

      head :ok
    else
      head :internal_server_error
    end
  end

  def index
    relation = params[:live] == 'true' ? EventInstance.live : EventInstance.latest
    relation = relation.includes(:project, :event, :user)
    @event_instances = relation.paginate(page: params[:page], per_page: 6)
  end

  def edit
    @event_instance = EventInstance.find(params[:id])
  end

  def update_link
    @event_instance = EventInstance.find(params[:id])
    youtube_id = YouTubeRails.extract_video_id(event_instance_params[:yt_video_id])
    if youtube_id && @event_instance.update(yt_video_id: youtube_id, hoa_status: event_instance_params[:hoa_status])
      flash[:notice] = 'Hangout Updated'
    else
      flash[:alert] = 'Error.  Please Try again'
    end
    redirect_to edit_event_instance_path(@event_instance)
  end

  private

  def local_event?
    local_request? && params[:event_id].present?
  end

  def hangout_url_changed?
    @event_instance.hangout_url != whitelist_params[:hangout_url]
  end

  def send_messages_to_social_media(event, event_params, hangout_url_changed)
    begin
      HangoutNotificationService.with event if updating_hangout_url? event, hangout_url_changed
      YoutubeNotificationService.with event if updating_valid_yt_url? event, event_params
    rescue StandardError => e
      Rails.logger.error 'Error sending hangout notifications:'
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
      flash[:alert] = 'Ooops: Some or all hangout notifications may have not been posted.'
    end
    flash[:notice] = 'Hangout successfully posted'
  end

  def updating_hangout_url?(event, hangout_url_changed)
    (slack_notify_hangout? && event.hangout_url?) || (event.started? && hangout_url_changed)
  end

  def slack_notify_hangout?
    params[:notify_hangout] == 'true'
  end

  def updating_valid_yt_url?(event, event_params)
    (slack_notify_yt? && event.yt_video_id?) || yt_video_id_changed?(event, event_params)
  end

  def yt_video_id_changed?(event, event_params)
    event.yt_video_id != event_params[:yt_video_id]
  end

  def slack_notify_yt?
    params[:notify_yt] == 'true'
  end

  def event_instance_params
    params.require(:event_instance).permit(:yt_video_id, :hoa_status)
  end

  def local_request?
    request.env['HTTP_ORIGIN'].include?(request.env['HTTP_HOST'])
  rescue StandardError
    true
  end

  def whitelist_params
    params.require(:host_id)
    params.require(:title)

    transform_params.permit!
  end

  def transform_params
    ActionController::Parameters.new(
      title: params[:title],
      project_id: params[:project_id],
      event_id: params[:event_id],
      category: params[:category],
      user_id: params[:host_id],
      hangout_participants_snapshots_attributes: [{ participants: params[:participants] }],
      participants: params[:participants],
      hangout_url: params[:hangout_url],
      yt_video_id: YouTubeRails.extract_video_id(params[:yt_url]) || params[:yt_video_id],
      hoa_status: params[:hoa_status],
      url_set_directly: params[:url_set_directly],
      updated_at: Time.now,
      youtube_tweet_sent: params[:you_tube_tweet_sent]
    )
  end
end
