FactoryGirl.define do
  sequence(:tag) {|n| "tag_#{n}"}

  factory :project do
    sequence(:title) {|n| "Title #{n}"}
    description "Warp fields stabilize."
    status "We feel your presence."

    factory :project_with_tags do
      ignore do
        tags { [generate(:tag), generate(:tag)] }
      end

      after(:create) do |project, evaluator|
        project.tag_list.add(*evaluator.tags)
        project.save
      end
    end
  end

end
