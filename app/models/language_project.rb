# frozen_string_literal: true

class LanguageProject < ApplicationRecord
  belongs_to :language
  belongs_to :project

  validates_uniqueness_of :language_id, scope: :project_id
end
