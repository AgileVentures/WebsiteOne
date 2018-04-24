class AddEmailsOptInToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :emails_opt_in, :boolean
  end
end
