require "helper"
require "rails/generators"
require "generators/friendly_id_generator"

class FriendlyIdGeneratorTest < Rails::Generators::TestCase
  tests FriendlyIdGenerator
  destination File.expand_path("../../tmp", __FILE__)

  setup :prepare_destination

  test "should generate a migration" do
    run_generator
    assert_migration "db/migrate/create_friendly_id_slugs"
  ensure
    FileUtils.rm_rf destination_root
  end

  test "should skip the migration when told to do so" do
    run_generator ["--skip-migration"]
    assert_no_migration "db/migrate/create_friendly_id_slugs"
  ensure
    FileUtils.rm_rf destination_root
  end

  test "should generate an initializer" do
    run_generator
    assert_file "config/initializers/friendly_id.rb"
  ensure
    FileUtils.rm_rf destination_root
  end

  test "should skip the initializer when told to do so" do
    run_generator ["--skip-initializer"]
    assert_no_file "config/initializers/friendly_id.rb"
  ensure
    FileUtils.rm_rf destination_root
  end
end
