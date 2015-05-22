FactoryGirl.define do
  sequence :participant do |n|
    [ "#{n}", { :person => { displayName: "Participant_#{n}", id: "youtube_id_#{n}", isBroadcaster: 'false' } } ]
  end
  sequence :broadcaster do |n|
    [ "#{n}", { :person => { displayName: "Broadcaster#{n}", id: "youtube_id_#{n}", isBroadcaster: 'true' } } ]
  end

  factory :event_instance do
    ignore do
      created Time.now
      updated Time.now
    end

    sequence(:uid) { |n| "uid_#{n}"}
    sequence(:title) { |n| "Hangout_#{n}"}
    sequence(:category) { |n| "Category_#{n}"}
    hangout_url "http://hangout.test"
    sequence(:yt_video_id) { |n| "yt_video_id_#{n}"}

    project
    event
    user

    participants { [(generate :broadcaster), (generate :participant)] }

    created_at { Time.parse("#{created} UTC")}
    updated_at { Time.parse("#{updated} UTC")}
  end
end
