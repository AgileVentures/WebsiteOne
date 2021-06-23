# frozen_string_literal: true

FactoryBot.define do
  factory :commit_count do
    commit_count { rand(500) }
    user
    project
  end
end
