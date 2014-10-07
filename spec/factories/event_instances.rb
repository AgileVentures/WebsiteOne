FactoryGirl.define do
  sequence :participant do |n|
    [ "#{n}", { :person => { displayName: "Participant_#{n}", id: "youtube_id_#{n}" } } ]
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
    yt_video_id "yt_video_id"

    project
    event
    user

    participants { [(generate :participant), (generate :participant)] }

    start { Time.parse("#{created} UTC")}
    heartbeat { Time.parse("#{updated} UTC")}
  end
end
