class CreateUserAuthentications < ActiveRecord::Migration
  def change
    create_table "user_authentications", :force => true do |t|
      t.integer  "user_id"
      t.integer  "authentication_provider_id"
      t.string   "uid"
      t.string   "token"
      t.datetime "token_expires_at"
      t.text     "params"
      t.datetime "created_at",                 :null => false
      t.datetime "updated_at",                 :null => false
    end
    add_index "user_authentications", ["authentication_provider_id"], :name => "index_user_authentications_on_authentication_provider_id"
    add_index "user_authentications", ["user_id"], :name => "index_user_authentications_on_user_id"
  end
end

