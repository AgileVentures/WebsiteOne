# frozen_string_literal: true

class CreateIssueTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :issue_trackers do |t|
      t.string :url
      t.references :project

      t.timestamps null: false
    end
  end
end
