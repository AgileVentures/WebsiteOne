# frozen_string_literal: true

class IssueTracker < ApplicationRecord
  belongs_to :project
end
