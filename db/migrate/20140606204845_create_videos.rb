class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :video_id
      t.string :title
      t.string :hangout_url

      t.timestamps
    end
  end
end
