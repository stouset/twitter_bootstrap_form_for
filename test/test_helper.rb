# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

# Taken from simple_form.
# https://github.com/plataformatec/simple_form
class ActionView::TestCase
  include MiscHelpers
  include TwitterBootstrapFormFor::FormHelpers

  setup :setup_users

  def setup_users(extra_attributes = {})
    @user = User.new
  end

  def user_path(*args)
    '/users'
  end

  alias :users_path :user_path
end
