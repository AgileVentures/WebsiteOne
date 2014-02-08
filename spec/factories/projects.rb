FactoryGirl.define do
  factory :project do
    sequence(:title) {|n| "Title #{n}"}
    description "Warp fields stabilize."
    status "We feel your presence."
  end
end