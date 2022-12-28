# frozen_string_literal: true

FactoryBot.define do
  factory :version, class: PaperTrail::Version do
    item_type { 'Document' }
    event { 'create' }
    object { nil }
    created_at { '2014-02-25 11:50:56' }
    item_id { 99 }
    whodunnit
  end
end
