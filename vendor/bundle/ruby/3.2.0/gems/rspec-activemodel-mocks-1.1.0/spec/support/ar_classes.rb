ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

module Connections
  def self.extended(host)
    host.connection.execute <<-eosql
      CREATE TABLE #{host.table_name} (
        #{host.primary_key} integer PRIMARY KEY AUTOINCREMENT,
        associated_model_id integer,
        mockable_model_id integer,
        nonexistent_model_id integer
      )
    eosql
  end
end

module ConnectionsView
  def self.extended(host)
    host.connection.execute <<-eosql
      CREATE TABLE some_table (
        associated_model_id integer,
        mockable_model_id integer,
        nonexistent_model_id integer
      )
    eosql

    host.connection.execute <<-eosql
      CREATE VIEW #{host.table_name} AS
        select * from some_table;
    eosql
  end
end

class NonActiveRecordModel
  extend ActiveModel::Naming
  include ActiveModel::Conversion
end

class MockableModel < ActiveRecord::Base
  extend Connections
  has_one :associated_model
end

# (e.g. model backed database views)
class MockableModelNoPrimaryKey < ActiveRecord::Base
  extend ConnectionsView
end

class SubMockableModel < MockableModel
end

class AssociatedModel < ActiveRecord::Base
  extend Connections
  belongs_to :mockable_model
  belongs_to :nonexistent_model, :class_name => "Other"
end

class AlternatePrimaryKeyModel < ActiveRecord::Base
  self.primary_key = :my_id
  extend Connections
  attr_accessor :my_id
end
