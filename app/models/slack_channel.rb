# frozen_string_literal: true

class SlackChannel < ApplicationRecord
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :events
end
