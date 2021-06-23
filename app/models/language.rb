# frozen_string_literal: true

class Language < ApplicationRecord
  has_and_belongs_to_many :projects

  validates :name, presence: true, uniqueness: true
end
