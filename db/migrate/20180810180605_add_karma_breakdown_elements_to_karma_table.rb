# frozen_string_literal: true

class AddKarmaBreakdownElementsToKarmaTable < ActiveRecord::Migration[5.1]
  def change
    add_column :karmas, :membership_length, :integer, default: 0
    add_column :karmas, :profile_completeness, :integer, default: 0
    add_column :karmas, :number_github_contributions, :integer, default: 0
    add_column :karmas, :activity, :integer, default: 0
    add_column :karmas, :event_participation, :integer, default: 0
  end
end
