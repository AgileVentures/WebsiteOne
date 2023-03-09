# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    sequence(:title) { |n| "Course #{n}" }
    sequence(:slug) { |n| "course-#{n}" }
    description { 'Warp fields stabilize.' }
    status { 'active' }
  end
end