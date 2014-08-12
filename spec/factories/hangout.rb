FactoryGirl.define do
  sequence :participant do |n|
    { name: "Participant_#{n}", gplus_id: "youtube_id_#{n}"}
  end

  factory :hangout do
    ignore do
      created Time.now
      updated Time.now
    end

    sequence(:title) { |n| "Hangout_#{n}"}
    sequence(:category) { |n| "Category_#{n}"}
    hangout_url "http://hangout.test"
    yt_video_id "yt_video_id"

    project
    event
    association :host, factory: :user

    participants { [(generate :participant), (generate :participant)] }

    created_at { Time.parse("#{created} UTC")}
    updated_at { Time.parse("#{updated} UTC")}
  end
end
