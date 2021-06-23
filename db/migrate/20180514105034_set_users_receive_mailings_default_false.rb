# frozen_string_literal: true

class SetUsersReceiveMailingsDefaultFalse < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :receive_mailings, from: true, to: false
  end
end
