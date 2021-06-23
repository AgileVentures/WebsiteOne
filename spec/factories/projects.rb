# frozen_string_literal: true

FactoryBot.define do
  sequence(:tag) { |n| "tag_#{n}" }

  factory :project do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:slug) { |n| "title-#{n}" }
    description { 'Warp fields stabilize.' }
    pitch { "'I AM the greatest!' - M. Ali" }
    status { 'We feel your presence.' }

    factory :project_with_tags do
      transient do
        tags { [generate(:tag), generate(:tag)] }
      end

      after(:create) do |project, evaluator|
        project.tag_list.add(*evaluator.tags)
        project.save
      end
    end
  end
end
