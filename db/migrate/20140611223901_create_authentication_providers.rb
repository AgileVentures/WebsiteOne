class CreateAuthenticationProviders < ActiveRecord::Migration
  def change
    create_table "authentication_providers", :force => true do |t|
      t.string   "name"
      t.datetime "created_at",                 :null => false
      t.datetime "updated_at",                 :null => false
    end
    add_index "authentication_providers", ["name"], :name => "index_name_on_authentication_providers"
    AuthenticationProvider.create(name: 'github')
    AuthenticationProvider.create(name: 'gplus')
  end
end

