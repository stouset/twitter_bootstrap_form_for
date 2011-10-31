require 'action_view'

module TwitterBootstrapFormFor
  autoload :FormBuilder, 'twitter_bootstrap_form_for/form_builder'
  autoload :FormHelpers, 'twitter_bootstrap_form_for/form_helpers'
  autoload :Railtie,     'twitter_bootstrap_form_for/railtie'
  autoload :VERSION,     'twitter_bootstrap_form_for/version'
end

TwitterBootstrapFormFor::Railtie # trigger loading the Railtie
