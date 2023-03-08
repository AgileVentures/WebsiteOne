# frozen_string_literal: true

class Course < ApplicationRecord
  extend FriendlyId
  include Filterable
  friendly_id :title, use: %i(slugged history)

  validates :title, :description, :status, presence: true
  validates :description, presence: true, length: { minimum: 5 }

  belongs_to :user, optional: true
  include UserNullable

  scope :active, -> { where('status ILIKE ?', 'active').order(:title) }

  def slack_channel
    "https://agileventures.slack.com/app_redirect?channel=#{slack_channel_name}"
  end
end
