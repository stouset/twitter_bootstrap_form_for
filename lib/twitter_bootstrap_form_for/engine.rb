require 'twitter_bootstrap_form_for'
require 'bootstrap-datepicker-rails'

module TwitterBootstrapFormFor
  autoload :FormBuilder, 'twitter_bootstrap_form_for/form_builder'
  autoload :FormHelpers, 'twitter_bootstrap_form_for/form_helpers'
  autoload :Datepicker, 'twitter_bootstrap_form_for/datepicker'
  autoload :VERSION,     'twitter_bootstrap_form_for/version'

  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_view) { include TwitterBootstrapFormFor::FormHelpers }
  end
end
