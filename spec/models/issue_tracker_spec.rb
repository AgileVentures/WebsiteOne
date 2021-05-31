# frozen_string_literal: true

describe IssueTracker, type: :model do
  it { is_expected.to belong_to :project }
end
