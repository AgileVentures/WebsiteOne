# frozen_string_literal: true

class LanguageProject < ApplicationRecord
  belongs_to :language
  belongs_to :project

  validates :language_id, uniqueness: { scope: :project_id }
end
