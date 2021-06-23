# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :status do
    status { Status::OPTIONS[rand(Status::OPTIONS.length)] }
    user
  end
end
