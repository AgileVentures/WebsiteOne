# frozen_string_literal: true

FactoryBot.define do
  sequence :participant do |n|
    { n.to_s => { 'person' => { displayName: "Participant_#{n}", 'id' => "youtube_id_#{n}", isBroadcaster: 'false' } } }
  end
  sequence :broadcaster do |n|
    { (n - 1).to_s => { 'person' => { displayName: "Broadcaster#{n}", 'id' => "youtube_id_#{n}",
                                      isBroadcaster: 'true' } } }
  end

  factory :event_instance do
    transient do
      created { Time.now }
      updated { Time.now }
    end

    project
    event
    user
    sequence(:uid) { |n| "uid_#{n}" }
    sequence(:title) { |n| "Hangout_#{n}" }
    sequence(:category) { |n| "Category_#{n}" }
    hangout_url { 'http://hangout.test' }
    sequence(:yt_video_id) { |n| "yt_video_id_#{n}" }

    participants { ActionController::Parameters.new((generate :broadcaster).merge(generate(:participant))) }

    created_at { Time.parse("#{created} UTC") }
    updated_at { Time.parse("#{updated} UTC") }

    factory :live_event_instance do
      association :event, factory: :recent_event
    end
  end
end
