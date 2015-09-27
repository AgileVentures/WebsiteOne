class CreateCommitCounts < ActiveRecord::Migration
  def change
    create_table :commit_counts do |t|
      t.integer :commit_count
      t.references :project, index: true
      t.references :user, index: true
    end
  end
end
