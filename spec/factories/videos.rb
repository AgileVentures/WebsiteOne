# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video, :class => 'Videos' do
    video_id ""
    title "MyString"
    hangout_url "MyString"
  end
end
