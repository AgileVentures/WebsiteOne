class Plan < ApplicationRecord
  def free_trial?
    free_trial_length_days && free_trial_length_days > 0
  end
end
