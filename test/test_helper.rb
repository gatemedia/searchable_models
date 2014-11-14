# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require "pry"
require "acts-as-taggable-on"
require "simplecov"
SimpleCov.start "rails"

require "minitest/reporters"
Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new)

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Run any available migration from dummy app
ActiveRecord::Migrator.migrate(File.expand_path("../dummy/db/migrate/", __FILE__))

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

class ActiveSupport::TestCase
  fixtures :all

  def assert_results(results)
    assert_equal [cars(:car_foo)], results
  end
end
