# frozen_string_literal: true

class Plan < ApplicationRecord
  def free_trial?
    free_trial_length_days&.positive?
  end
end
