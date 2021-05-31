# frozen_string_literal: true

class Authentication < ApplicationRecord
  belongs_to :user
  # Bryan: validation of user presence is done at the database level, model level will cause problems
  validates :provider, :uid, presence: true
  validates :provider, uniqueness: { scope: :user_id }
end
