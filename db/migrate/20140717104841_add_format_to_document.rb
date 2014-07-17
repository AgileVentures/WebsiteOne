class AddFormatToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :format, :string, default: 'html'
  end
end
