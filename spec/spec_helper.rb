require "database_cleaner/active_record"
require "standalone_activerecord_boot_loader"
require "gizzard"

ENV['RAILS_ENV'] ||= 'test'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

DUMMY_APP_ROOT = Pathname.new(__dir__).join('dummy')

instance = StandaloneActiverecordBootLoader::Instance.new(
  DUMMY_APP_ROOT,
  env: ENV['RAILS_ENV']
)
instance.execute
